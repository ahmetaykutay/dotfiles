#!/usr/bin/env bash

# -------- CONFIG --------
USER_HOME="${HOME:-/home/$(whoami)}"
DOTFILES_DIR="${USER_HOME}/dotfiles"
ZSH_CUSTOM="${ZSH_CUSTOM:-${USER_HOME}/.oh-my-zsh/custom}"
NEOVIM_TMP="nvim-linux-x86_64.tar.gz"
NEOVIM_OPT_DIR="/opt/nvim-linux-x86_64"
FZF_DIR="${USER_HOME}/.fzf"
# ------------------------

info() { printf '\033[1;34m%s\033[0m\n' "$*"; }
warn() { printf '\033[1;33m%s\033[0m\n' "$*"; }
err()  { printf '\033[1;31m%s\033[0m\n' "$*"; }

# Ensure we have sudo for system installs
if ! command -v sudo >/dev/null 2>&1; then
  echo "sudo is required. Install it first (or run this as root)."
  apt update -y
  apt install -y sudo
fi

info "Updating apt and installing packages..."
sudo apt update -y
sudo apt install -y \
    ca-certificates \
    curl \
    unzip \
    git \
    exa \
    bat \
    ripgrep \
    stow \
    tmux \
    zsh \
    rsync || {
      warn "apt install returned non-zero — continuing if packages are already satisfied."
    }

# --- oh-my-zsh (noninteractive) ---
info "Installing oh-my-zsh (noninteractive)..."
export RUNZSH="no"      
export CHSH="no"        
export KEEP_ZSHRC="yes" 

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

mkdir -p "${ZSH_CUSTOM}/plugins"

# --- fonts (Powerline) ---
if [ ! -d "${USER_HOME}/.local/share/fonts" ] || [ ! -f "${USER_HOME}/.local/share/fonts/PowerlineSymbols.ttf" ]; then
  info "Installing Powerline fonts for the current user..."
  tmpf="$(mktemp -d)"
  git clone --depth 1 https://github.com/powerline/fonts.git "${tmpf}/fonts"
  bash "${tmpf}/fonts/install.sh" || warn "Powerline fonts installer exited non-zero"
  rm -rf "${tmpf}"
else
  info "Powerline fonts already appear installed; skipping."
fi

# --- oh-my-zsh plugins (cloned into custom plugin dir) ---
info "Installing oh-my-zsh plugins..."
plugins=(
  "https://github.com/zsh-users/zsh-syntax-highlighting"
  "https://github.com/zsh-users/zsh-autosuggestions"
  "https://github.com/zdharma-continuum/fast-syntax-highlighting"
  "https://github.com/marlonrichert/zsh-autocomplete"
  "https://github.com/zsh-users/zsh-history-substring-search"
)
for repo in "${plugins[@]}"; do
  name="$(basename "${repo}" .git)"
  target="${ZSH_CUSTOM}/plugins/${name}"
  if [ -d "${target}" ]; then
    info "Plugin ${name} already cloned; pulling updates..."
    git -C "${target}" pull --ff-only || warn "Could not pull ${name}, skipping update."
  else
    git clone --depth 1 "${repo}" "${target}" || warn "Failed to clone ${repo}"
  fi
done

# # --- dotfiles: remove .git safely only if it's the dotfiles repo and exists ---
# if [ -d "${DOTFILES_DIR}" ]; then
#   if [ -d "${DOTFILES_DIR}/.git" ]; then
#     info "Removing git metadata from ${DOTFILES_DIR} (if this is intended)..."
#     # Safety: only remove .git inside the DOTFILES_DIR
#     rm -rf "${DOTFILES_DIR}/.git"
#   fi
# else
#   warn "Dotfiles directory ${DOTFILES_DIR} does not exist — stow steps later may fail."
# fi

