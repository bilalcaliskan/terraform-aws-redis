variable "instance_count" {
  description = "Number of EC2 instances to deploy"
  type        = number
  default     = 1
}

variable "instance_type" {
  description = "Type of EC2 instance to use"
  type        = string
  # TODO: change with proper instance type
  default = "t2.micro"
}

variable "aws_region" {
  description = "Region for resources"
  type        = string
  default     = "us-east-1"
}

variable "root_block_device_size" {
  description = "Size of the root block device"
  type        = string
  default     = "10"
}

variable "instance_name_prefix" {
  description = "Instance name prefix while creating EC2 instances"
  type        = string
  default     = "redisnode0"
}

variable "public_key" {
  default = "/home/runner/redis_ec2.pub"
}

variable "private_key" {
  default = "/home/runner/redis_ec2.pem"
}

variable "ansible_user" {
  default = "ubuntu"
}

variable "key_pair_name" {
  description = "Key pair name to create on AWS to access created EC2 instances"
  type        = string
  default     = "redisec2keypair"
}
