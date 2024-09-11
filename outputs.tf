output "lb_dns_name" {
  value = module.load_balancer.lb_dns_name
}

output "asg_name" {
  value = module.asg.asg_name
}
