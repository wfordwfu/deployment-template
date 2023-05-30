#!/usr/bin/env bash

shopt -s expand_aliases

[ -e $HOME/.zshrc ] && rm $HOME/.zshrc
[ -e $HOME/.bashrc ] && rm $HOME/.bashrc
[ -d $HOME/.oh-my-zsh ] && rm -rf $HOME/.oh-my-zsh
[ -d $HOME/.cfg ] && rm -rf $HOME/.cfg

sudo chown -R $(whoami) /home/linuxbrew/.linuxbrew

sudo update-locale LANG=en_US.UTF-8 LC_CTYPE=en_US.UTF-8

mkdir -p $HOME/.cfg

git clone --bare https://github.com/wfordwfu/dotfiles.git $HOME/.cfg

alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

config checkout

config config --local status.showUntrackedFiles no

source $HOME/.zshenv

sudo chown -R 1000:1000 /usr/local/share/kube-localhost

if [[ -d /home/linuxbrew/.linuxbrew/bin ]]; then
  brewpath="/home/linuxbrew/.linuxbrew/bin"
else
  brewpath="/opt/homebrew/bin"
fi

${brewpath}/brew install -q fnm
${brewpath}/brew install -q ansible
${brewpath}/brew install -q terraform
${brewpath}/brew install -q gh
${brewpath}/brew install -q azure-cli
${brewpath}/brew install -q rust
${brewpath}/brew install -q awscli
${brewpath}/brew install -q kubernetes-cli
${brewpath}/brew install -q helm
${brewpath}/brew install -q zsh-autosuggestions
${brewpath}/brew install -q zsh-syntax-highlighting
${brewpath}/helm plugin install https://github.com/databus23/helm-diff

# ansible-playbook .devcontainer/local.yml
