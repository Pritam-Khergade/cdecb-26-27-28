resource "aws_instance" "ec2" {
  # count = 4
  ami           = "ami-0b72821e2f351e396"
  instance_type = "t2.micro"
  key_name      = "DevOps_N.Virginia_Key"
  subnet_id = aws_subnet.private.id
  tags = {
    Name = "terraform "
  }
}