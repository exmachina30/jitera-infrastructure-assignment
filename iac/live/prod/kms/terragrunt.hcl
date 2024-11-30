# Terragrunt configuration for KMS module
terraform {
  source = "../../../modules/kms"  # Path to the KMS module
}

# Input variables for KMS module
inputs = {
  # KMS Key Configuration
  name        = "msk-kms-key-prod"  # Name of the KMS key
  description = "KMS key for MSK cluster encryption"
  key_usage   = "ENCRYPT_DECRYPT"   # Key usage type
  is_enabled  = true                # Whether the key is enabled
}

# Optionally include other settings such as tags, key rotation, etc.
include {
  path = find_in_parent_folders()
}
