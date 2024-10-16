resource "aws_instance" "web" {
  count                       = length(var.ec2_names)
  ami                         = data.aws_ami.amazon-2.id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.sg_id]
  subnet_id                   = var.subnets[count.index]
  availability_zone           = data.aws_availability_zones.available.names[count.index]
  user_data                   = <<EOF
  #!/bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
sudo echo '<center><h1>This is Idris's instance that is successfully running the Apache Webserver!</h1></center>' > /var/www/html/index.html
EOF

  tags = {
    Name = var.ec2_names[count.index]
  }
}
