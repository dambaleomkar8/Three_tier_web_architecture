resource "aws_db_instance" "mydb" {
  allocated_storage    = 20
  storage_type          = "gp2"
  engine                = "mysql"
  engine_version = "8.0"
  instance_class        = "db.t3.micro"
  availability_zone     = "us-east-1a"
  db_name               = "mydatabase"
  username              = "admin"
  password              = "admin1234"
  vpc_security_group_ids = [aws_security_group.database-sg.id]
  db_subnet_group_name  = aws_db_subnet_group.db_subnet_group.name
  skip_final_snapshot = true

}



resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "mydb-subnet-group1"
  subnet_ids = [aws_subnet.private-subnet-db1.id, aws_subnet.private-subnet-db2.id]

  tags = {
    Name = "My DB Subnet Group"
  }
  
}