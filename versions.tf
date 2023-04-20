terraform {
  required_version = ">= 0.13.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.22"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }
}
