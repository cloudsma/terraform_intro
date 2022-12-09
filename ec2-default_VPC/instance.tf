resource "aws_instance" "intro" {

  ami                    = var.AMIs[var.REGION]
  instance_type          = "t2.micro"
  availability_zone      = var.ZONE
  key_name               = "EC2instance"
  vpc_security_group_ids = ["sg-0ba8f36d7af44cdcf"]

  user_data = <<EOF
  #!/bin/bash
  sudo yum install wget unzip httpd -y
  sudo systemctl start httpd
  sudo systemctl enable httpd
  wget https://www.tooplate.com/zip-templates/2117_infinite_loop.zip
  unzip -o 2117_infinite_loop.zip
  cp -r 2117_infinite_loop/* /var/www/html/
  sudo systemctl restart httpd
  EOF

  tags = {
    "Name" = "AWSEUWEB01"
  }


}
