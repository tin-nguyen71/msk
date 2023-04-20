########## Server DNS Variables ##########
variable "aws_region" {
  description = "AWS Region the instance is launched in"
  type        = string
  default     = "ap-southeast-1"
}

variable "assume_role" {
  description = "AssumeRole to manage the resources within account that owns"
  type        = string
  default     = null
  validation {
    condition     = can(regex("^arn:aws:iam::[[:digit:]]{12}:role/.+", var.assume_role))
    error_message = "Must be a valid AWS IAM role ARN."
  }
}

variable "secret_assume_role" {
  description = "AssumeRole to manage the resources within account containing secret manager."
  type        = string
  default     = null
}

########## Security Variables ##########
variable "create_security_group" {
  type        = bool
  default     = true
  description = "A boolean flag to determine whether to create Security Group."
}

variable "vpc_id" {
  type        = string
  description = "VPC ID to create the cluster in (e.g. `vpc-a22222ee`)"
}

variable "security_group_rules" {
  type = list(any)
  default = [
    {
      type        = "egress"
      from_port   = 0
      to_port     = 65535
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound traffic"
    }
  ]
  description = <<-EOT
    A list of maps of Security Group rules. 
    The values of map is fully complated with `aws_security_group_rule` resource. 
    To get more info see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule .
  EOT
}

variable "security_group_extend_rules" {
  type        = list(any)
  default     = []
  description = <<-EOT
    A list of maps of Security Group rules. 
    The values of map is fully complated with `aws_security_group_rule` resource. 
    To get more info see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule.
    {
      type              = "ingress"
      from_port         = 6379
      to_port           = 6379
      protocol          = "tcp"
      cidr_blocks       = []
      security_group_id = "sg-123456789"
    }
  EOT
}
########## Common Variables ########## 
variable "master_prefix" {
  default     = "dso"
  description = "To specify a key prefix for aws resource"
  type        = string
}

variable "hostname" {
  default     = "msk"
  type        = string
  description = "Hostname"
}

variable "instance_number_prefix" {
  default     = "%02d"
  type        = string
  description = "instance_number_prefix"
}

