# MSK Cluster Terraform module

Terraform module which deploy MSK Cluster.

## Usage
```hcl
module "msk-cluster" {
aws_region            = "ap-southeast-1"  
enable_msk            = true
broker_instance_type  = "kafka.m5.xlarge"
vpc_id                = "vpc-00aadbd61d1d65a25"
subnet_tag            = "data-*"
jmx_exporter_enabled  = false
node_exporter_enabled = false
cluster_name          = "msk-test-01"
msk_configuration_name= "msk-test-configuration"  
properties            = {"auto.create.topics.enable"="false", "default.replication.factor"="3", "min.insync.replicas"="2", "num.partitions"="1", "num.replica.fetchers"="2"}
kafka_version         = "2.7.2"
client_broker         = "TLS_PLAINTEXT"  
broker_volume_size    = 1000  
number_of_broker_nodes= 3
enhanced_monitoring   = "DEFAULT"
encryption_in_cluster = true
encryption_at_rest_kms_key_arn = ""
certificate_authority_arns = []
client_sasl_scram_enabled = false
client_sasl_scram_secret_association_arns = []
client_sasl_iam_enabled = false
client_tls_auth_enabled = true
enable_jmx_exporter = true
enable_node_exporter = true
cloudwatch_logs_enabled = false
cloudwatch_logs_log_group = ""
firehose_logs_enabled = false
firehose_delivery_stream = ""
s3_logs_enabled = false
s3_logs_bucket = ""
s3_logs_prefix = ""
storage_autoscaling_max_capacity = null
storage_autoscaling_disable_scale_in = false
storage_autoscaling_target_value = 60
security_group_rules             = [
      {
        type                     = "ingress"
        from_port                = 9092
        to_port                  = 9094
        protocol                 = "tcp"
        cidr_blocks              = []
        source_security_group_id = "123"
        self                     = null
      },
      {
        type                     = "egress"
        from_port                = 0
        to_port                  = 0
        protocol                 = "-1"
        cidr_blocks              = ["0.0.0.0/0"]
        source_security_group_id = null
        self                     = null
      },
    ]
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.22 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.4.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.22 |
| <a name="provider_aws.secret"></a> [aws.secret](#provider\_aws.secret) | >= 4.22 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.4.3 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_kms"></a> [kms](#module\_kms) | git::https://github.com/tin-nguyen71/aws-kms.git | v1.1.1 |
| <a name="module_security_group"></a> [security\_group](#module\_security\_group) | git::https://github.com/tin-nguyen71/aws-security-group.git | v1.1.0 |

## Resources

| Name | Type |
|------|------|
| [aws_appautoscaling_policy.appautoscaling_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_target.appautoscaling_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target) | resource |
| [aws_cloudwatch_log_group.log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_msk_cluster.kafka_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_cluster) | resource |
| [aws_msk_configuration.config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_configuration) | resource |
| [aws_msk_scram_secret_association.msk_scram_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_scram_secret_association) | resource |
| [aws_secretsmanager_secret.kafka](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_policy.kafka](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_policy) | resource |
| [aws_secretsmanager_secret_version.kafka](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [random_password.master_password](https://registry.terraform.io/providers/hashicorp/random/3.4.3/docs/resources/password) | resource |
| [aws_kms_key.managed_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_key) | data source |
| [aws_kms_key.msk_managed_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_key) | data source |
| [aws_msk_broker_nodes.msk_broker_nodes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/msk_broker_nodes) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_subnets.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_broker_instance_type"></a> [broker\_instance\_type](#input\_broker\_instance\_type) | The instance type to use for the Kafka brokers | `string` | n/a | yes |
| <a name="input_broker_volume_size"></a> [broker\_volume\_size](#input\_broker\_volume\_size) | The size in GiB of the EBS volume for the data drive on each broker node | `number` | n/a | yes |
| <a name="input_certificate_authority_arns"></a> [certificate\_authority\_arns](#input\_certificate\_authority\_arns) | List of ACM Certificate Authority Amazon Resource Names (ARNs) to be used for TLS client authentication | `list(string)` | n/a | yes |
| <a name="input_client_broker"></a> [client\_broker](#input\_client\_broker) | Encryption setting for data in transit between clients and brokers. Valid values: `TLS`, `TLS_PLAINTEXT`, and `PLAINTEXT` | `string` | n/a | yes |
| <a name="input_client_sasl_iam_enabled"></a> [client\_sasl\_iam\_enabled](#input\_client\_sasl\_iam\_enabled) | Enables client authentication via IAM policies (cannot be set to `true` at the same time as `client_sasl_*_enabled`). | `bool` | n/a | yes |
| <a name="input_client_sasl_scram_enabled"></a> [client\_sasl\_scram\_enabled](#input\_client\_sasl\_scram\_enabled) | Enables SCRAM client authentication via AWS Secrets Manager (cannot be set to `true` at the same time as `client_tls_auth_enabled`). | `bool` | n/a | yes |
| <a name="input_client_sasl_scram_secret_association_arns"></a> [client\_sasl\_scram\_secret\_association\_arns](#input\_client\_sasl\_scram\_secret\_association\_arns) | List of AWS Secrets Manager secret ARNs for scram authentication (cannot be set to `true` at the same time as `client_tls_auth_enabled`). | `list(string)` | n/a | yes |
| <a name="input_client_tls_auth_enabled"></a> [client\_tls\_auth\_enabled](#input\_client\_tls\_auth\_enabled) | Set `true` to enable the Client TLS Authentication | `bool` | n/a | yes |
| <a name="input_cloudwatch_logs_enabled"></a> [cloudwatch\_logs\_enabled](#input\_cloudwatch\_logs\_enabled) | Indicates whether you want to enable or disable streaming broker logs to Cloudwatch Logs | `bool` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the MSK cluster | `string` | n/a | yes |
| <a name="input_encryption_at_rest_kms_key_arn"></a> [encryption\_at\_rest\_kms\_key\_arn](#input\_encryption\_at\_rest\_kms\_key\_arn) | The ARN for the KMS encryption key. When specifying `kms_key_arn`, `storage_encrypted` needs to be set to `true` | `string` | n/a | yes |
| <a name="input_encryption_in_cluster"></a> [encryption\_in\_cluster](#input\_encryption\_in\_cluster) | Whether data communication among broker nodes is encrypted | `bool` | n/a | yes |
| <a name="input_enhanced_monitoring"></a> [enhanced\_monitoring](#input\_enhanced\_monitoring) | Specify the desired enhanced MSK CloudWatch monitoring level. Valid values: `DEFAULT`, `PER_BROKER`, and `PER_TOPIC_PER_BROKER` | `string` | n/a | yes |
| <a name="input_firehose_delivery_stream"></a> [firehose\_delivery\_stream](#input\_firehose\_delivery\_stream) | Name of the Kinesis Data Firehose delivery stream to deliver logs to | `string` | n/a | yes |
| <a name="input_firehose_logs_enabled"></a> [firehose\_logs\_enabled](#input\_firehose\_logs\_enabled) | Indicates whether you want to enable or disable streaming broker logs to Kinesis Data Firehose | `bool` | n/a | yes |
| <a name="input_kafka_version"></a> [kafka\_version](#input\_kafka\_version) | Specify the desired Kafka software version | `string` | n/a | yes |
| <a name="input_number_of_broker_nodes"></a> [number\_of\_broker\_nodes](#input\_number\_of\_broker\_nodes) | The desired total number of broker nodes in the kafka cluster. It must be a multiple of the number of specified client subnets. | `number` | n/a | yes |
| <a name="input_properties"></a> [properties](#input\_properties) | Contents of the server.properties file. Supported properties are documented in the [MSK Developer Guide](https://docs.aws.amazon.com/msk/latest/developerguide/msk-configuration-properties.html) | `map(string)` | n/a | yes |
| <a name="input_s3_logs_bucket"></a> [s3\_logs\_bucket](#input\_s3\_logs\_bucket) | Name of the S3 bucket to deliver logs to | `string` | n/a | yes |
| <a name="input_s3_logs_enabled"></a> [s3\_logs\_enabled](#input\_s3\_logs\_enabled) | Indicates whether you want to enable or disable streaming broker logs to S3 | `bool` | n/a | yes |
| <a name="input_s3_logs_prefix"></a> [s3\_logs\_prefix](#input\_s3\_logs\_prefix) | Prefix to append to the S3 folder name logs are delivered to | `string` | n/a | yes |
| <a name="input_storage_autoscaling_disable_scale_in"></a> [storage\_autoscaling\_disable\_scale\_in](#input\_storage\_autoscaling\_disable\_scale\_in) | If the value is true, scale in is disabled and the target tracking policy won't remove capacity from the scalable resource. | `bool` | n/a | yes |
| <a name="input_subnet_tag"></a> [subnet\_tag](#input\_subnet\_tag) | List of VPC subnet IDs | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID to create the cluster in (e.g. `vpc-a22222ee`) | `string` | n/a | yes |
| <a name="input_assume_role"></a> [assume\_role](#input\_assume\_role) | AssumeRole to manage the resources within account that owns | `string` | `null` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS Region the instance is launched in | `string` | `"ap-southeast-1"` | no |
| <a name="input_client_unauthenticated_enabled"></a> [client\_unauthenticated\_enabled](#input\_client\_unauthenticated\_enabled) | Enables unauthenticated access.. | `bool` | `false` | no |
| <a name="input_create_custom_kms"></a> [create\_custom\_kms](#input\_create\_custom\_kms) | A boolean flag to determine whether to create custom kms key | `bool` | `false` | no |
| <a name="input_create_secretmanager"></a> [create\_secretmanager](#input\_create\_secretmanager) | state create secret\_manager for kafka | `bool` | `false` | no |
| <a name="input_create_security_group"></a> [create\_security\_group](#input\_create\_security\_group) | A boolean flag to determine whether to create Security Group. | `bool` | `true` | no |
| <a name="input_create_service_linked"></a> [create\_service\_linked](#input\_create\_service\_linked) | Whether to create service linked | `bool` | `false` | no |
| <a name="input_deletion_window_in_days"></a> [deletion\_window\_in\_days](#input\_deletion\_window\_in\_days) | Duration in days after which the key is deleted after destruction of the resource | `number` | `10` | no |
| <a name="input_enable_key_rotation"></a> [enable\_key\_rotation](#input\_enable\_key\_rotation) | Specifies whether key rotation is enabled | `bool` | `true` | no |
| <a name="input_enable_msk"></a> [enable\_msk](#input\_enable\_msk) | A boolean flag to determine whether to enable MSK | `bool` | `true` | no |
| <a name="input_hostname"></a> [hostname](#input\_hostname) | Hostname | `string` | `"msk"` | no |
| <a name="input_instance_number_prefix"></a> [instance\_number\_prefix](#input\_instance\_number\_prefix) | instance\_number\_prefix | `string` | `"%02d"` | no |
| <a name="input_jmx_exporter_enabled"></a> [jmx\_exporter\_enabled](#input\_jmx\_exporter\_enabled) | A boolean flag to determine whether to enable MSK jmx exporter | `bool` | `true` | no |
| <a name="input_kms_alias"></a> [kms\_alias](#input\_kms\_alias) | The display name of the alias. The name must start with the word `alias` followed by a forward slash. If not specified, the alias name will be auto-generated. | `string` | `"kafka-custom"` | no |
| <a name="input_kms_key"></a> [kms\_key](#input\_kms\_key) | Input kms key id | `string` | `"alias/aws/secretsmanager"` | no |
| <a name="input_kms_policy"></a> [kms\_policy](#input\_kms\_policy) | A valid KMS policy JSON document. Note that if the policy document is not specific enough (but still valid), Terraform may view the policy as constantly changing in a terraform plan. In this case, please make sure you use the verbose/specific version of the policy. | `string` | `null` | no |
| <a name="input_master_prefix"></a> [master\_prefix](#input\_master\_prefix) | To specify a key prefix for aws resource | `string` | `"dso"` | no |
| <a name="input_msk_username"></a> [msk\_username](#input\_msk\_username) | username for AWS secret manager plaintext | `string` | `"msk"` | no |
| <a name="input_node_exporter_enabled"></a> [node\_exporter\_enabled](#input\_node\_exporter\_enabled) | A boolean flag to determine whether to enable MSK node exporter | `bool` | `true` | no |
| <a name="input_secret_assume_role"></a> [secret\_assume\_role](#input\_secret\_assume\_role) | AssumeRole to manage the resources within account containing secret manager. | `string` | `null` | no |
| <a name="input_security_group_extend_rules"></a> [security\_group\_extend\_rules](#input\_security\_group\_extend\_rules) | A list of maps of Security Group rules. <br>The values of map is fully complated with `aws_security_group_rule` resource. <br>To get more info see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule.<br>{<br>  type              = "ingress"<br>  from\_port         = 6379<br>  to\_port           = 6379<br>  protocol          = "tcp"<br>  cidr\_blocks       = []<br>  security\_group\_id = "sg-123456789"<br>} | `list(any)` | `[]` | no |
| <a name="input_security_group_rules"></a> [security\_group\_rules](#input\_security\_group\_rules) | A list of maps of Security Group rules. <br>The values of map is fully complated with `aws_security_group_rule` resource. <br>To get more info see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule . | `list(any)` | <pre>[<br>  {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "description": "Allow all outbound traffic",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "to_port": 65535,<br>    "type": "egress"<br>  }<br>]</pre> | no |
| <a name="input_storage_autoscaling_enabled"></a> [storage\_autoscaling\_enabled](#input\_storage\_autoscaling\_enabled) | Determines whether to create autoscaling for storage | `bool` | `false` | no |
| <a name="input_storage_autoscaling_max_capacity"></a> [storage\_autoscaling\_max\_capacity](#input\_storage\_autoscaling\_max\_capacity) | Maximum size the autoscaling policy can scale storage. Defaults to `broker_volume_size` | `number` | `2000` | no |
| <a name="input_storage_autoscaling_target_value"></a> [storage\_autoscaling\_target\_value](#input\_storage\_autoscaling\_target\_value) | Percentage of storage used to trigger autoscaled storage increase | `number` | `60` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_arn"></a> [cluster\_arn](#output\_cluster\_arn) | Cluster arn |
| <a name="output_cluster_domain"></a> [cluster\_domain](#output\_cluster\_domain) | Cluster domain |
