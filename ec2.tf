resource "aws_instance" "web_server" {
    ami = var.ec2_ami
    instance_type = var.ec2_instance_type
    vpc_security_group_ids = [aws_security_group.allow_http]
    availability_zone = "us-east-1a"

    user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y docker
    sudo firewall-cmd --permanent --add-service=http
    sudo firewall-cmd --permanent --add-service=https
    sudo firewall-cmd --reload
    sudo usermod -a -G docker ec2-user
    sudo docker pull apache:latest
    sudo docker run --name apache_web -p 80:80 -d apache
    EOF


    tags = {
        Name = "Webserver"
    }
}
