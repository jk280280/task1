resource "aws_elb" "this" {
  name               = "my-load-balancer"
  availability_zones = ["us-east-1b", "us-east-1d"]

  listener {
    instance_port     = 80
    instance_protocol = "HTTP"
    lb_port           = 80
    lb_protocol          = "HTTP"
  }

  health_check {
    target              = "HTTP:80/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "my-load-balancer"
  }
}

