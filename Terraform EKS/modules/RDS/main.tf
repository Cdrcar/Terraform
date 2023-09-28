resource "aws_db_subnet_group" "mydb" {
  name        = "db_subnet_group"
  description = "My DB Subnet Group"
  subnet_ids  = var.private_subnets
}

resource "aws_db_instance" "mydb" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "postgres"
  db_name                = "mydatabase"
  engine_version         = "11.21"
  instance_class         = "db.t2.micro"
  identifier             = "mydatabase"
  username               = "groupproject"
  password               = "12345678"
  skip_final_snapshot    = true
  vpc_security_group_ids = var.vpc_security_group_id
  db_subnet_group_name   = "db_subnet_group"
}


