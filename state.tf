terraform {
  backend "s3" {
    bucket = "st23-terraform1"
    key    = "misc-code/all/terraform.tfstate"
    region = "us-east-1"
  }
}
