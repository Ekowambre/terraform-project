# creating vpc
resource "aws_vpc" "Prod-rock-VPC" {
  cidr_block           = var.Prod-rock-VPC-cidr_block
  enable_dns_hostnames = true

  tags = {
    Name = "Prod-rock-VPC"
  }
}

# creating 2 public Test subnets
resource "aws_subnet" "Test-public-sub1" {
  vpc_id     = aws_vpc.Prod-rock-VPC.id
  cidr_block = var.aws_subnet-Test-public-sub1-cidr_block

  tags = {
    Name = "Test-public-sub1"
  }
}

resource "aws_subnet" "Test-public-sub2" {
  vpc_id     = aws_vpc.Prod-rock-VPC.id
  cidr_block = var.Test-public-sub2-cidr_block

  tags = {
    Name = "Test-public-sub2"
  }
}

# creating 2 private Test subnets
resource "aws_subnet" "Test-priv-sub1" {
  vpc_id     = aws_vpc.Prod-rock-VPC.id
  cidr_block = var.Test-priv-sub1-cidr_block

  tags = {
    Name = "Test-priv-sub1"
  }
}

resource "aws_subnet" "Test-priv-sub2" {
  vpc_id     = aws_vpc.Prod-rock-VPC.id
  cidr_block = var.Test-priv-sub2-cidr_block

  tags = {
    Name = "Test-priv-sub2"
  }
}

# Creating public Test route table 
resource "aws_route_table" "Test-pub-route-table" {
  vpc_id = aws_vpc.Prod-rock-VPC.id

  tags = {
    Name = "Test-pub-route-table"
  }
}

# creating private Test route table 
resource "aws_route_table" "Test-priv-route-table" {
  vpc_id = aws_vpc.Prod-rock-VPC.id

  tags = {
    Name = "Test-priv-route-table"
  }
}

# public route table associations
resource "aws_route_table_association" "public-route-table-asso1" {
  subnet_id      = aws_subnet.Test-public-sub1.id
  route_table_id = aws_route_table.Test-pub-route-table.id
}

resource "aws_route_table_association" "public-route-table-asso2" {
  subnet_id      = aws_subnet.Test-public-sub2.id
  route_table_id = aws_route_table.Test-pub-route-table.id
}

# private route table association
resource "aws_route_table_association" "private-route-table-asso1" {
  subnet_id      = aws_subnet.Test-priv-sub1.id
  route_table_id = aws_route_table.Test-priv-route-table.id
}

resource "aws_route_table_association" "private-route-table-asso2" {
  subnet_id      = aws_subnet.Test-priv-sub2.id
  route_table_id = aws_route_table.Test-priv-route-table.id
}

# Internet gateway components
resource "aws_internet_gateway" "Test-igw" {
  vpc_id = aws_vpc.Prod-rock-VPC.id

  tags = {
    Name = "Test-igw"
  }
}

# Internet gateway attachment (route)
resource "aws_route" "Test-igw-association1" {
  route_table_id         = aws_route_table.Test-pub-route-table.id
  destination_cidr_block = var.Test-igw-association-aws_route
  gateway_id             = aws_internet_gateway.Test-igw.id
}


# elastic ip address
resource "aws_eip" "Test-eip" {
  vpc = true
}

# NAT gateway components
resource "aws_nat_gateway" "Test-Nat-gateway" {
  allocation_id = aws_eip.Test-eip.id
  subnet_id     = aws_subnet.Test-public-sub1.id

  tags = {
    Name = "Test-Nat-gateway2"
  }
}

# Nat gateway attachment (route)
resource "aws_route" "Test-Nat-gateway-association" {
  route_table_id         = aws_route_table.Test-priv-route-table.id
  destination_cidr_block = var.Test-Nat-gateway-association-aws_route
  gateway_id             = aws_nat_gateway.Test-Nat-gateway.id
}

# create Security group for the ec2 instance
resource "aws_security_group" "ec2_security_group" {
    description = var.ec2_security_group-aws_security_group
  vpc_id      = "${aws_vpc.Prod-rock-VPC.id}"

  ingress {
    description = var.ingress-type1
    from_port   = 22
    to_port     = 22
    protocol    = var.protocol_type1
    cidr_blocks = var.ingress1-cidr_block
  }

  ingress {
    description = var.ingress-type2
    from_port   = 80
    to_port     = 80
    protocol    = var.protocol_type2
    cidr_blocks = var.ingress2-cidr_block
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = var.egress-cidr_block
}
}


# ec2 instance 
resource "aws_instance" "Test-server-1" {
  ami           = var.aws_instance-Test-server-1
  instance_type = var.type
  subnet_id     = aws_subnet.Test-priv-sub1.id
  vpc_security_group_ids = ["${aws_security_group.ec2_security_group.id}"]
  tenancy       = "default"

  tags = {
    Name = "Test-server-1"
  }
}


resource "aws_instance" "Test-server-2" {
  ami           = var.aws_instance-Test-server-2 # eu-west-2
  instance_type = var.type
  subnet_id     = aws_subnet.Test-public-sub2.id
  vpc_security_group_ids = ["${aws_security_group.ec2_security_group.id}"]
  tenancy       = "default"

  tags = {
    Name = "Test-server-2"
  }
}
