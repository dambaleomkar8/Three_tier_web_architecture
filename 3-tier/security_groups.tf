

#security group for web server
resource "aws_security_group" "webserver-sg" {
  name        = "web-sg"
  description = "Allow HTTP and SSH traffic"
  vpc_id      = aws_vpc.VPC-3-tier.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}






#backend security group


resource "aws_security_group" "backend-sg" {
    name        = "backend-sg"
    description = "Allow traffic from frontend server"
    vpc_id      = aws_vpc.VPC-3-tier.id
    
    ingress {
        from_port   = 8000
        to_port     = 8000
        protocol    = "tcp"
        security_groups = [aws_security_group.webserver-sg.id]#reference to webserver security group
    }
    ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}



#security group for database server
resource "aws_security_group" "database-sg" {
    name        = "database-sg"
    description = "Allow traffic from backend server"
    vpc_id      = aws_vpc.VPC-3-tier.id
    
    ingress {
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        security_groups = [aws_security_group.backend-sg.id]#reference to backend security group
    }
    
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
