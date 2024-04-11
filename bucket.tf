resource "aws_s3_bucket" "bucket_docs" {
  bucket = "o-bucket-do-terraform-estudos-devops-jac"
  tags = {
    CreatedAt = "2024-04-01"
    ManagedBy = "Terraform"
  }
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.bucket_docs.id
  versioning_configuration {
    status = "Enabled"
  }
}