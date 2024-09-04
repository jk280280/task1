data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "this" {
  name        = "this-sg"
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
    Name = "asg-sg"
  }
}


resource "aws_launch_configuration" "this" {
  name          = "ec2-launch-configuration"
  image_id      = "ami-02c21308fed24a8ab"
  instance_type = "t3.micro"
  key_name       = "tasks"
  security_groups = [aws_security_group.this.id]
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "this" {
  launch_configuration = aws_launch_configuration.this.id
  min_size             = 2
  max_size             = 2
  vpc_zone_identifier  = var.subnet_ids
  tag {
    key                 = "Name"
    value               = "auto-scaling-instance"
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
  autoscaling_group_name = aws_autoscaling_group.this.name
}

resource "aws_autoscaling_policy" "scale_in" {
  name                   = "scale-in"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.this.name
}
