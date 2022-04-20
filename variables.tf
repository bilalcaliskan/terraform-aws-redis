/*variable "aws_region" {
  description = "Region for resources"
  type        = string
  default     = "us-east-2"
}*/

variable "aws_region" {
  description = "Region for resources"
  type        = string
  default     = "AWS_REGION"
}

/*variable "instance_type" {
  description = "Type of EC2 instance to use"
  type        = string
  default     = "t2.micro"
}*/

variable "instance_type" {
  description = "Type of EC2 instance to use"
  type        = string
  default     = "AWS_INSTANCE_TYPE"
}

/*variable "public_key" {
  default = "~/.ssh/redis_ec2.pub"
}

variable "private_key" {
  default = "~/.ssh/redis_ec2.pem"
}*/

variable "public_key" {
  default = "/home/runner/redis_ec2.pub"
}

variable "private_key" {
  default = "/home/runner/redis_ec2.pem"
}

/*variable "instance_count" {
  description = "Number of EC2 instances to deploy"
  type        = number
  default     = 1
}*/

variable "instance_count" {
  description = "Number of EC2 instances to deploy"
  type        = number
  default     = 1

  validation {
    condition     = var.instance_count > 0
    error_message = "The instance_count value must be bigger than 0."
  }
}

variable "root_block_device_size" {
  description = "Size of the root block device"
  type        = string
  default     = "10"

  validation {
    condition     = length(var.root_block_device_size) >= 10
    error_message = "The root_block_device_size value must be at least 10."
  }
}

variable "instance_name_prefix" {
  description = "Instance name prefix while creating EC2 instances"
  type        = string
  default     = "redisnode0"
}

variable "ansible_user" {
  default = "ubuntu"
}

variable "key_pair_name" {
  description = "Key pair name to create on AWS to access created EC2 instances"
  type        = string
  default     = "redisec2keypair"
}
