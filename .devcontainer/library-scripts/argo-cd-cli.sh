#!/usr/bin/env bash

curl -sSL -o argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
mv -f argocd /usr/local/bin
chmod +x /usr/local/bin/argocd