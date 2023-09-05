#!/bin/bash

argo_version=$(curl "https://api.github.com/repos/argoproj/argo-cd/tags" | jq -r '.[0].name')

kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/${argo_version}/manifests/install.yaml

helm repo add jetstack https://charts.jetstack.io
helm repo add traefik https://helm.traefik.io/traefik
helm repo update

kubectl apply -f manifests/cert-manager/argocd.yaml -n argocd
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.12.0/cert-manager.crds.yaml
kubectl apply -f manifests/traefik/argocd.yaml -n argocd

#kubectl config set-context --current --namespace=argocd
#argocd login --core
#argocd app sync argocd/cert-manager
#argocd app sync argocd/traefik
#argocd app list
#kubectl config set-context --current --namespace=""
#kubectl apply -f manifests/cert-manager/local/clusterissuer.yaml
#kubectl apply -f manifests/argocd/local/
#kubectl apply -f manifests/traefik/local/