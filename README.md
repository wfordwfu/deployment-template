---
title: Deployment Project Template
last revised: 2022/04/16
---

Project in development

This is just a learning/demonstration of several different tools in the DevOps/GitOps space.  My ultimate goal is to have a unified environment running tools locally to develop in a kubernetes environment, but to also quickly deploy a "production" ready application.  In my case, I'm probably going to target a single vm running K3s/K3OS for flexibility/cost reasons.

The goal is to create a solution where this can be accessed via [Visual Studio Code](https://code.visualstudio.com/) and the [Remote-Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension.

For local development, I built this solution with [Rancher Desktop](https://rancherdesktop.io/) and Windows in mind.  You may need to update the mounts section of the devcontainer.json file if you are using a different solution.  You will need to toggle your Kubernetes Settings to use the dockerd (moby) Container Runtime.  Ultimately I may update to use containerd runtime, but devcontainers don't use that currently.

I started building out example terraform and ansible-pull projects.  I'm not sure where I'm going to go with those, but I was thinking through which tools I'd use for this solution.  At first I was thinking Terraform, and ultimately I may change my mind, but I think it's far more interesting to use Crossplane.  The downside to crossplane is that in a local situation, it requires a bit more effort to stand up an environment, so I decided Ansible was reasonable to handle that task.

NOTE: Currently there's a bug in WSL2 that affects devcontainers.  Terraform is impacted.  before running terraform commands vim into /etc/resolve.conf and set the nameserver to 1.1.1.1 or 8.8.8.8, something like that.  This is just a workaround, so I'm not going to update the files to automatically fix. --[Github issue](https://github.com/microsoft/WSL/issues/8022)

## Features

Currently the dev environment (debian) installs several languages (Go, Rust, Python), several cli tools (kubectl, helm, argo, crossplane, github, azure, aws, k9s), and some useful tools in general (git, ansible, terraform).  In addition, Ansible via Helm is used to deploy ArgoCD and Crossplane to the local cluster.

- To access traefik dashboard:
  - `open http://dashboard.traefik.127.0.0.1.sslip.io`
- To access argocd UI:
  - `open http://argocd.127.0.0.1.sslip.io`
  - Username is admin
  - Password is `kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo`

## Getting Started

- Install WSL2
- Install Rancher Desktop
- Install VSCode and Remote-Containers Extension

## Issues/future enhancements

- apt install kubectx not found
- Configure NFS Server ?
  - sudo apt-get install rpcbind nfs-kernel-server nfs-common
  - echo "/nfsshare *(rw,sync,no_subtree_check,no_root_squash,no_all_squash,insecure)" | sudo tee -a /etc/exports
  - sudo mkdir -p /run/sendsigs.omit.d/
  - sudo mkdir -p /nfsshare
  - sudo chown nobody:nogroup /nfsshare
  - sudo chmod 777 /nfsshare
  - sudo service rpcbind restart
  - sudo service nfs-kernel-server restart
  - sudo exportfs -rav
  - ip a | grep eth0

```bash
ip a | grep eth0
6: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    inet 192.168.51.164/20 brd 192.168.63.255 scope global eth0
```

## Notes

### Useful commands

- `helm show values traefik/traefik > temp/traefik-values.yaml`

### Traefik/Lets Encrypt notes

Local environment is using a self signed cert.  Environments that are publically accessible should at a minimum use Let's Encrypt.

Example to connect traefik to lets encrypt, but won't work in dev (needs to be on public internet):

```yaml
---
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-staging
spec:
  acme:
    # You must replace this email address with your own.
    # Let's Encrypt will use this to contact you about expiring
    # certificates, and issues related to your account.
    email: user@example.com
    server: https://acme-staging-v02.api.letsencrypt.org/directory
#     server: https://acme-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      # Secret resource that will be used to store the account's private key.
      name: letsencrypt-stage
  #    name: letsencrypt-prod
    solvers:
    - http01: {}
    # ingress:
    #   class: traefik
```

### Multiple kubectx

```bash
export KUBECONFIG=~/.kube/config:~/someotherconfig 
kubectl config view --flatten
```

### [dynamic nfs provisioning](https://www.youtube.com/watch?v=DF3v2P8ENEg)

- `open https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner`
- `open https://phoenixnap.com/kb/nfs-docker-volumes`
- `open https://github.com/justmeandopensource/kubernetes`

in traefik/values.yaml

```yaml
persistence:
  enabled: true
```

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

- [cert-manager](https://cert-manager.io/docs/)
- [Traefik proxy](https://doc.traefik.io/traefik/)
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
