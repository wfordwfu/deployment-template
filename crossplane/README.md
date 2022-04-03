---
title: Crossplane Demo Solution
last reviewed: 2022-04-02
---
Notes from [Getting Started](https://crossplane.io/docs/v1.7/getting-started/install-configure.html)
And Anais Urlichs day 25 of Kubernetes

Download az credentials (start in project root- I don't understand why):

```bash
az login
cd crossplane
az ad sp create-for-rbac --role Owner > "creds.json"
```

upload credentials into secret for crossplane:

```bash
kubectl create secret generic azure-creds -n crossplane-system --from-file=creds=./creds.json
```

kubectl apply -f ./aks.yaml
