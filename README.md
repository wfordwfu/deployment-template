---
title: Deployment Project Template
last revised: 2022/09/05
---

## Project Status - in development

This is an active learning/demonstration of several different tools in the DevOps/GitOps space.  Feel free to use this as inspiration for your own work, but this is not a turn-key solution.  My ultimate goal is to have a unified environment running tools locally to develop in a kubernetes environment, but to also quickly deploy a "production" ready environment and application on prem or cloud.

For local development, I built this solution with [Rancher Desktop](https://rancherdesktop.io/) and Windows in mind.  

I had been experimenting with using devcontainers as a solution to create consistent and ephemeral development environments, but there are headaches in that solution.  First, it's still reliant on Docker.  Second, the solution has a lot of overhead.  Even avoiding adding shell scripts at the end, it does a lot of rebuilding for what should be based on an image.  And on something like a regular laptop, it's going to use a lot of resources- forget running Zoom/WebEx and continue development work. 

I don't want to oversell it- WSL isn't a slam dunk replacement.  Think of it more like an incremental change.  It feels a little more efficient with resources.  It's more permanent than a container, so there's less re-building.  

It's the re-building that has me the most excited.  The problem that I've been trying to solve lately has been making my local and other environments more consistent.  That's why things like Rancher Desktop are so appealing to me.  While Docker is ephemeral and idempotent, Docker-Compose doesn't replicate Kubernetes.  Also, devcontainers doesn't help me with my goal either.  Building out all the parameters in a devcontainer.json doesn't do anything for the project- it'll never be like dev, stage, prod or whatever.  But in using WSL, I can leverage ansible, which is a solution I love and does get me closer to parity between my environments.

So the steps you'll need to get going are something like below.  If different OS, you can probably get through this okay, but this approach needs some tweaking.  I like WSL2 as a solution because it's isolated from the main OS - can recreate if something goes south.  Linux and Mac may want to stick with the devcontainer idea or something else that provides a degree of isolation from the OS - QEMU, LXC or KVM.  I've left the devcontainer logic in place but I'm not improving/maintaining it at present.

### Ansible vs Terraform

I started building out example terraform and ansible-pull projects in this repo.  I'm not sure where I'm going to go with those, but I was thinking through which tools I'd use for this solution.  At first I was thinking Terraform, and ultimately I may change my mind, but I think it's far more interesting to use Crossplane.  The downside to crossplane is that in a local situation, it requires a bit more effort to stand up an environment, so I decided Ansible was reasonable to handle that task.

NOTE: Currently there's a bug in WSL2 that affects devcontainers.  Terraform is impacted.  before running terraform commands vim into /etc/resolve.conf and set the nameserver to 1.1.1.1 or 8.8.8.8, something like that.  This is just a workaround, so I'm not going to update the files to automatically fix. --[Github issue](https://github.com/microsoft/WSL/issues/8022)

## Features

Currently the dev environment (Ubuntu) installs several things via Ansible script:

- shell, languages or cli tools (gh, ansible, k9s, Go, Rust, argocd-cli, Oh My Zsh, k3d, cmctl, minio-cli)
- Visual Studio Code extensions
- Helm charts via the local ansible script (Helm, Traefik, Cert-Manager, ArgoCD, Grafana/Prometheus, Airflow)

The specific features selected can be tweaked via `ansible/vars/localhost.yml`.  My plans are to add back some additional features that were included in the devcontainer solution (gcloud-cli, azure-cli, aws-cli, terraform). I still need to add additional configurations to Oh My Zsh.  If you have immediate need of these, some links to well done scripts can be found in the devcontainer section.  My plans are to create/recreate the same idea within ansible roles to be consistent.

- To access [traefik dashboard](http://dashboard.traefik.127.0.0.1.sslip.io)
- To access [argocd UI](http://argocd.127.0.0.1.sslip.io):
  - Username is admin
  - Password is `kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo`
- To access [airflow UI](http://adminairflow.127.0.0.1.sslip.io):
  - Username is admin
  - Password is admin
- To access [grafana UI](http://dashboard.grafana.127.0.0.1.sslip.io)
  - Username is admin
  - Password is `kubectl -n monitoring get secret grafana-admin-credentials -o jsonpath="{.data.password}" | base64 -d; echo`

## Getting Started

### Configure Rancher Desktop and WSL(including gh-cli and ansible):

1. Enable Virtualization in BIOS
2. [Install Rancher Desktop](https://docs.rancherdesktop.io/getting-started/installation) - I believe this will prompts enabling WSL in Windows, but if not...
3. [Install Window Subsystem for Linux V2](https://docs.microsoft.com/en-us/windows/wsl/install)
4. Optional: Install [Windows Terminal](https://docs.microsoft.com/en-us/windows/terminal/install).
5. Install [Visual Studio Code](https://code.visualstudio.com/docs/setup/windows) and the [Remote Development Extension Pack](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack)
6. [Deploy Linux image in WSL](https://www.microsoft.com/store/productId/9PN20MSR04DW) This is a link to the Ubuntu 22.04 image.  Feel free to sub if you so choose.  There are links out there that don't use the Microsoft store if needed.
7. In PowerShell, type `wsl --list`.  If needed, type `wsl -s Ubuntu-22.04` to update the Default distribution.
8. type `wsl` to enter the distribution. From here on out we're in bash.
9. `sudo apt-add-repository ppa:ansible/ansible`
10. `curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg`
11. `sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg`
12. `echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null`
13. `sudo apt-get update && sudo apt-get -y upgrade`
14. `sudo apt-get -y install ansible gh python3-pip`

### Clone this repo

1. `gh auth login` - follow the prompts.  This is optional, but if nothing else the gh-cli configures git for you so you don't have to worry about it.  Otherwise it can be annoying.
2. `mkdir -p ~/code && cd ~/code` - I usually create a folder to store my projects.
3. `gh repo clone wfordwfu/deployment-template && code deployment-template` - this should download the code server and open everything up in VS Code.

### To deploy locally

To deploy locally, run `ansible-playbook ansible/local.yml -K`.  The roles/applications that are installed are maintained in the ansible/vars/localhost.yml file.  I have not implemented a delete feature, so if you deploy a helm chart you don't wish to have, just delete the corresponding namespace.  This pattern mostly follows Ansible-Pull solutions I've implemented in the past.

### To reset your environment

- To reset the cluster, go into Rancher Desktop > Troubleshooting and click the Reset Kubernetes button
- To reset WSL:
  1. Go into powershell and type `wsl --unregister Ubuntu-22.04`
  2. Pick up with step 6 under Configure Rancher Desktop and WSL above

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

### [dynamic nfs provisioning](https://www.youtube.com/watch?v=DF3v2P8ENEg) - Expect to replace with Longhorn

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
- [Argo CD docs](https://argo-cd.readthedocs.io/en/stable/)
- [Argo CD Cli](https://argo-cd.readthedocs.io/en/stable/cli_installation/)
- [MinIO for Kubernetes](https://min.io/product/kubernetes)
- [Kubectl Krew plugin manager](https://krew.sigs.k8s.io/docs/user-guide/quickstart/)
- [Krew plugins list](https://krew.sigs.k8s.io/plugins/)
- [kubectl cert-manager plugin](https://github.com/cert-manager/cert-manager)
- [kubectl ctx plugin](https://github.com/ahmetb/kubectx)
- [kubectl kyverno plugin](https://github.com/kyverno/kyverno)
- [Argo Workflows?](https://argoproj.github.io/argo-workflows)
- [Loki in grafana](http://docs.grafana.org/features/datasources/loki/)
- [Ansible k8s Object](https://docs.ansible.com/ansible/latest/collections/kubernetes/core/k8s_module.html#ansible-collections-kubernetes-core-k8s-module)
- [Longhorn](https://longhorn.io/docs/latest/)

### Helm Charts

- [Argo CD](https://github.com/argoproj/argo-helm/tree/master/charts/argo-cd)
- [Airflow](https://airflow.apache.org/docs/helm-chart/stable/index.html)
- [Loki](https://grafana.com/docs/loki/latest/installation/helm/)
- [Harbor](https://goharbor.io/docs/2.4.0/install-config/harbor-ha-helm/)

### To Add

- [Kanikio](https://github.com/GoogleContainerTools/kaniko)
- [Kubevela](https://kubevela.io/)
- [Argo Rollouts](https://argoproj.github.io/argo-rollouts/)
- [vCluster](https://www.vcluster.com/docs/what-are-virtual-clusters)
- [Kubescape](https://github.com/armosec/kubescape)
- [Synk GH Actions](https://github.com/marketplace/actions/snyk)
- [How to Run minio with traefik](https://docs.min.io/docs/how-to-run-multiple-minio-servers-with-traef-k.html)