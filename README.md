# evtr-complete

Complete example of the Ephemeral Virtual Training Range (EVTR). Can be forked and modified to suit your needs.

## Introduction

### Purpose

The purpose of this repository is to provide a complete example of the EVTR and act as a single point of entry into usage of the EVTR's Terraform modules.

### High-level design

The EVTR is an ephemeral sandbox environment that can easily be created and destroyed. The sandbox consists of a collection of DevSecOps tools that are integrated together. This sandbox environment can be used for training DevSecOps practices and provides hands-on experience with a software factory.

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

#### Overview

The complete setup in this repository happens in two stages. The first stage is the setup of infrastructure, and the second stage is configuring the sandbox.

We start by creating the [Rancher master cluster](https://github.com/saic-oss/terraform-aws-rke-rancher-master-cluster).
Then, we will create the [Rancher worker cluster](https://github.com/saic-oss/terraform-aws-rancher-k8s-cluster) that is managed by the aforementioned Rancher master cluster.
Finally, we create the [DevSecOps Sandbox](https://github.com/saic-oss/terraform-k8s-devsecops-sandbox) tools in this worker cluster. Now, our infrastructure is setup.

The sandbox tools are configured using the [Sandbox Configuration](https://github.com/saic-oss/terraform-devsecops-sandbox-config). This populates users in Gitlab, creates an example project, and sets up jobs in Jenkins for the Gitlab integration.

#### Complete Example

To create an EVTR, begin by cloning this repository.

```
git clone https://github.com/saic-oss/evtr-complete-example.git
```

Next, create an `override.tfvars` in both [1-infra](examples/complete/1-infra) and [2-sandbox_config](examples/complete/2-sandbox_config) folders.

> There are a few parameters that are specific to your AWS account and your domain name you want to use that are not included in the example `terraform.tfvars`. This is why we are using an `override.tfvars` file and adding the missing parameters to that.

Finally, we will begin standing up the EVTR.
For convenience, a Taskfile has been provided, to be used with [go-task][go-task]. Note that you will need to change your working directory to /examples/complete in order to run these tasks.

To create:

```
task applyExample
```

> This example is standing up real resources on AWS which could incur costs to you.

To destroy:

```
task destroyExample
```

Please take a look at the [1-infra](examples/complete/1-infra) and [2-sandbox_config](examples/complete/2-sandbox_config) folders for the complete example.

## Using EVTR In Class

### Instructors

The EVTR you are creating for class needs to be created well ahead of class time. It takes a non-trivial amount of time for resources to be provisioned in AWS.

You should budget at least an hour to create the EVTR and retrieve login credentials for the students.

Once setup of the EVTR is finished, you will need the Gitlab endpoint and user credentials for students to login.

You can retrieve the Gitlab endpoint with the following command in the `examples/complete/1-infra` directory:

```
terraform output gitlab_endpoint
```

You can retrieve user credentials with the following command in the `examples/complete/2-sandbox_config` directory:

```
terraform output gitlab_user_credentials
```

### Students

Students should navigate to the Gitlab endpoint provided by the instructor. This will prompt for a username and password.

After students type in their assigned username and password, they will be brought to a page showing Gitlab projects.

Now, hands-on learning can begin.

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
