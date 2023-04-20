data "aws_subnets" "selected" {
  filter {
    name = "vpc-id"
    values = [
      var.vpc_id
    ]
  }
  tags = {
    Name = var.subnet_tag
  }
}

data "aws_kms_key" "managed_key" {
  key_id = var.kms_key
}

data "aws_kms_key" "msk_managed_key" {
  key_id = "alias/aws/kafka"
}

data "aws_region" "current" {}
