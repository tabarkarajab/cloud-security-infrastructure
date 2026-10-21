resource "aws_db_subnet_group" "db" {
  name       = "exercise3-a-db-subnets"
  subnet_ids = aws_subnet.private[*].id

  tags = {
    Name = "exercise3-a-db-subnets"
  }
}

resource "aws_security_group" "db" {
  name        = "exercise3-a-sg-db"
  description = "PostgreSQL from provider B only"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "PostgreSQL from DigitalOcean VPC via tunnel"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.do_cidr]
  }

  ingress {
    description     = "PostgreSQL from VPN server (admin and table setup)"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.vpn.id]
  }

  tags = {
    Name = "exercise3-a-sg-db"
  }
}

resource "aws_db_instance" "db" {
  identifier              = "exercise3-a-db"
  engine                  = "postgres"
  instance_class          = "db.t4g.micro"
  allocated_storage       = 20
  storage_type            = "gp3"
  storage_encrypted       = true
  db_name                 = "appdb"
  username                = "dbadmin"
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.db.name
  vpc_security_group_ids  = [aws_security_group.db.id]
  publicly_accessible     = false
  multi_az                = false
  skip_final_snapshot     = true
  backup_retention_period = 1
  deletion_protection     = false

  tags = {
    Name = "exercise3-a-db"
  }
}