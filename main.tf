module "ec2" {
  source = "./modules/ec2"
  for_each        = var.tools
  tool            = each.key
  instance_type   = each.value["instance"]
  dns_name        = module.alb.dns_name
  listener_arn    = module.alb.listener
  port            = each.value["port"]
  priority        = each.value["priority"]
  use_spot        = each.value.use_spot
  policy_list     = each.value["policy_list"]

}

module "alb" {
  source = "./modules/alb"
}

