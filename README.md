---
title: Deployment Project Template
last revised: 2022/03/13
revised by: wfordwfu
---

The goal is to create a solution where this can be accessed via [Visual Studio Code](https://code.visualstudio.com/) and the [Remote-Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension or [GitHub Codespaces](https://github.com/features/codespaces) to test locally and then provision first within Azure and ultimately in any environment.

For local development, I built this solution with [Rancher Desktop](https://rancherdesktop.io/) and Windows 10 in mind.  You may need to update the mounts section of the devcontainer.json file if you are using a different solution.  You will need to toggle your Kubernetes Settings to use the dockerd (moby) Container Runtime.  Ultimately I may update to use containerd runtime, but devcontainers don't use that currently.

Primarily, this project will leverage Terraform.  I have included several other tools within the space for fun.

## TODO

- Test .vscode/settings.json to override container defaults
- Demonstrate Ansible Pull solution as alternative to terraform (helpful in situations where you can't easily provision)
- Build out terraform scripts to provision in azure
- Add in standard tooling in k8s

## Reference

### Tooling

- [Rustup](https://rust-lang.github.io/rustup/index.html)
- [devcontainers](https://aka.ms/devcontainer.json)
- [GitHub Actions Azure Login](https://github.com/marketplace/actions/azure-login)

### Deployment Features

- [Argo CD](https://argoproj.github.io/cd)
- [Argo CD Cli](https://argo-cd.readthedocs.io/en/stable/cli_installation/)
- [Argo Workflows?](https://argoproj.github.io/argo-workflows)