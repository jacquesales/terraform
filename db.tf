resource "aws_dynamodb_table" "games" {
  name                        = "GameScores"
  billing_mode                = "PROVISIONED"
  read_capacity               = var.read_capacity
  write_capacity              = var.write_capacity
  deletion_protection_enabled = var.deletion_protection
  hash_key                    = "UserId"
  attribute {
    name = "UserId"
    type = "S"
  }
}