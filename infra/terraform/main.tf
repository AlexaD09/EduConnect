terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  alias      = "frontend"
  region     = var.region
  access_key = var.aws_accounts["frontend"].access_key
  secret_key = var.aws_accounts["frontend"].secret_key
  token      = var.aws_accounts["frontend"].session_token
}

provider "aws" {
  alias      = "ms_a"
  region     = var.region
  access_key = var.aws_accounts["ms_a"].access_key
  secret_key = var.aws_accounts["ms_a"].secret_key
  token      = var.aws_accounts["ms_a"].session_token
}

provider "aws" {
  alias      = "ms_b"
  region     = var.region
  access_key = var.aws_accounts["ms_b"].access_key
  secret_key = var.aws_accounts["ms_b"].secret_key
  token      = var.aws_accounts["ms_b"].session_token
}

provider "aws" {
  alias      = "databases"
  region     = var.region
  access_key = var.aws_accounts["databases"].access_key
  secret_key = var.aws_accounts["databases"].secret_key
  token      = var.aws_accounts["databases"].session_token
}

provider "aws" {
  alias      = "bastion"
  region     = var.region
  access_key = var.aws_accounts["bastion"].access_key
  secret_key = var.aws_accounts["bastion"].secret_key
  token      = var.aws_accounts["bastion"].session_token
}
