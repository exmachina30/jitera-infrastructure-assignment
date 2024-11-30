terraform {
  backend "s3" {}
}

# Generate random username and password
resource "random_password" "msk_username" {
  length  = 16
  special = false
  upper   = true
}

resource "random_password" "msk_password" {
  length  = 24
  special = true
  upper   = true
}

# Store username and password in AWS SSM Parameter Store
resource "aws_ssm_parameter" "msk_username" {
  name        = "/msk/username"
  description = "MSK Username for SASL/SCRAM Authentication"
  type        = "String"
  value       = random_password.msk_username.result
  overwrite   = true
}

resource "aws_ssm_parameter" "msk_password" {
  name        = "/msk/password"
  description = "MSK Password for SASL/SCRAM Authentication"
  type        = "SecureString"
  value       = random_password.msk_password.result
  overwrite   = true
}

# CloudPosse MSK Module to create MSK cluster
module "msk-apache-kafka-cluster" {
  source  = "cloudposse/msk-apache-kafka-cluster/aws"
  version = "0.7.0"

  name                            = var.msk_name
  vpc_id                          = var.vpc_id
  subnet_ids                      = var.subnet_ids
  security_groups                 = var.security_groups
  kafka_version                   = var.kafka_version
  number_of_broker_nodes          = var.number_of_broker_nodes
  broker_instance_type            = var.broker_instance_type
  broker_volume_size              = var.broker_volume_size
  client_broker                   = "TLS"
  allowed_cidr_blocks             = var.allowed_cidr_blocks
  encryption_in_cluster           = var.encryption_in_cluster
  encryption_at_rest_kms_key_arn  = var.encryption_at_rest_kms_key_arn
  client_sasl_iam_enabled         = false
  client_sasl_scram_enabled       = true
  jmx_exporter_enabled            = var.jmx_exporter_enabled

  properties = {
    "auto.create.topics.enable" = "true"
    "delete.topic.enable"       = "true"
  }

  tags = {
    Name = "msk-cluster"
  }
}

# Secrets Manager for SASL/SCRAM authentication
resource "aws_secretsmanager_secret" "default" {
  name        = "AmazonMSK_msk-kafka-credentials"
  description = "Kafka credentials for MSK SASL/SCRAM authentication"

  # Optionally, encrypt the secret with the custom KMS key
  kms_key_id  = var.secrets_manager_kms_key_arn  # Specify the KMS key for encrypting the secret

  tags = {
    "Name" = "MSK Kafka Credentials"
  }
}

resource "aws_secretsmanager_secret_version" "default" {
  secret_id     = aws_secretsmanager_secret.default.id
  secret_string = jsonencode({
    "username" = random_password.msk_username.result,
    "password" = random_password.msk_password.result
  })
}


