resource "aws_instance" "Frontend-server" {
  ami           = "ami-0b6d9d3d33ba97d99" #ubuntu 20.04 LTS AMI ID for us-east-1
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public-subnet-frontend.id
  key_name      = aws_key_pair.three_tier_key.key_name # Replace with your key pair name
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.webserver-sg.id]
  tags = {
    Name = "Frontend-server"
  }
  
}


resource "aws_key_pair" "three_tier_key" {
  key_name   = "3tierkey"
  public_key = file("${path.module}/3tierkey.pub")

  tags = {
    Name = "3tierkey"
  }
}
