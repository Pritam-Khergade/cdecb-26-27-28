module "vpc" {
  source        = "./vpc/"
  vpc_cidr      = "192.168.0.0/16"
  public_subnet = ["192.168.4.0/24", "192.168.3.0/24", "192.168.6.0/24"]
  private_subnet    = ["192.168.2.0/24", "192.168.1.0/24", "192.168.7.0/24"]
  availability_zone = ["us-east-1a", "us-east-1b", "us-east-1c"]
  name              = "adidas"
}