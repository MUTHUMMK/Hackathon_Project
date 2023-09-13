
# Create AMI for launch template & auto-scaling

resource "aws_ami_from_instance" "My_ami" {
  name               = "terraform-ami"
  source_instance_id = var.instance_id
  tags               = var.template_tag
}

#create template
resource "aws_launch_template" "new-template" {
  name_prefix   = "new-template"
  image_id      = aws_ami_from_instance.My_ami.id
  instance_type = var.template_instance_type
  key_name      = var.template_key_name

 /* user_data = <<-EOF
              #!bin/bash
              sudo systemctl restart docker
              sudo docker restart $(sudo docker ps -aq) 
              EOF */
 /* user_data = <<-EOF
              #!bin/bash
              sudo apt update 
              sudo docker restart $(sudo docker ps -aq) 
              EOF */              
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.alb_sg]
  }
}

/*
# create autoscaling group
resource "aws_autoscaling_group" "autoscaling" {
  count             = length(var.public_subnet_cidrs)
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zones = data.aws_availability_zones.az.names[count.index]
  desired_capacity   = var.as_capacity
  max_size           = var.as_max_size
  min_size           = var.as_min_size

  launch_template {
    id      = aws_launch_template.new-template.id
    version = "$Latest"
  }
}
*/

# create Target group
resource "aws_lb_target_group" "target_group" {
  name     = "tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

# target group attachment

resource "aws_lb_target_group_attachment" "tg_attachment" {
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = var.instance_id
  port             = var.app_port # put the application run port number
}



# create Load balancer
resource "aws_lb" "load-balancer" {
  name               = "load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg]
  subnets            = var.subnet_ids
}

# listener rule
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.load-balancer.arn
  port              = "80" # Our loadbalancer DNS will work under HTTP
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

