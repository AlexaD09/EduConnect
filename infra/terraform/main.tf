provider "aws" {
  alias  = "frontend"
  region = var.region
}

provider "aws" {
  alias  = "ms_a"
  region = var.region
}

provider "aws" {
  alias  = "ms_b"
  region = var.region
}

provider "aws" {
  alias  = "databases"
  region = var.region
}

provider "aws" {
  alias  = "bastion"
  region = var.region
}