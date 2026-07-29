resource "aws_instance" "backend-server" {
  ami           = "ami-02b64aa047cb5edf5" #ubuntu 20.04 LTS AMI ID for us-east-1
  instance_type = "t3.small"
  subnet_id     = aws_subnet.private-subnet-app.id
  key_name      = aws_key_pair.three_tier_key.key_name # Replace with your key pair name
  vpc_security_group_ids = [aws_security_group.backend-sg.id]
  iam_instance_profile = aws_iam_instance_profile.app_server_profile.name
  tags = {
    Name = "backend-server"
  }
}


resource "aws_iam_instance_profile" "app_server_profile" {
  name = "app-server-profile"
  role = aws_iam_role.app_server_role.name
}

resource "aws_iam_role" "app_server_role" {
  name = "app-server-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "rds_full_access" {
  role       = aws_iam_role.app_server_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}
