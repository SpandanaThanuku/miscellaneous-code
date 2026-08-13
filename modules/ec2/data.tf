#data "aws_ami" "centos8" {
#  most_recent = true
# name_regex  = "Centos-8-DevOps-Practice"
#  owners      = ["973714476881"]
#}

data "aws_ami" "Redhat-9" {
  most_recent = true
  name_regex  = "Redhat-9-DevOps-Practice"
  owners      = ["973714476881"]
}
