terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


provider "aws" {
  region     = var.region
  access_key = var.bastion_access_key
  secret_key = var.bastion_secret_key
  token      = var.bastion_session_token
}
