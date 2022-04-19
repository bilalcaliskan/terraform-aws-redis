# AWS Redis Terraform Module
[![CI](https://github.com/bilalcaliskan/terraform-aws-redis/workflows/CI/badge.svg?event=push)](https://github.com/bilalcaliskan/terraform-aws-redis/actions?query=workflow%3ACI)

Terraform module which creates a fully functional Redis cluster on AWS EC2

### Example Usage
```
module "redis" {
  source                    = "git::https://github.com/bilalcaliskan/terraform-aws-redis.git"
  instance_count            = 3
  instance_type             = "t2.micro"
  aws_region                = "us-east-1"
  root_block_device_size    = "10"
}
```

### References
- https://blog.testdouble.com/posts/2021-12-07-elevate-your-terraform-workflow-with-github-actions/
