# AWS Redis Terraform Module
[![CI](https://github.com/bilalcaliskan/terraform-aws-redis/workflows/CI/badge.svg?event=push)](https://github.com/bilalcaliskan/terraform-aws-redis/actions?query=workflow%3ACI)
[![GitHub tag](https://img.shields.io/github/tag/bilalcaliskan/redis-ansible-role.svg)](https://GitHub.com/bilalcaliskan/redis-ansible-role/tags/)

Terraform module which creates a fully functional Redis cluster on AWS EC2 by combining [Terraform](https://www.terraform.io/docs) 
and [bilalcaliskan.redis Ansible role](https://github.com/bilalcaliskan/redis-ansible-role). `Tag` badge above indicates the 
Ansible role version.

### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.0.0 |

### Usage
There are 2 different usage method for that repository
#### As Terraform Module
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
#### As Github Workflow
I've created 2 different Github Workflow on that repository:
- [Apply Workflow](https://github.com/bilalcaliskan/terraform-aws-redis/actions/workflows/workflow_apply.yaml)
- [Destroy Workflow](https://github.com/bilalcaliskan/terraform-aws-redis/actions/workflows/workflow_destroy.yaml)

These workflows will prompt you for required information as input variables.

> **NOTICE**  
> To be able to use that repository over Github Workflows, you must fork repository first and trigger workflows 
> on forked repository. That's because of that only members of a repository can trigger workflows manually.

### Redis Configuration
Purpose of that repository is setting up Redis instances on EC2 instances. This module uses almost fully-configurable 
[bilalcaliskan.redis](https://github.com/bilalcaliskan/redis-ansible-role) Ansible role to accomplish that. You can check 
the [configurable variables](https://github.com/bilalcaliskan/redis-ansible-role/blob/master/defaults/main.yml) of Ansible 
role and pass them over [provisioning/redis.yaml](provisioning/redis.yaml) file with your own needs.

### Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.10.0 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.2.2 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.1.1 |

### Modules

No modules.

### Resources

| Name | Type |
|------|------|
| [aws_instance.redis_server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_key_pair.redis_ec2_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_security_group.redis_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [local_file.hosts_cfg](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [null_resource.ansible](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_subnet_ids.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet_ids) | data source |
| [aws_vpc.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ansible_user"></a> [ansible\_user](#input\_ansible\_user) | n/a | `string` | `"ubuntu"` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | Region for resources | `string` | `"AWS_REGION"` | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | Number of EC2 instances to deploy | `number` | `1` | no |
| <a name="input_instance_name_prefix"></a> [instance\_name\_prefix](#input\_instance\_name\_prefix) | Instance name prefix while creating EC2 instances | `string` | `"redisnode0"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Type of EC2 instance to use | `string` | `"AWS_INSTANCE_TYPE"` | no |
| <a name="input_key_pair_name"></a> [key\_pair\_name](#input\_key\_pair\_name) | Key pair name to create on AWS to access created EC2 instances | `string` | `"redisec2keypair"` | no |
| <a name="input_private_key"></a> [private\_key](#input\_private\_key) | n/a | `string` | `"/home/runner/redis_ec2.pem"` | no |
| <a name="input_public_key"></a> [public\_key](#input\_public\_key) | n/a | `string` | `"/home/runner/redis_ec2.pub"` | no |
| <a name="input_root_block_device_size"></a> [root\_block\_device\_size](#input\_root\_block\_device\_size) | Size of the root block device | `string` | `"10"` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_ec2_public_ips"></a> [ec2\_public\_ips](#output\_ec2\_public\_ips) | List of public IP addresses of the EC2 instances |
<!-- END_TF_DOCS -->

### References
- https://blog.testdouble.com/posts/2021-12-07-elevate-your-terraform-workflow-with-github-actions/
