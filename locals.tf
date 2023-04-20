locals {
  cluster_name           = format("%s-%s", var.master_prefix, var.cluster_name)
  secretmanager_name     = format("AmazonMSK_%s-%s", var.master_prefix, var.cluster_name)
  security_group_name    = format("%s-%s-sg", var.master_prefix, var.cluster_name)
  log_group_name         = format("%s-%s-log-group", var.master_prefix, var.cluster_name)
  enable_module_msk      = var.enable_msk ? 1 : 0
  broker_volume_size_max = coalesce(var.storage_autoscaling_max_capacity, var.broker_volume_size)
  secret_assume_role     = var.secret_assume_role == null || var.secret_assume_role == "" ? var.assume_role : var.secret_assume_role
}
