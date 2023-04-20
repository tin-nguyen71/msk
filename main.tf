resource "aws_msk_configuration" "config" {
  count          = local.enable_module_msk
  kafka_versions = [var.kafka_version]
  name           = format("%s-configuration", local.cluster_name)
  description    = "Manages an Amazon Managed Streaming for Kafka configuration"

  server_properties = join("\n", [for k in keys(var.properties) : format("%s = %s", k, var.properties[k])])
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = local.log_group_name
}

resource "aws_msk_cluster" "kafka_cluster" {
  count                  = local.enable_module_msk
  cluster_name           = local.cluster_name
  kafka_version          = var.kafka_version
  number_of_broker_nodes = var.number_of_broker_nodes
  enhanced_monitoring    = var.enhanced_monitoring

  broker_node_group_info {
    instance_type   = var.broker_instance_type
    client_subnets  = tolist(data.aws_subnets.selected.ids)
    security_groups = split(",", module.security_group.security_group_id)
    storage_info {
      ebs_storage_info {
        volume_size = var.broker_volume_size
      }
    }
  }

  configuration_info {
    arn      = aws_msk_configuration.config[0].arn
    revision = aws_msk_configuration.config[0].latest_revision
  }

  encryption_info {
    encryption_in_transit {
      client_broker = var.client_broker
      in_cluster    = var.encryption_in_cluster
    }
    encryption_at_rest_kms_key_arn = var.encryption_at_rest_kms_key_arn != "" ? var.encryption_at_rest_kms_key_arn : data.aws_kms_key.msk_managed_key.arn
  }

  dynamic "client_authentication" {
    for_each = var.client_tls_auth_enabled || var.client_sasl_scram_enabled || var.client_sasl_iam_enabled ? [1] : []
    content {
      dynamic "tls" {
        for_each = var.client_tls_auth_enabled ? [1] : []
        content {
          certificate_authority_arns = var.certificate_authority_arns
        }
      }
      dynamic "sasl" {
        for_each = var.client_sasl_scram_enabled || var.client_sasl_iam_enabled ? [1] : []
        content {
          scram = var.client_sasl_scram_enabled
          iam   = var.client_sasl_iam_enabled
        }
      }
      unauthenticated = var.client_unauthenticated_enabled
    }
  }

  open_monitoring {
    prometheus {
      jmx_exporter {
        enabled_in_broker = var.jmx_exporter_enabled
      }
      node_exporter {
        enabled_in_broker = var.node_exporter_enabled
      }
    }
  }

  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = var.cloudwatch_logs_enabled
        log_group = aws_cloudwatch_log_group.log_group.name
      }
      firehose {
        enabled         = var.firehose_logs_enabled
        delivery_stream = var.firehose_delivery_stream
      }
      s3 {
        enabled = var.s3_logs_enabled
        bucket  = var.s3_logs_bucket
        prefix  = var.s3_logs_prefix
      }
    }
  }

  lifecycle {
    ignore_changes = [
      # Ignore changes to ebs_volume_size in favor of autoscaling policy
      broker_node_group_info[0].storage_info[0].ebs_storage_info[0].volume_size,
    ]
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.master_prefix}-${var.hostname}-${format(var.instance_number_prefix, count.index + 1)}"
    }
  )
}

resource "aws_msk_scram_secret_association" "msk_scram_secret" {
  count = var.enable_msk && var.client_sasl_scram_enabled ? 1 : 0

  cluster_arn     = aws_msk_cluster.kafka_cluster[0].arn
  secret_arn_list = concat(var.client_sasl_scram_secret_association_arns, [aws_secretsmanager_secret.kafka[0].arn])
}

resource "aws_appautoscaling_target" "appautoscaling_target" {
  count              = var.enable_msk && var.storage_autoscaling_enabled ? 1 : 0
  max_capacity       = local.broker_volume_size_max
  min_capacity       = 1
  resource_id        = aws_msk_cluster.kafka_cluster[0].arn
  scalable_dimension = "kafka:broker-storage:VolumeSize"
  service_namespace  = "kafka"
}

resource "aws_appautoscaling_policy" "appautoscaling_policy" {
  count              = var.enable_msk && var.storage_autoscaling_enabled ? 1 : 0
  name               = "${aws_msk_cluster.kafka_cluster[0].cluster_name}-broker-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_msk_cluster.kafka_cluster[0].arn
  scalable_dimension = join("", aws_appautoscaling_target.appautoscaling_target[*].scalable_dimension)
  service_namespace  = join("", aws_appautoscaling_target.appautoscaling_target[*].service_namespace)

  target_tracking_scaling_policy_configuration {
    disable_scale_in = var.storage_autoscaling_disable_scale_in
    predefined_metric_specification {
      predefined_metric_type = "KafkaBrokerStorageUtilization"
    }

    target_value = var.storage_autoscaling_target_value
  }
}

data "aws_msk_broker_nodes" "msk_broker_nodes" {
  count       = local.enable_module_msk
  cluster_arn = aws_msk_cluster.kafka_cluster[0].arn
}
