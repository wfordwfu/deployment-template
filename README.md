---
title: Deployment Project Template
last revised: 2022/03/27
revised by: wfordwfu
---

The goal is to create a solution where this can be accessed via [Visual Studio Code](https://code.visualstudio.com/) and the [Remote-Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension or [GitHub Codespaces](https://github.com/features/codespaces) to test locally and then provision first within Azure and ultimately in any environment.

For local development, I built this solution with [Rancher Desktop](https://rancherdesktop.io/) and Windows 10 in mind.  You may need to update the mounts section of the devcontainer.json file if you are using a different solution.  You will need to toggle your Kubernetes Settings to use the dockerd (moby) Container Runtime.  Ultimately I may update to use containerd runtime, but devcontainers don't use that currently.

I'm still in the process of thinking out my workflow.  Right now I'm thinking that maybe Ansible to build the local cluster with the idea of using Crossplane to handle the actual environment.  My thoughts now are that my target "production" environment is a k3s cluster.  That would allow for a quick spin up of a Proof of Concept and a reasonable transition to a larger environment.

I started building out example terraform and ansible-pull projects.  I'm not sure where I'm going to go with those, but I was thinking through which tools I'd use for this solution.  At first I was thinking Terraform, and ultimately I may change my mind, but I think it's far more interesting to use Crossplane.  The downside to crossplane is that in a local situation, it requires a bit more effort to stand up an environment, so I decided Ansible was reasonable to handle that task.

NOTE: Currently there's a bug in WSL2 that affects devcontainers.  Terraform is impacted.  before running terraform commands vim into /etc/resolve.conf and set the nameserver to 1.1.1.1 or 8.8.8.8, something like that.  This is just a workaround, so I'm not going to update the files to automatically fix. --[Github issue](https://github.com/microsoft/WSL/issues/8022)

## TODO

ToCome

## Notes

- Error Installing Loki, Grafana
  - W0317 00:31:52.481419   28698 warnings.go:70] policy/v1beta1 PodSecurityPolicy is deprecated in v1.21+, unavailable in v1.25+
- Error Installing Prometheus

    ```bash
    #################################################################################
    ######   WARNING: Pod Security Policy has been moved to a global property.  #####
    ######            use .Values.podSecurityPolicy.enabled with pod-based      #####
    ######            annotations                                               #####
    ######            (e.g. .Values.nodeExporter.podSecurityPolicy.annotations) #####
    #################################################################################
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
- [K9s](https://k9scli.io/)
- [Kubescape](https://github.com/armosec/kubescape)
- [Synk GH Actions](https://github.com/marketplace/actions/snyk)
