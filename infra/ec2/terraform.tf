terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      # version = ">= 3.0.0"
    }
  }

  backend "s3" {
    bucket  = "BUCKET_NAME"
    key     = "BUCKET_KEY_PATH"
    region  = "AWS_REGION"
    encrypt = true
  }

  # TODO: proper versioning
  required_version = "~> 1.1.0"
}

