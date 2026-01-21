terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  alias      = "frontend"
  region     = var.region
  access_key = var.frontend_access_key
  secret_key = var.frontend_secret_key
  token      = var.frontend_session_token
}

provider "aws" {
  alias      = "microservices_a"
  region     = var.region
  access_key = var.ms_a_access_key
  secret_key = var.ms_a_secret_key
  token      = var.ms_a_session_token
}

provider "aws" {
  alias      = "microservices_b"
  region     = var.region
  access_key = var.ms_b_access_key
  secret_key = var.ms_b_secret_key
  token      = var.ms_b_session_token
}

provider "aws" {
  alias      = "data"
  region     = var.region
  access_key = var.data_access_key
  secret_key = var.data_secret_key
  token      = var.data_session_token
}

provider "aws" {
  alias      = "bastion"
  region     = var.region
  access_key = var.bastion_access_key
  secret_key = var.bastion_secret_key
  token      = var.bastion_session_token
}
