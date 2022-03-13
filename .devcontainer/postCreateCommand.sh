#!/usr/bin/env bash

echo "alias open='xdg-open'" | tee -a $HOME/.zshrc
git clone \
https://github.com/zsh-users/zsh-autosuggestions \
$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions

#git clone \
#git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
#$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

sed -i.bak 's/\(^plugins=([^)]*\)/\1 git kubectl minikube zsh-autosuggestions helm/' $HOME/.zshrc
