---
title: Crossplane Demo Solution
last reviewed: 2022-04-02
---
Notes from [Getting Started](https://crossplane.io/docs/v1.7/getting-started/install-configure.html)
And Anais Urlichs day 25 of Kubernetes
And DevOpsToolkit (Victor Farcic)

Steps to get started:

```bash
# Download az credentials (start in project root- I don't understand why):
az login
cd crossplane
az ad sp create-for-rbac --role Owner > "creds.json"
# upload credentials into secret for crossplane namespace:
kubectl create secret generic azure-creds -n crossplane-system --from-file=creds=./creds.json
# Install azure provider
kubectl apply -f ./installazureprovider.yaml
# Verify provider
kubectl get providers
# Configure the provider
kubectl apply -f ./ProviderConfig.yaml
# Create the resource group
kubectl apply -f ./provision-rg.yaml
kubectl get resourcegroups
kubectl describe resourcegroups crossplane-rg
```





Warning  CannotConnectToProvider  52s (x2 over 52s)    managed/resourcegroup.azure.crossplane.io  cannot get authorizer from client credentials config: failed to get SPT from client credentials: parameter 'activeDirectoryEndpoint' cannot be empty