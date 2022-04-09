terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0.0"
    }
  }

  backend "s3" {
    bucket  = "BUCKET_NAME"
    key     = "states/BUCKET_KEY_PATH"
    region  = "AWS_REGION"
    encrypt = true
  }

  /*backend "s3" {
    bucket  = "skysports-my-tf-states222"
    key     = "states/redis.tf"
    region  = "us-east-2"
    encrypt = true
  }*/

  required_version = "~> 1.1.0"
}
