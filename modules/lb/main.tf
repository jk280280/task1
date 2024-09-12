resource "aws_elb" "app" {
  name               = "app-load-balancer"
  availability_zones = ["us-west-1a", "us-west-1b"]

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
    Name = "app-load-balancer"
  }
}

