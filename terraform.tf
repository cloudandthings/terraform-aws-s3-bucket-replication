terraform {
  required_version = ">= 0.15.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.9"
      configuration_aliases = [
        aws.source, aws.destination
      ]
    }
  }
}
