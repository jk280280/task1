output "lb_arn" {
  value = aws_elb.this.arn
}

output "lb_dns_name" {
  value = aws_elb.this.dns_name
}

