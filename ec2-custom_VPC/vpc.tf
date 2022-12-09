#VPC CIDR creation
resource "aws_vpc" "main" {
  cidr_block       = "172.16.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "intoinfinity-vpc"
  }
}

#Subnet creation

resource "aws_subnet" "publicA" {
  vpc_id                                      = aws_vpc.main.id
  cidr_block                                  = "172.16.1.0/24"
  availability_zone                           = "us-east-1a"
  map_public_ip_on_launch                     = "true"
  enable_resource_name_dns_a_record_on_launch = "true"

  tags = {
    Name = "intoinfinity-publicA"
  }
}

resource "aws_subnet" "publicB" {
  vpc_id                                      = aws_vpc.main.id
  cidr_block                                  = "172.16.2.0/24"
  availability_zone                           = "us-east-1b"
  map_public_ip_on_launch                     = "true"
  enable_resource_name_dns_a_record_on_launch = "true"

  tags = {
    Name = "intoinfinity-publicB"
  }
}

resource "aws_subnet" "privateA" {
  vpc_id                                      = aws_vpc.main.id
  cidr_block                                  = "172.16.5.0/24"
  availability_zone                           = "us-east-1a"
  enable_resource_name_dns_a_record_on_launch = "true"

  tags = {
    Name = "intoinfinity-privateA"
  }
}


resource "aws_subnet" "privateB" {
  vpc_id                                      = aws_vpc.main.id
  cidr_block                                  = "172.16.6.0/24"
  availability_zone                           = "us-east-1b"
  enable_resource_name_dns_a_record_on_launch = "true"

  tags = {
    Name = "intoinfinity-privateB"
  }
}

#Internet Gateway Creation

resource "aws_internet_gateway" "intoinfinity-igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "intoinfinity-igw"
  }
}

#Route table for Public subnet

resource "aws_route_table" "intoinfinity-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.intoinfinity-igw.id
  }


  tags = {
    Name = "intoinfinity-rt"
  }
}

#Route table Association to public subnet

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.publicA.id
  route_table_id = aws_route_table.intoinfinity-rt.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.publicB.id
  route_table_id = aws_route_table.intoinfinity-rt.id
}


#Create Security Group

resource "aws_security_group" "allow_SSH_Ansible_Tower" {
  name        = "allow_SSH_Ansible_Tower"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.MY_IP]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_SSH_Ansible_Tower"
  }
}


resource "aws_security_group" "allow_SSH_Ansible_Node" {
  name        = "allow_SSH_Ansible_Node"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "SSH from my IP"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.allow_SSH_Ansible_Tower.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_SSH_Ansible_Node"
  }
}