######################################
# Public Elastic Load Balancer
######################################
resource "aws_lb" "public_elb" {
  name               = "${var.deploy_name}-public-elb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.public_sg.id]
  subnets            = [aws_subnet.public_subnet_a.id,aws_subnet.public_subnet_b.id]
}

# Public Elastic Load Balancer Listner
resource "aws_lb_listener" "public_elb_listner" {
  load_balancer_arn = aws_lb.public_elb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.public_elb_tg.arn
  }
}

# Public Elastic Load Balancer Target Group
resource "aws_lb_target_group" "public_elb_tg" {
  name     = "${var.deploy_name}-public-elb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
  target_type = "ip"
#  health_check {
#    healthy_threshold   = "3"
#    interval            = "30"
#    protocol            = "HTTP"
#    matcher             = "200"
#    timeout             = "3"
#    path                = "/hello"
#    unhealthy_threshold = "2"
#  }
}

######################################
# Private Elastic Load Balancer
######################################
resource "aws_lb" "private_elb" {
  name               = "${var.deploy_name}-private-elb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.private_sg.id]
  subnets            = [aws_subnet.private_subnet_a.id,aws_subnet.private_subnet_b.id]
}

# Private Elastic Load Balancer Listner
resource "aws_lb_listener" "private_elb_listner" {
  load_balancer_arn = aws_lb.private_elb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.private_elb_tg.arn
  }
}

# Private Elastic Load Balancer Target Group
resource "aws_lb_target_group" "private_elb_tg" {
  name     = "${var.deploy_name}-private-elb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
  target_type = "ip"
#  health_check {
#    healthy_threshold   = "3"
#    interval            = "30"
#    protocol            = "HTTP"
#    matcher             = "200"
#    timeout             = "3"
#    path                = var.health_check_path
#    unhealthy_threshold = "2"
#  }  
}
