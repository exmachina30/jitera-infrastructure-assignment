terraform {
  source = "../../../modules/msk"
}

dependency "kms" {
  config_path = "../kms"
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  msk_name                        = "msk-cluster-prod"
  vpc_id                          = dependency.vpc.outputs.vpc_id  
  subnet_ids                      = ["dependency.vpc.outputs.all_subnet_ids"] 
  security_groups                 = ["dependency.vpc.outputs.msk_security_group_id"]  
  kafka_version                   = "2.8.1"
  number_of_broker_nodes          = 2
  broker_instance_type            = "kafka.t3.small"
  broker_volume_size              = 100
  client_broker                   = "SASL"
  allowed_cidr_blocks             = ["0.0.0.0/0"]  
  encryption_in_cluster           = true
  encryption_at_rest_kms_key_arn  = dependency.kms.outputs.kms_key_arn  
  secrets_manager_kms_key_arn     = dependency.kms.outputs.secrets_manager_kms_key_arn  
  client_sasl_scram_secret_association_arns = [dependency.kms.outputs.secrets_manager_kms_key_arn]
  client_sasl_iam_enabled         = true
  client_sasl_scram_enabled       = true
  client_tls_auth_enabled         = false
  jmx_exporter_enabled            = true

  msk_auto_create_topic_enabled   = true
  msk_delete_topic_enabled        = true
  msk_log_retention_ms            = 16800000  # Adjust retention time if necessary
  num_partitions                  = 3

  unique_id                       = "prod-01"
  service                         = "msk-service"
}

include {
  path = find_in_parent_folders()
}
