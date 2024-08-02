module "vpc" {
  source = "./vpc/"
  vpc_cidr          = var.vpc_cidr
  public_subnet     = var.public_subnet
  private_subnet    = var.private_subnet
  availability_zone = var.availability_zone
  name              = var.name
}

module "ec2" {
  source        = "./ec2"
  ami           = "ami-0b72821e2f351e396"
  instance_type = "t2.micro"
  keyname       = "DevOps_N.Virginia_Key"
  name          = var.name
  subnet_id     = element(module.vpc.private_subnet_id, 0)
  public_ip      = true
  security_group = module.sg.security_group_id
}

module "sg" {
  source    = "./sg"
  vpc_id    = module.vpc.vpcid
  env       = var.env
  namespace = var.namespace
  tags = {
    name    = var.name
    owner   = "devops"
    purpose = "ec2"

  }
}

module "eks" {
  source               = "./eks"
  cluster_name         = "${var.name}-cluster"
  subnet_ids           = module.vpc.private_subnet_id
  instance_type        = "t3.medium"
  desired_size         = 1
  max_size             = 5
  min_size             = 1
  node_group_subnet_id = module.vpc.private_subnet_id
}


module "s3" {
  source            = "./s3"
  bucketname        = "aws-asl-bucket-batch-cdec"
  lifecycle_status  = "Enabled"
  object_expiration = 90
  env               = var.env
  role              = "APP"
  criticality       = "SILVER"

}

module "lb" {
  source          = "./lb"
  env             = var.env
  namespace       = var.namespace
  lb_type         = var.lb_type
  security_groups = [module.sg.security_group_id]
  subnets         = module.vpc.public_subnet_id
  vpc_id          = module.vpc.vpcid
  tg              = var.tg
}
