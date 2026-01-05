
resource "aws_s3_bucket" "tfstate" {
  count = var.env == "qa" ? 1 : 0  # Solo en QA
  bucket = "academic-linkage-tfstate-${var.env}"
  force_destroy = true
}


resource "aws_s3_bucket" "evidence" {
  bucket = "academic-linkage-evidence-${var.env}"
  force_destroy = true
}