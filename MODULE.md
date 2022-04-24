<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.10.0 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.2.2 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.1.1 |

## Modules

No modules.

## Resources

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

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ansible_user"></a> [ansible\_user](#input\_ansible\_user) | Ansible user to use within machines | `string` | `"ubuntu"` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | Region for resources | `string` | `"AWS_REGION"` | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | Number of EC2 instances to deploy | `number` | `1` | no |
| <a name="input_instance_name_prefix"></a> [instance\_name\_prefix](#input\_instance\_name\_prefix) | Instance name prefix while creating EC2 instances | `string` | `"redisnode0"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Type of EC2 instance to use | `string` | `"AWS_INSTANCE_TYPE"` | no |
| <a name="input_key_pair_name"></a> [key\_pair\_name](#input\_key\_pair\_name) | Key pair name to create on AWS to access created EC2 instances | `string` | `"redisec2keypair"` | no |
| <a name="input_private_key"></a> [private\_key](#input\_private\_key) | Private key for ec2 instances to use | `string` | `"/home/runner/redis_ec2.pem"` | no |
| <a name="input_public_key"></a> [public\_key](#input\_public\_key) | Public key for ec2 instances to use | `string` | `"/home/runner/redis_ec2.pub"` | no |
| <a name="input_root_block_device_size"></a> [root\_block\_device\_size](#input\_root\_block\_device\_size) | Size of the root block device | `string` | `"10"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ec2_public_ips"></a> [ec2\_public\_ips](#output\_ec2\_public\_ips) | List of public IP addresses of the EC2 instances |
<!-- END_TF_DOCS -->
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->