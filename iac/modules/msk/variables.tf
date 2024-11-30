variable "msk_name" {
  description = "Name of the MSK cluster"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where MSK cluster will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs for MSK brokers"
  type        = list(string)
}

variable "security_groups" {
  description = "A list of security group IDs associated with the MSK cluster"
  type        = list(string)
}

variable "kafka_version" {
  description = "The version of Apache Kafka for the MSK cluster"
  type        = string
}

variable "number_of_broker_nodes" {
  description = "The number of broker nodes in the MSK cluster"
  type        = number
}

variable "broker_instance_type" {
  description = "The EC2 instance type used for MSK broker nodes"
  type        = string
}

variable "broker_volume_size" {
  description = "The size of the EBS volume attached to each MSK broker"
  type        = number
}

variable "allowed_cidr_blocks" {
  description = "A list of CIDR blocks allowed to access the MSK cluster"
  type        = list(string)
}

variable "encryption_in_cluster" {
  description = "Whether encryption in MSK cluster is enabled"
  type        = bool
}

variable "encryption_at_rest_kms_key_arn" {
  description = "The ARN of the KMS key used for encryption at rest"
  type        = string
}

variable "secrets_manager_kms_key_arn" {
  description = "The ARN of the KMS key used for encrypting secrets in Secrets Manager"
  type        = string
}

variable "client_sasl_scram_secret_association_arns" {
  type = list(string)
}

variable "jmx_exporter_enabled" {
  description = "Whether JMX exporter is enabled for MSK"
  type        = bool
}