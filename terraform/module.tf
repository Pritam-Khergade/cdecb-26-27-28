module "vpc" {
  source            = "./vpc/"
  vpc_cidr          = "192.168.0.0/16"
  public_subnet     = ["192.168.4.0/24", "192.168.3.0/24", "192.168.6.0/24"]
  private_subnet    = ["192.168.2.0/24", "192.168.1.0/24", "192.168.7.0/24"]
  availability_zone = ["us-east-1a", "us-east-1b", "us-east-1c"]
  name              = "adidas"
}

module "ec2" {
  source         = "./ec2"
  ami            = "ami-0b72821e2f351e396"
  instance_type  = "t2.micro"
  keyname        = "DevOps_N.Virginia_Key"
  name           = "adidas"
  subnet_id      = module.vpc.public_subnet_id
  public_ip      = true
  security_group = module.sg.security_group_id
}

module "sg" {
  source    = "./sg"
  vpc_id    = module.vpc.vpcid
  env       = "dev"
  namespace = "vivek"
  tags = {
    name    = "adidas"
    owner   = "devops"
    purpose = "ec2"

  }
}