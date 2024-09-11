provider "aws" {
  region = var.region
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

module "load_balancer" {
  source = "./modules/lb"
}

module "asg" {
  source        = "./modules/asg"
  vpc_id        = data.aws_vpc.default.id
  subnet_ids    = data.aws_subnets.default.ids
  lb_arn         = module.load_balancer.lb_arn
}

output "lb_dns_name" {
  value = module.load_balancer.lb_dns_name
}
output "asg_name" {
  value = module.asg.asg_name
}

