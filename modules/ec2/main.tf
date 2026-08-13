resource "aws_instance" "ec2" {
  ami                    = data.aws_ami.Redhat-9.image_id
  instance_type          = var.instance_type
  vpc_security_group_ids = ["sg-0b405afb2fb9773d9"]
  subnet_id              = "subnet-01defa6418fc5eed7"
  iam_instance_profile   = aws_iam_instance_profile.main.name

  dynamic "instance_market_options" {
    for_each = var.use_spot ? [1] : []
    content {
      market_type = "spot"
      spot_options {
        instance_interruption_behavior = "stop"
        spot_instance_type             = "persistent"
      }
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

resource "aws_route53_record" "record-private-ec2" {
  zone_id = "Z10004612WLGZAG3UBPGB"
  name    = "${var.tool}-int"
  type    = "A"
  ttl     = 30
  records = [aws_instance.ec2.private_ip]
}

/*resource "aws_route53_record" "record-private-ec2" {
  for_each = var.tools

  zone_id = "Z10004612WLGZAG3UBPGB"
  name    = "${each.key}-int"
  type    = "A"
  ttl     = 30

  records = [aws_instance.ec2[each.key].private_ip]
} */

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

/*resource "aws_lb_target_group_attachment" "attach" {
  for_each = var.tools

  target_group_arn = aws_lb_target_group.tg[each.key].arn
  target_id        = aws_instance.ec2[each.key].id
  port             = each.value.port
}*/

resource "aws_lb_target_group_attachment" "attach" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.ec2.id
  port             = var.port
}

resource "aws_iam_role" "main" {
  name = "${var.tool}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_instance_profile" "main" {
  name = "${var.tool}-role"
  role = aws_iam_role.main.name
}

resource "aws_iam_policy" "main" {
  count       = length(var.policy_list)
  name        = "${var.tool}-role-policy"
  path        = "/"
  description = "${var.tool}-role-policy"


  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = var.policy_list
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach" {
  count      = length(var.policy_list)
  policy_arn = aws_iam_policy.main[0].arn
  role       = aws_iam_role.main.name
}