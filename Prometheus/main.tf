terraform {
  backend "s3" {
    bucket = "st23-terraform1"
    key    = "misc/prometheus/terraform.tfstate"
    region = "us-east-1"
  }
}

data "aws_ami" "centos8" {
  most_recent = true
  name_regex = "Centos-8-Devops-Practice"
  owners = ["973714476881"]
}

resource "aws_instance" "prometheus" {
  ami                     = data.aws_ami.centos8.image_id
  instance_type           = "t3.small"
  vpc_security_group_ids  = ["sg-0b405afb2fb9773d9"]

  tags = {
    Name = "prometheus-server"
  }
}

resource "aws_route53_record" "prometheus" {
  zone_id = "Z10004612WLGZAG3UBPGB"
  name    = "prometheus"
  type    = A
  ttl     = 30
  records = [aws_instance.prometheus.public_ip]
}