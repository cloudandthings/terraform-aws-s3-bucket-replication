terraform {
  required_version = ">= 0.15.5"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      # V5+ does not exist yet, may contain breaking changes.
      version = "~> 4.9"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.4"
    }
  }
}
