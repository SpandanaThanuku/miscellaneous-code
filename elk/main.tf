terraform {
  backend "s3" {
    bucket = "st23-terraform1"
    key    = "misc/elasticsearch/terraform.tfstate"
    region = "us-east-1"
  }
}

data "aws_ami" "centos8" {
  most_recent = true
  name_regex  = "Centos-8-DevOps-Practice"
  owners = ["973714476881"]
}

resource "aws_instance" "elasticsearch" {
  ami                     = data.aws_ami.centos8.image_id
  instance_type           = "m6in.large"
  vpc_security_group_ids  = ["sg-0b405afb2fb9773d9"]
  subnet_id               = "subnet-01defa6418fc5eed7"
  instance_market_options {
    spot_options {
      instance_interruption_behavior = "stop"
      spot_instance_type             = "persistent"
    }
  }

  tags = {
    Name = "elasticsearch"
  }
}

resource "aws_route53_record" "elasticsearch" {
  zone_id = "Z10004612WLGZAG3UBPGB"
  name    = "elasticsearch"
  type    = "A"
  ttl     = 30
  records = [aws_instance.elasticsearch.public_ip]
}

