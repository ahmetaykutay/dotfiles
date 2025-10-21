#!/bin/sh

# install powerline fonts
git clone https://github.com/powerline/fonts.git
cd fonts
./install.sh
cd .. && rm -rf fonts

# install oh-my-zsh plugins
zsh -c 'git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting'
zsh -c 'git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions'
zsh -c 'git clone https://github.com/zdharma-continuum/fast-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting'
zsh -c 'git clone https://github.com/marlonrichert/zsh-autocomplete ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autocomplete'
zsh -c 'git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search'

# install additional software packages using apt (keep it at minimum)
sudo apt update && \
	sudo apt install exa bat ripgrep stow -y

# stow the config file from dotfiles into the container
cd ~/dotfiles
rm -rf .git

stow -t ~/ nvim
stow -t ~/ tmux

rm ~/.zshrc
cp -v zsh/.zshrc ~/.zshrc.bak
stow -t ~/ zsh

# install fzf manually (throws error when installed through binary)
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish
echo "export FZF_HOME=~/.fzf" >> ~/.zshrc
echo "export PATH=\$FZF_HOME/bin:\$PATH" >> ~/.zshrc
echo "[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh \n" >> ~/.zshrc

# switch to zsh
echo "zsh" >> ~/.bashrc