# --- Neovim ---
info "Installing Neovim to ${NEOVIM_OPT_DIR}..."
curl -L -o "${NEOVIM_TMP}" "https://github.com/neovim/neovim/releases/latest/download/${NEOVIM_TMP}"
sudo rm -rf "${NEOVIM_OPT_DIR}"
sudo mkdir -p /opt
sudo tar -C /opt -xzf "${NEOVIM_TMP}"
sudo mv /opt/nvim-linux-x86_64 "${NEOVIM_OPT_DIR}"
rm -f "${NEOVIM_TMP}"

# Add symlink to /usr/local/bin for convenience (idempotent)
if [ -x "${NEOVIM_OPT_DIR}/bin/nvim" ] && [ ! -L "/usr/local/bin/nvim" ]; then
  sudo ln -sf "${NEOVIM_OPT_DIR}/bin/nvim" /usr/local/bin/nvim
  info "Linked nvim -> /usr/local/bin/nvim"
fi

# --- stow dotfiles ---
info "Running stow for nvim/tmux/zsh (if dotfiles exist)..."
spackages=(
    nvim
    tmux
    zsh
)
if [ -f "${USER_HOME}/.zshrc" ] && [ ! -f "${USER_HOME}/.zshrc.bak" ]; then
  cp -v "${USER_HOME}/.zshrc" "${USER_HOME}/.zshrc.bak" || warn "Failed to backup existing .zshrc"
fi
rm -v ~/.zshrc

if [ -d "${DOTFILES_DIR}" ]; then
  (
    cd "${DOTFILES_DIR}"
    for pkg in spackages; do
      if [ -d "${pkg}" ]; then
        stow -v -t "${USER_HOME}" "${pkg}" || warn "stow failed for ${pkg}"
      else
        warn "Skipping stow for ${pkg}: directory not present in ${DOTFILES_DIR}"
      fi
    done
  )
else
  warn "Skipping stow because ${DOTFILES_DIR} is missing."
fi

export ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    "$ZSH_CUSTOM/themes/powerlevel10k"

# --- fzf ---
if [ ! -d "${FZF_DIR}" ]; then
  info "Installing fzf from source..."
  git clone --depth 1 https://github.com/junegunn/fzf.git "${FZF_DIR}" || warn "Failed to clone fzf"
  "${FZF_DIR}/install" --key-bindings --completion --no-update-rc --no-bash --no-fish || warn "fzf install returned non-zero"
else
  info "fzf already installed; running install script to ensure completion/keybindings..."
  "${FZF_DIR}/install" --key-bindings --completion --no-update-rc --no-bash --no-fish || warn "fzf reinstall returned non-zero"
fi

# Add fzf env into .zshrc if not already present
if ! grep -q 'export FZF_HOME=~/.fzf' "${USER_HOME}/.zshrc" 2>/dev/null; then
  {
    echo ""
    echo "# fzf configuration"
    echo "export FZF_HOME=~/.fzf"
    echo 'export PATH="$FZF_HOME/bin:$PATH"'
    echo '[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh'
  } >> "${USER_HOME}/.zshrc"
  info "Appended fzf configuration to ~/.zshrc"
fi

# --- set default shell to zsh ---
if [ "$SHELL" != "$(command -v zsh)" ]; then
  if chsh -s "$(command -v zsh)" "$(whoami)" >/dev/null 2>&1; then
    info "Default shell changed to zsh for user $(whoami)."
  else
    warn "Could not change default shell automatically. You can run: chsh -s $(command -v zsh)"
  fi
else
  info "zsh is already the default shell."
fi

# For systems using bash login, add a line to ~/.bashrc to start zsh only if interactive and not already in zsh
if ! grep -q 'exec zsh' "${USER_HOME}/.bashrc" 2>/dev/null; then
  echo "" >> "${USER_HOME}/.bashrc"
  echo "# Launch zsh if interactive and not already running" >> "${USER_HOME}/.bashrc"
  echo 'if [ -t 1 ] && [ -n "$ZSH_VERSION" ]; then :; else exec zsh; fi' >> "${USER_HOME}/.bashrc"
  info "Appended zsh exec logic to ~/.bashrc"
fi

info "Bootstrap complete. Please open a new terminal (or log out/log in) to ensure environment changes take effect."
