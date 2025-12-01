resource "random_password" "db_password" {
  length           = 20
  special          = true
}

resource "aws_secretsmanager_secret" "db" {
  name        = "rdsCreds"
  description = "Credentials for Multi-AZ RDS database"
}

resource "aws_secretsmanager_secret_version" "db" {
  secret_id = aws_secretsmanager_secret.db.id

  secret_string = jsonencode({
    username = "aghuser"
    password = random_password.db_password.result
  })
}

data "aws_secretsmanager_secret" "db" {
  name = aws_secretsmanager_secret.db.name
}

data "aws_secretsmanager_secret_version" "db" {
  secret_id = data.aws_secretsmanager_secret.db.id
}

locals {
  db_creds = jsondecode(data.aws_secretsmanager_secret_version.db.secret_string)
}

resource "aws_secretsmanager_secret_rotation" "createrotation" {
  secret_id           = aws_secretsmanager_secret.db.id
  rotation_lambda_arn = aws_lambda_function.rotationlambda.arn

  rotation_rules {
    automatically_after_days = 30
  }
}

resource "aws_lambda_permission" "allow_secrets_manager" {
  statement_id  = "AllowSecretsManagerInvoke"
  action        = "lambda:InvokeFunction"
  principal     = "secretsmanager.amazonaws.com" 
  function_name = aws_lambda_function.rotationlambda.function_name
  source_arn    = aws_secretsmanager_secret.db.arn
}

resource "aws_lambda_function" "rotationlambda" {
  function_name = "secrets-rotation-lambda"
  filename         = "lambda_function.zip"
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.12"
  role             = "arn:aws:iam::951080160519:role/LabRole"
  timeout          = 60
  memory_size      = 256
}