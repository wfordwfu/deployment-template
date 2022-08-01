#!/usr/bin/env bash

echo "Installing zsh configs"

git clone \
https://github.com/zsh-users/zsh-autosuggestions \
$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions

git clone \
https://github.com/zsh-users/zsh-syntax-highlighting \
$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

sed -i.bak 's/\(^plugins=([^)]*\)/\1 git kubectl minikube zsh-autosuggestions helm zsh-syntax-highlighting/' $HOME/.zshrc

echo '''export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"''' >> $HOME/.zshrc
echo "alias open='xdg-open'" | tee -a $HOME/.zshrc