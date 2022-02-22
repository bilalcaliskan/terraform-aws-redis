# terraform-aws-redis

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
