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
  type    = "A"
  ttl     = 30
  records = [aws_instance.ec2.public_ip]
}


