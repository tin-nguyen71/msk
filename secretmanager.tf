resource "random_password" "master_password" {
  length  = 16
  special = false
}

resource "aws_secretsmanager_secret" "kafka" {
  count      = var.create_secretmanager ? 1 : 0
  name       = local.secretmanager_name
  kms_key_id = var.create_custom_kms ? module.kms.key_id : data.aws_kms_key.managed_key.id
  provider   = aws.secret
}

resource "aws_secretsmanager_secret_version" "kafka" {
  count         = var.create_secretmanager ? 1 : 0
  secret_id     = aws_secretsmanager_secret.kafka[0].id
  secret_string = jsonencode({ username = var.msk_username, password = random_password.master_password.result })
  provider      = aws.secret
}

resource "aws_secretsmanager_secret_policy" "kafka" {
  count      = var.create_secretmanager ? 1 : 0
  secret_arn = aws_secretsmanager_secret.kafka[0].arn
  policy     = <<POLICY
{
  "Version" : "2012-10-17",
  "Statement" : [ {
    "Sid": "AWSKafkaResourcePolicy",
    "Effect" : "Allow",
    "Principal" : {
      "Service" : "kafka.amazonaws.com"
    },
    "Action" : "secretsmanager:getSecretValue",
    "Resource" : "${aws_secretsmanager_secret.kafka[0].arn}"
  } ]
}
POLICY
}
