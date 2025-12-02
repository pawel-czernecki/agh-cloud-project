resource "aws_db_instance" "rds" {
  allocated_storage    = 10
  db_name              = "appdb"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username = jsondecode(aws_secretsmanager_secret_version.db.secret_string)["username"]
  password = jsondecode(aws_secretsmanager_secret_version.db.secret_string)["password"]
  skip_final_snapshot  = true
#   count                   = length(var.availability_zones)
#   availability_zone       = element(var.availability_zones, count.index)
  multi_az = true
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds.id]
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = "rds-subnet-group"
  description = "RDS subnet group"
  subnet_ids  = aws_subnet.private[*].id

  tags = {
    Name = "rds-subnet-group"
  }
}