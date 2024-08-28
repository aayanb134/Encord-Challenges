resource "aws_db_subnet_group" "main" {
  name       = "web-app-db-subnet-group"
  subnet_ids = aws_subnet.private[*].id
}

resource "aws_db_instance" "PostgreSQL" {
  identifier              = "web-app-db"
  allocated_storage       = 20
  engine                  = "postgres"
  instance_class          = "db.t2.micro"
  db_name                 = "webappdb"
  username                = "XXXXXXXX"
  password                = "XXXXXXXX"
  db_subnet_group_name    = aws_db_subnet_group.main.name
  vpc_security_group_ids  = [aws_security_group.db.id]
  skip_final_snapshot     = true
  multi_az                = true
  publicly_accessible     = false
  storage_encrypted       = true
  backup_retention_period = 7
}
