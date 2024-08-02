resource "aws_instance" "ec2" {
  # count = 4
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.keyname
  subnet_id                   = var.subnet_id
  associate_public_ip_address = var.public_ip
  vpc_security_group_ids      = [var.security_group]
  tags = {
    Name = var.name
  }
}