---
title: Deployment Project Template
last revised: 2022/04/10
---

Note: Many of the examples are stubs or not yet functions.

This is just a learning/demonstration of several different tools in the DevOps space.  My ultimate goal is to have a unified environment running tools locally to develop in a kubernetes environment, but to also quickly deploy a "production" ready application.  In my case, I'm probably going to use a single vm running K3s/K3OS for cost reasons.

The goal is to create a solution where this can be accessed via [Visual Studio Code](https://code.visualstudio.com/) and the [Remote-Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension.

For local development, I built this solution with [Rancher Desktop](https://rancherdesktop.io/) and Windows in mind.  You may need to update the mounts section of the devcontainer.json file if you are using a different solution.  You will need to toggle your Kubernetes Settings to use the dockerd (moby) Container Runtime.  Ultimately I may update to use containerd runtime, but devcontainers don't use that currently.

I started building out example terraform and ansible-pull projects.  I'm not sure where I'm going to go with those, but I was thinking through which tools I'd use for this solution.  At first I was thinking Terraform, and ultimately I may change my mind, but I think it's far more interesting to use Crossplane.  The downside to crossplane is that in a local situation, it requires a bit more effort to stand up an environment, so I decided Ansible was reasonable to handle that task.

NOTE: Currently there's a bug in WSL2 that affects devcontainers.  Terraform is impacted.  before running terraform commands vim into /etc/resolve.conf and set the nameserver to 1.1.1.1 or 8.8.8.8, something like that.  This is just a workaround, so I'm not going to update the files to automatically fix. --[Github issue](https://github.com/microsoft/WSL/issues/8022)

## Features

Currently the dev environment (debian) installs several languages (Go, Rust, Python), several cli tools (kubectl, helm, argo, crossplane, github, azure, aws, k9s), and some useful tools in general (git, ansible, terraform).  In addition, Ansible via Helm is used to deploy ArgoCD and Crossplane to the local cluster.

- To access argocd UI:
  - `open http://argocd.127.0.0.1.nip.io`
  - Username is admin
  - Password is `kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo`
- To access traefik dashboard:
  - `open http://traefik.127.0.0.1.nip.io/dashboard/`

## Issues

- expose Argo UI through traefik
- fix nfs role "(0x425)\nexportfs: /opt/temp does not support NFS export)"
- apt install kubectx not found
- Getting Rancher Running
  - cert-manager-webhook has to be forwarded in order to install rancher.
  - docker logs 33691a6be011 2>&1 | grep "Bootstrap Password:" run in wsl- look for last rancher/rancher containerid

## Notes

### Useful commands

- `helm show values traefik/traefik > temp/traefik-values.yaml`

### Multiple kubectx

```bash
export KUBECONFIG=~/.kube/config:~/someotherconfig 
kubectl config view --flatten
```

### [dynamic nfs provisioning](https://www.youtube.com/watch?v=DF3v2P8ENEg)

- https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner
- https://phoenixnap.com/kb/nfs-docker-volumes
- https://github.com/justmeandopensource/kubernetes

in traefik/values.yaml

```yaml
persistence:
  enabled: true
```

### [ARGOCD](https://argo-cd.readthedocs.io/en/stable/getting_started/)

#### https://argo-cd.readthedocs.io/en/stable/operator-manual/ingress/#traefik-v22

helm upgrade --install argocd argo/argo-cd --namespace argocd --set server.ingress.hosts="{argocd.$INGRESS_HOST.nip.io}" --wait

kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

Go into Rancher Desktop / Port Forwarding ?

## Reference

### Tooling

- [Python](https://www.python.org/)
- [Go](https://go.dev/)
- [Rust](https://www.rust-lang.org/)
- [Ansible](https://www.ansible.com/)
- [Terraform](https://www.terraform.io/)
- [Rustup](https://rust-lang.github.io/rustup/index.html)
- [devcontainers](https://aka.ms/devcontainer.json)
- [GitHub Actions Azure Login](https://github.com/marketplace/actions/azure-login)
- [K9s](https://k9scli.io/)
- [kubectx](https://github.com/ahmetb/kubectx)

### Deployment Features

- [Argo CD](https://argoproj.github.io/cd)
- [Argo CD Cli](https://argo-cd.readthedocs.io/en/stable/cli_installation/)
- [Kubectl Krew plugin manager](https://krew.sigs.k8s.io/docs/user-guide/quickstart/)
- [Krew plugins list](https://krew.sigs.k8s.io/plugins/)
- [kubectl cert-manager plugin](https://github.com/cert-manager/cert-manager)
- [kubectl ctx plugin](https://github.com/ahmetb/kubectx)
- [kubectl kyverno plugin](https://github.com/kyverno/kyverno)
- [Argo Workflows?](https://argoproj.github.io/argo-workflows)
- [Loki in grafana](http://docs.grafana.org/features/datasources/loki/)
- [Ansible k8s Object](https://docs.ansible.com/ansible/latest/collections/kubernetes/core/k8s_module.html#ansible-collections-kubernetes-core-k8s-module)

### Helm Charts

- [Crossplane](https://crossplane.io/docs/v1.7/reference/install.html)
- [Argo CD](https://github.com/argoproj/argo-helm/tree/master/charts/argo-cd)
- [Loki](https://grafana.com/docs/loki/latest/installation/helm/)
- [Harbor](https://goharbor.io/docs/2.4.0/install-config/harbor-ha-helm/)

### To Add

- [Kanikio](https://github.com/GoogleContainerTools/kaniko)
- [Kubevela](https://kubevela.io/)
- [Argo Rollouts](https://argoproj.github.io/argo-rollouts/)
- [vCluster](https://www.vcluster.com/docs/what-are-virtual-clusters)
- [Kubescape](https://github.com/armosec/kubescape)
- [Synk GH Actions](https://github.com/marketplace/actions/snyk)