variable "subnet_tag" {
  type        = string
  description = "List of VPC subnet IDs"
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

########## MSK Variables ########## 
variable "enable_msk" {
  type        = bool
  default     = true
  description = "A boolean flag to determine whether to enable MSK"
}

variable "cluster_name" {
  type        = string
  description = "Name of the MSK cluster"
}

variable "kafka_version" {
  type        = string
  description = "Specify the desired Kafka software version"
}

variable "number_of_broker_nodes" {
  type        = number
  description = "The desired total number of broker nodes in the kafka cluster. It must be a multiple of the number of specified client subnets."
}

variable "enhanced_monitoring" {
  type        = string
  description = "Specify the desired enhanced MSK CloudWatch monitoring level. Valid values: `DEFAULT`, `PER_BROKER`, and `PER_TOPIC_PER_BROKER`"
}

variable "broker_instance_type" {
  type        = string
  description = "The instance type to use for the Kafka brokers"
}

variable "broker_volume_size" {
  type        = number
  description = "The size in GiB of the EBS volume for the data drive on each broker node"
}

variable "properties" {
  type        = map(string)
  description = "Contents of the server.properties file. Supported properties are documented in the [MSK Developer Guide](https://docs.aws.amazon.com/msk/latest/developerguide/msk-configuration-properties.html)"
}

variable "encryption_in_cluster" {
  type        = bool
  description = "Whether data communication among broker nodes is encrypted"
}

variable "client_broker" {
  type        = string
  description = "Encryption setting for data in transit between clients and brokers. Valid values: `TLS`, `TLS_PLAINTEXT`, and `PLAINTEXT`"
}

variable "encryption_at_rest_kms_key_arn" {
  type        = string
  description = "The ARN for the KMS encryption key. When specifying `kms_key_arn`, `storage_encrypted` needs to be set to `true`"
}

variable "certificate_authority_arns" {
  type        = list(string)
  description = "List of ACM Certificate Authority Amazon Resource Names (ARNs) to be used for TLS client authentication"
}

variable "client_sasl_scram_enabled" {
  type        = bool
  description = "Enables SCRAM client authentication via AWS Secrets Manager (cannot be set to `true` at the same time as `client_tls_auth_enabled`)."
}

variable "client_unauthenticated_enabled" {
  type        = bool
  default     = false
  description = "Enables unauthenticated access.."
}

variable "client_sasl_scram_secret_association_arns" {
  type        = list(string)
  description = "List of AWS Secrets Manager secret ARNs for scram authentication (cannot be set to `true` at the same time as `client_tls_auth_enabled`)."
}

variable "client_sasl_iam_enabled" {
  type        = bool
  description = "Enables client authentication via IAM policies (cannot be set to `true` at the same time as `client_sasl_*_enabled`)."
}

variable "client_tls_auth_enabled" {
  type        = bool
  description = "Set `true` to enable the Client TLS Authentication"
}

variable "cloudwatch_logs_enabled" {
  type        = bool
  description = "Indicates whether you want to enable or disable streaming broker logs to Cloudwatch Logs"
}

variable "firehose_logs_enabled" {
  type        = bool
  description = "Indicates whether you want to enable or disable streaming broker logs to Kinesis Data Firehose"
}

variable "firehose_delivery_stream" {
  type        = string
  description = "Name of the Kinesis Data Firehose delivery stream to deliver logs to"
}

variable "s3_logs_enabled" {
  type        = bool
  description = " Indicates whether you want to enable or disable streaming broker logs to S3"
}

variable "s3_logs_bucket" {
  type        = string
  description = "Name of the S3 bucket to deliver logs to"
}

variable "s3_logs_prefix" {
  type        = string
  description = "Prefix to append to the S3 folder name logs are delivered to"
}

variable "storage_autoscaling_enabled" {
  description = "Determines whether to create autoscaling for storage"
  type        = bool
  default     = false
}


variable "storage_autoscaling_max_capacity" {
  type        = number
  default     = 2000
  description = "Maximum size the autoscaling policy can scale storage. Defaults to `broker_volume_size`"
}

variable "storage_autoscaling_disable_scale_in" {
  type        = bool
  description = "If the value is true, scale in is disabled and the target tracking policy won't remove capacity from the scalable resource."
}

variable "storage_autoscaling_target_value" {
  type        = number
  default     = 60
  description = "Percentage of storage used to trigger autoscaled storage increase"
}

variable "jmx_exporter_enabled" {
  default     = true
  type        = bool
  description = "A boolean flag to determine whether to enable MSK jmx exporter"
}

variable "node_exporter_enabled" {
  default     = true
  type        = bool
  description = "A boolean flag to determine whether to enable MSK node exporter"
}


#KMS variables

variable "kms_key" {
  type        = string
  default     = "alias/aws/secretsmanager"
  description = "Input kms key id"
}

variable "create_custom_kms" {
  default     = false
  type        = bool
  description = "A boolean flag to determine whether to create custom kms key"
}

variable "deletion_window_in_days" {
  type        = number
  default     = 10
  description = "Duration in days after which the key is deleted after destruction of the resource"
}

variable "enable_key_rotation" {
  type        = bool
  default     = true
  description = "Specifies whether key rotation is enabled"
  validation {
    condition     = contains([true, false], var.enable_key_rotation)
    error_message = "Valid values for var: enable_key_rotation are `true`, `false`."
  }
}

variable "kms_alias" {
  type        = string
  default     = "kafka-custom"
  description = "The display name of the alias. The name must start with the word `alias` followed by a forward slash. If not specified, the alias name will be auto-generated."
  validation {
    condition     = length(var.kms_alias) > 0
    error_message = "Valid values for var: alias cannot be an empty string."
  }
}

variable "kms_policy" {
  type        = string
  default     = null
  description = "A valid KMS policy JSON document. Note that if the policy document is not specific enough (but still valid), Terraform may view the policy as constantly changing in a terraform plan. In this case, please make sure you use the verbose/specific version of the policy."
}

variable "create_service_linked" {
  type        = bool
  default     = false
  description = "Whether to create service linked"
  validation {
    condition     = contains([true, false], var.create_service_linked)
    error_message = "Valid values for var: create_service_linked are `true`, `false`."
  }
}

#Secretmanager variables 
variable "msk_username" {
  type        = string
  default     = "msk"
  description = "username for AWS secret manager plaintext"
}

variable "create_secretmanager" {
  type        = bool
  default     = false
  description = "state create secret_manager for kafka"
}
