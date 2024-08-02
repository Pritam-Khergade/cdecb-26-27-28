vpc_cidr          = "192.168.0.0/16"
public_subnet     = ["192.168.4.0/24", "192.168.3.0/24", "192.168.6.0/24"]
private_subnet    = ["192.168.2.0/24", "192.168.1.0/24", "192.168.7.0/24"]
availability_zone = ["us-east-1a", "us-east-1b", "us-east-1c"]
name              = "adidas"

tg = {
  laptop = {
    priority = "100"
    port     = 8081
    path     = "/laptop/*"
    hc       = "/laptop/healthz"
  },
  mobile = {
    priority = "200"
    port     = 8082
    path     = "/mobile/*"
    hc       = "/mobile/healthz"
  },
  mens-cloths = {
    priority = "300"
    port     = 8083
    path     = "/mens-cloths/*"
    hc       = "/mens-cloths/healthz"
  }
}

lb_type   = "application"
env       = "dev"
namespace = "ecomv2"

tags = {
  env       = "development"
  bill_unit = "zshapr-102"
  owner     = "ecom"
  mail      = "pritam.khergade@cloudblitz.in"
  team      = "DevOps"
}