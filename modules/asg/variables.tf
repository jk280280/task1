variable "vpc_id" {
  description = "The VPC ID where the ASG will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the ASG"
  type        = list(string)
}

variable "lb_arn" {
  description = "ARN of the load balancer to attach to the ASG"
  type        = string
}