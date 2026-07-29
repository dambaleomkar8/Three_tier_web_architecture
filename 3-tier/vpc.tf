#VPC for 3-tier architecture
resource "aws_vpc" "VPC-3-tier" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  
 tags = {
    Name = "VPC-3-tier"
  }
}

#Public Subnet for Web Tier
resource "aws_subnet" "public-subnet-frontend" {
  vpc_id            = aws_vpc.VPC-3-tier.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
 tags = {
    Name = "public-subnet-frontend"
  }

}  



#Internet Gateway for VPC
resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.VPC-3-tier.id
  tags = {
    Name = "internet-gateway"
  }
}

#Route Table for Public Subnet
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.VPC-3-tier.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway.id
  }
  tags = {
    Name = "public-route-table"
  }
}

#Associate Route Table with Public Subnet
resource "aws_route_table_association" "public-subnet-association" {
  subnet_id      = aws_subnet.public-subnet-frontend.id
  route_table_id = aws_route_table.public-route-table.id
}

/*********************************************************************************/

#private Subnet for App Tier
resource "aws_subnet" "private-subnet-app" {
  vpc_id            = aws_vpc.VPC-3-tier.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"
    tags = {
    Name = "private-subnet-app"
  } 
}


#NAT Gateway for Private Subnets
resource "aws_eip" "nat-eip" {
    domain = "vpc"

    tags = {
        Name = "nat-eip"
    }
}

resource "aws_nat_gateway" "nat-gateway" {
    allocation_id = aws_eip.nat-eip.id
    subnet_id      = aws_subnet.public-subnet-frontend.id
    connectivity_type = "public"
    depends_on     = [aws_internet_gateway.internet-gateway]

    tags = {
        Name = "nat-gateway"
    }
}

#Route Table for Private Subnets
resource "aws_route_table" "private-route-table" {
    vpc_id = aws_vpc.VPC-3-tier.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat-gateway.id
    }
    tags = {
        Name = "private-route-table"
    }
}


#Associate Route Table with Private Subnets
resource "aws_route_table_association" "private-subnet-app-association" {
    subnet_id      = aws_subnet.private-subnet-app.id
    route_table_id = aws_route_table.private-route-table.id
}



/*********************************************************************************/

#private Subnet for DB Tier
resource "aws_subnet" "private-subnet-db1" {
  vpc_id = aws_vpc.VPC-3-tier.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"
    tags = {
    Name = "private-subnet-db1"
  } 
}


resource "aws_subnet" "private-subnet-db2" {
  vpc_id = aws_vpc.VPC-3-tier.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "private-subnet-db2"
  } 
}

resource "aws_route_table" "db_rt" {
  vpc_id = aws_vpc.VPC-3-tier.id

  tags = {
    Name = "db-route-table"
  }
}
#Associate Route Table with Private DB Subnets
resource "aws_route_table_association" "private-subnet-db1-association" {
    subnet_id      = aws_subnet.private-subnet-db1.id
    route_table_id = aws_route_table.db_rt.id
}   

#Associate Route Table with Private DB Subnets
resource "aws_route_table_association" "private-subnet-db2-association" {
    subnet_id      = aws_subnet.private-subnet-db2.id
    route_table_id = aws_route_table.db_rt.id
}   

