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





resource "aws_iam_role" "lambda_rotation_role" {
  name = "lambda-rotation-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Effect = "Allow"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_rotation_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# (Opcjonalnie– jeśli rotujesz bazę RDS)
resource "aws_iam_role_policy_attachment" "secretsmanager_full_access" {
  role       = aws_iam_role.lambda_rotation_role.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

resource "aws_lambda_function" "rotationlambda" {
  function_name = "secrets-rotation-lambda"
  filename         = "lambda_function.zip"
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.12"
  role             = aws_iam_role.lambda_rotation_role.arn
  timeout          = 60
  memory_size      = 256
}