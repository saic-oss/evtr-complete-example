# evtr-complete

Complete example of the Ephemeral Virtual Training Range (EVTR). Can be forked and modified to suit your needs.

## Introduction

### Purpose

The purpose of this repository is to provide a complete example of the EVTR and act as a single point of entry into usage of the EVTR's Terraform modules.

### High-level design

This project has been designed to do the following:

- Provide a basic ephemeral DevSecOps environment
- Allow for the creation of a number of users defined by Terraform variables
- Provision a group from which to moderate the generated users
- Allow for modular updates that will provide additional learning opportunities

The EVTR is made up of four Terraform modules:

- [terraform-aws-rke-rancher-master-cluster][terraform-aws-rke-rancher-master-cluster]: Creates a highly-available Rancher Server environment on AWS using a Kubernetes cluster provisioned using RKE
- [terraform-aws-rancher-k8s-cluster][terraform-aws-rancher-k8s-cluster]: Creates a new kubernetes cluster in Rancher and provisions it for use with a LoadBalancer and CertManger
- [terraform-k8s-devsecops-sandbox][terraform-k8s-devsecops-sandbox]: Deploys DevSecOps factory stack tooling to the kubernetes cluster and makes ingress to them available through Route53 records
- [terraform-devsecops-sandbox-config][terraform-devsecops-sandbox-config]: Configures the DevSecOps factory stack with sandbox users and other configuration to stand up a training environment

## Usage

### Prerequisites

1. Terraform v0.13+ - Uses the new way to pull down 3rd party providers.
1. \*nix operating system - Windows not supported. If you need to use this on Windows you can run it from a Docker container.
1. Since this series of modules uses `local-exec`, the following tools also need to be installed on the machine using this module:
   1. [kubectl][kubectl]
   1. [helm][helm]
   1. [helmfile][helmfile]
   1. [helm-diff plugin][helm-diff]

> Note: [ASDF][asdf] is a fantastic package manager that can install all of these tools. Please check it out and consider using it.

### Instructions

#### Complete Example

For convenience, a Taskfile has been provided, to be used with [go-task][go-task]. Note that you will need to change your working directory to /examples/complete in order to run these tasks.

```
task applyExample
task destroyExample
```

> There are a few parameters that are specific to your AWS account and your domain name you want to use that are not included in the example `terraform.tfvars`. You should create a `override.tfvars` file and add the missing parameters to that.

Please take a look at the [1-infra](examples/complete/1-infra) and [2-sandbox_config](examples/complete/2-sandbox_config) folders for the complete example.

## Contributing

Contributors to this module should make themselves familiar with this section

### Prerequisites

- [Terraform][terraform] v0.13+
- [pre-commit][pre-commit]
- Pre-commit hook dependencies

  - [nodejs][nodejs] (for the prettier hook)
  - [tflint][tflint]
  - [terraform-docs][terraform-docs]
  - [tfsec][tfsec]
  - [kubectl][kubectl]
  - [helm][helm]
  - [helmfile][helmfile]
  - [helm-diff plugin][helm-diff]

  > Note: [ASDF][asdf] is a fantastic package manager that can install all of these tools. Please check it out and consider using it.

- Run `pre-commit install` in root dir of repo (installs the pre-commit hooks so they run automatically when you try to do a git commit)
- Run `terraform init` in each directory that contains Terraform code

[terraform-aws-rke-rancher-master-cluster]: https://github.com/saic-oss/terraform-aws-rke-rancher-master-cluster
[terraform-aws-rancher-k8s-cluster]: https://github.com/saic-oss/terraform-aws-rancher-k8s-cluster
[terraform-k8s-devsecops-sandbox]: https://github.com/saic-oss/terraform-k8s-devsecops-sandbox
[terraform-devsecops-sandbox-config]: https://github.com/saic-oss/terraform-devsecops-sandbox-config
[kubectl]: https://kubernetes.io/docs/tasks/tools/install-kubectl/
[helm]: https://helm.sh/docs/intro/install/
[helmfile]: https://github.com/roboll/helmfile
[helm-diff]: https://github.com/databus23/helm-diff
[asdf]: https://github.com/asdf-vm/asdf
[go-task]: https://github.com/go-task/task
[nodejs]: https://nodejs.org/en/download/
[tflint]: https://github.com/terraform-linters/tflint
[terraform-docs]: https://github.com/terraform-docs/terraform-docs
[tfsec]: https://github.com/liamg/tfsec
[pre-commit]: https://pre-commit.com/
[terraform]: https://learn.hashicorp.com/tutorials/terraform/install-cli
