terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      # version = ">= 3.0.0"
    }
  }

  # TODO: proper versioning
  required_version = "~> 1.1.0"
}
