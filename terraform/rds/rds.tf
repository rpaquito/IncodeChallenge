resource "aws_db_instance" "mysql" {
  allocated_storage      = 10
  db_subnet_group_name   = aws_db_subnet_group.rds-default.id
  engine                 = "mysql"
  engine_version         = "8.0.20"
  instance_class         = "db.t2.micro"
  multi_az               = false #Due to Free tier
  name                   = "mysqldb"
  username               = var.db_username
  password               = var.db_password
  skip_final_snapshot    = true
  vpc_security_group_ids = [var.db_securitygroup_id]
}

resource "aws_db_subnet_group" "rds-default" {
  name       = "rds-main-db_subnet_group"
  subnet_ids = [var.db_subnet_id_a, var.db_subnet_id_b]
}