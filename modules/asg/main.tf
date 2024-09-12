data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "app" {
  name        = "app-sg"
  description = "Allow inbound SSH and other traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Replace with your IP range for better security
  }
egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Add other rules as necessary

  tags = {
    Name = "app-asg-sg"
  }
}


resource "aws_launch_configuration" "app" {
  name          = "ec2-launch-configuration"
  image_id      = "ami-0731b5a29c85c1f0c"
  instance_type = "t3.micro"
  key_name       = "tasks"
  security_groups = [aws_security_group.app.id]
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "app" {
  launch_configuration = aws_launch_configuration.app.id
  min_size             = 2
  max_size             = 2
  vpc_zone_identifier  = var.subnet_ids
  tag {
    key                 = "Name"
    value               = "app-auto-scaling-instance"
    propagate_at_launch = true
  }
  health_check_type             = "EC2"
  health_check_grace_period     = 300
  desired_capacity              = 2

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "scale_out" {
  name                   = "scale-out"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.app.name
}

resource "aws_autoscaling_policy" "scale_in" {
  name                   = "scale-in"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.app.name
}
