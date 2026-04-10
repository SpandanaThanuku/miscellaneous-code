resource "aws_instance" "ec2" {
  ami                    = data.aws_ami.centos8.image_id
  instance_type          = var.instance_type
  vpc_security_group_ids  = ["sg-0b405afb2fb9773d9"]
  subnet_id               = "subnet-01defa6418fc5eed7"

  instance_market_options {
    market_type = "spot"
    spot_options {
      instance_interruption_behavior = "stop"
      spot_instance_type             = "persistent"
    }
  }

  tags = {
    Name = var.tool
  }
}

resource "aws_route53_record" "record" {
  zone_id = "Z10004612WLGZAG3UBPGB"
  name    = var.tool
  type    = "CNAME"
  ttl     = 30
  records = [var.dns_name]
}

resource "aws_lb_listener_rule" "rule" {
  listener_arn = var.listener_arn
  priority     = var.priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }

  condition {
    host_header {
      values = ["${var.tool}.tsdevops25.online"]
    }
  }
}

resource "aws_lb_target_group" "tg" {
  name     = "${var.tool}-tg"
  port     = var.port
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}
