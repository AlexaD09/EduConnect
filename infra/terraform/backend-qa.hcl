bucket         = "academic-linkage-terraform-state"
key            = "infra/qa/terraform.tfstate"
region         = "us-east-1"
dynamodb_table = "academic-linkage-terraform-locks"
encrypt        = true
