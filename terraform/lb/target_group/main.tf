resource "aws_lb_target_group" "this" {
  name        = var.name
  port        = var.port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  health_check {
    enabled             = "true"
    healthy_threshold   = "3"
    interval            = "30"
    matcher             = "200"
    path                = var.hc
    port                = var.port
    protocol            = "HTTP"
    timeout             = "2"
    unhealthy_threshold = "3"
  }
}

resource "aws_lb_listener_rule" "this" {
  listener_arn = var.listener_arn
  priority     = var.priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }

  condition {
    path_pattern {
      values = ["${var.path}"]
    }
  }
}