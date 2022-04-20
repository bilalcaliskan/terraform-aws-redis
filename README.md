# AWS Redis Terraform Module
[![CI](https://github.com/bilalcaliskan/terraform-aws-redis/workflows/CI/badge.svg?event=push)](https://github.com/bilalcaliskan/terraform-aws-redis/actions?query=workflow%3ACI)

Terraform module which creates a fully functional Redis cluster on AWS EC2

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
### As Github Workflow
I've created 2 different Github Workflow on that repository:
- [Apply Workflow](https://github.com/bilalcaliskan/terraform-aws-redis/actions/workflows/workflow_apply.yaml)
- [Destroy Workflow](https://github.com/bilalcaliskan/terraform-aws-redis/actions/workflows/workflow_destroy.yaml)

These workflows will prompt you for required information as input variables.

> **NOTICE**  
> To be able to use that repository over Github Workflows, you must fork repository first and trigger workflows 
> on your own repository. That's because of that only members of a repository can trigger workflows manually.

### References
- https://blog.testdouble.com/posts/2021-12-07-elevate-your-terraform-workflow-with-github-actions/
