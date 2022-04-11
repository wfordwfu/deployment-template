#!/usr/bin/env bash

echo "alias open='xdg-open'" | tee -a $HOME/.zshrc
git clone \
https://github.com/zsh-users/zsh-autosuggestions \
$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions

helm plugin install https://github.com/databus23/helm-diff

#git clone \
#git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
#$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

sed -i.bak 's/\(^plugins=([^)]*\)/\1 git kubectl minikube zsh-autosuggestions helm/' $HOME/.zshrc
echo '''export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"''' >> $HOME/.zshrc

ansible-playbook .devcontainer/local.yml
