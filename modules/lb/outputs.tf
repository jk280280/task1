output "lb_arn" {
  value = aws_elb.app.arn
}

output "lb_dns_name" {
  value = aws_elb.app.dns_name
}

