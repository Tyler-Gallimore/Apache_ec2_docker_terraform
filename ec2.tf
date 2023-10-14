resource "aws_instance" "web_server" {
  ami                    = var.ec2_ami
  instance_type          = var.ec2_instance_type
  vpc_security_group_ids = [aws_security_group.allow_http.id]
  availability_zone      = "us-east-1a"

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install firewalld -y
    sudo systemctl start firewalld
    sudo systemctl enable firewalld
    sudo firewall-cmd --permanent --add-service=http
    sudo firewall-cmd --permanent --add-service=https
    sudo firewall-cmd --reload
    sudo yum install -y docker
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo usermod -a -G docker ec2-user
    sudo docker pull httpd:latest
    sudo docker run --name apache_web -p 80:80 -d httpd
    EOF


  tags = {
    Name = "Webserver"
  }
}