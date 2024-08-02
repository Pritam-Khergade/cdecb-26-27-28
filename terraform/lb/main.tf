resource "aws_lb" "application" {
  count                      = var.lb_type == "application" ? 1 : 0
  name                       = format("%s-%s-alb", var.env, var.namespace)
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = var.security_groups
  subnets                    = var.subnets
  enable_deletion_protection = false
  access_logs {
    bucket  = aws_s3_bucket.this.id
    prefix  = var.env
    enabled = true
  }
}

resource "aws_lb" "network" {
  count              = var.lb_type == "network" ? 1 : 0
  name               = format("%s-%s-alb", var.env, var.namespace)
  internal           = false
  load_balancer_type = "network"
  #security_groups            = ["sg-0375057f9248be92c"]
  subnets                    = var.subnets
  enable_deletion_protection = false
  # access_logs {
  #   bucket  = aws_s3_bucket.lb_logs.bucket
  #   prefix  = "test-lb"
  #   enabled = true
  # }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = var.lb_type == "application" ? aws_lb.application[0].arn : aws_lb.network[0].arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "200"
    }
  }
}



module "tg" {
  source       = "./target_group"
  for_each     = var.tg
  listener_arn = aws_lb_listener.http.arn
  name         = each.key
  port         = lookup(each.value, "port", null)
  vpc_id       = var.vpc_id
  path         = lookup(each.value, "path", null)
  priority     = lookup(each.value, "priority", null)
  hc           = lookup(each.value, "hc", null)
}
