resource "aws_key_pair" "my_key" {
  key_name   = "ansadmin"
  public_key = file("ansadmin.pub")
}

#Ansible Control Node

resource "aws_instance" "AWSEUANS01" {
  ami                    = "ami-0574da719dca65348"
  instance_type          = "t2.micro"
  availability_zone      = "us-east-1a"
  key_name               = "ansadmin"
  subnet_id              = aws_subnet.publicA.id
  vpc_security_group_ids = [aws_security_group.allow_SSH_Ansible_Tower.id]



  user_data = <<EOF
#!/bin/bash
sudo apt-add-repository ppa:ansible/ansible
sudo apt update -y
sudo apt install ansible -y
EOF

  tags = {
    Name        = "AWSEUANS01"
    Application = "Ansible Tower"
  }


}

#Ansible Node

resource "aws_instance" "AWSEUWEB02" {
  ami                    = "ami-002070d43b0a4f171"
  instance_type          = "t2.micro"
  availability_zone      = "us-east-1b"
  key_name               = "ansadmin"
  subnet_id              = aws_subnet.publicB.id
  vpc_security_group_ids = [aws_security_group.allow_SSH_Ansible_Node.id]


  tags = {
    Name        = "AWSEUWEB02"
    Application = "Ansible Node"
  }
}

#Ansible Node
resource "aws_instance" "AWSEUWEB03" {
  ami                    = "ami-061dbd1209944525c"
  instance_type          = "t2.micro"
  availability_zone      = "us-east-1a"
  key_name               = "ansadmin"
  subnet_id              = aws_subnet.publicA.id
  vpc_security_group_ids = [aws_security_group.allow_SSH_Ansible_Node.id]


  tags = {
    Name        = "AWSEUWEB03"
    Application = "Ansible Node"
  }
}