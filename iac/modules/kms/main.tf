terraform {
  backend "s3" {}
}

# Create a KMS Key
resource "aws_kms_key" "msk_encryption_key" {
  description             = "KMS Key for MSK encryption at rest"
  enable_key_rotation     = true
  policy                  = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "Allow all actions on the key"
        Effect    = "Allow"
        Action    = "kms:*"
        Resource  = "*"
        Principal = {
          AWS = "*"
        }
      },
    ]
  })
}

# Output the ARN of the KMS Key
output "kms_key_arn" {
  value = aws_kms_key.msk_encryption_key.arn
}

# Create a KMS Key for Secrets Manager
resource "aws_kms_key" "secrets_manager_key" {
  description             = "KMS Key for Secrets Manager encryption"
  enable_key_rotation     = true
  policy                  = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "Allow all actions on the key"
        Effect    = "Allow"
        Action    = "kms:*"
        Resource  = "*"
        Principal = {
          AWS = "*"
        }
      },
    ]
  })
}

# Output the ARN of the KMS Key
output "secrets_manager_kms_key_arn" {
  value = aws_kms_key.secrets_manager_key.arn
}