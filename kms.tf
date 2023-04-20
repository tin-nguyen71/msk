
module "kms" {
  create_kms              = var.create_custom_kms
  source                  = "git::https://github.com/tin-nguyen71/aws-kms.git?ref=main"
  description             = "KMS key for MSK"
  deletion_window_in_days = var.deletion_window_in_days
  enable_key_rotation     = var.enable_key_rotation
  alias                   = var.kms_alias
  create_service_linked   = var.create_service_linked
  aws_service_name        = "kafka.amazonaws.com"
  policy                  = var.kms_policy
  assume_role             = var.assume_role
}
