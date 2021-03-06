terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0.0"
    }
  }

  /*backend "s3" {
    bucket  = "skysports-my-tf-states222"
    key     = "states/redis.tf"
    region  = "us-east-2"
    encrypt = true
  }*/

  backend "s3" {}

  required_version = "~> 1.1.0"
}
