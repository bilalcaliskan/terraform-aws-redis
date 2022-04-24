# AWS Redis Terraform Module
[![CI](https://github.com/bilalcaliskan/terraform-aws-redis/workflows/CI/badge.svg?event=push)](https://github.com/bilalcaliskan/terraform-aws-redis/actions?query=workflow%3ACI)
[![GitHub tag](https://img.shields.io/github/tag/bilalcaliskan/redis-ansible-role.svg)](https://GitHub.com/bilalcaliskan/redis-ansible-role/tags/)

Terraform module which creates a fully functional Redis cluster on AWS EC2 by combining [Terraform](https://www.terraform.io/docs) 
and [bilalcaliskan.redis Ansible role](https://github.com/bilalcaliskan/redis-ansible-role). `Tag` badge above indicates the 
Ansible role version.

## Usage
There are 2 different usage method for that repository
### As Terraform Module
You need to add below module configuration into your terraform configuration:
```
module "redis" {
  source                    = "git::https://github.com/bilalcaliskan/terraform-aws-redis.git"
  instance_count            = 3
  instance_type             = "t2.micro"
  aws_region                = "us-east-1"
  root_block_device_size    = "10"
}
```

Please check [MODULE.md](MODULE.md) for all possible customization options.

### As Github Workflow
I've created 2 different Github Workflow on that repository:
- [Apply Workflow](https://github.com/bilalcaliskan/terraform-aws-redis/actions/workflows/workflow_apply.yaml)
- [Destroy Workflow](https://github.com/bilalcaliskan/terraform-aws-redis/actions/workflows/workflow_destroy.yaml)

These workflows will prompt you for required information as input variables.

> **NOTICE**  
> To be able to use that repository over Github Workflows, you must fork repository first and trigger workflows 
> on forked repository. That's because of that only members of a repository can trigger workflows manually.

## Redis Configuration
Purpose of that repository is setting up Redis instances on EC2 instances. This module uses almost fully-configurable 
[bilalcaliskan.redis](https://github.com/bilalcaliskan/redis-ansible-role) Ansible role to accomplish that. You can check 
the [configurable variables](https://github.com/bilalcaliskan/redis-ansible-role/blob/master/defaults/main.yml) of Ansible 
role and pass them over [provisioning/redis.yaml](provisioning/redis.yaml) file with your own needs.

## Development
This project requires below tools while developing:
- [pre-commit](https://pre-commit.com/)
- [terraform-docs](https://github.com/terraform-docs/terraform-docs) required for terraform_docs [pre-commit](https://pre-commit.com/) hook

Make sure that you've installed the pre-commit configuration:
```shell
$ pre-commit install
```

## References
- https://blog.testdouble.com/posts/2021-12-07-elevate-your-terraform-workflow-with-github-actions/
