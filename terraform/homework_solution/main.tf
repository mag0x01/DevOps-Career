# VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  # always use version pining for community modules
  version = "3.12.0"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.vpc_azs
  private_subnets = var.private_subnets_cidr
  public_subnets  = var.public_subnets_cidr

  # Add only one NAT GW (no HA)
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
}

# Autoscaling Groups
resource "aws_security_group" "ec2-sg" {
  name        = "homework-ec2-sg"
  description = "Allow http inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "Allow HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb-sg.id]
  }

  ingress {
    description     = "Allow SSH from Bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "homework-ec2-sg"
  }
}

resource "aws_key_pair" "ssh-key" {
  public_key = var.public_key
  key_name   = "homework-ssh-key"
}

module "foo-asg" {
  source = "./modules/web-app"

  name_prefix     = "homework-foo"
  subnets         = [module.vpc.private_subnets[0]]
  security_groups = [aws_security_group.ec2-sg.id]
  ssh_key_name    = aws_key_pair.ssh-key.key_name
  min_size        = 1
  max_size        = 1
  nginx_message   = "foo"
  nginx_path      = "/foo"
  target_groups   = [aws_lb_target_group.foo.arn]
}

module "bar-asg" {
  source = "./modules/web-app"

  name_prefix     = "homework-bar"
  subnets         = [module.vpc.private_subnets[0]]
  security_groups = [aws_security_group.ec2-sg.id]
  ssh_key_name    = aws_key_pair.ssh-key.key_name
  min_size        = 1
  max_size        = 1
  nginx_message   = "bar"
  nginx_path      = "/bar"
  target_groups   = [aws_lb_target_group.bar.arn]
}

# Application Load Balancer
resource "aws_security_group" "alb-sg" {
  name        = "homework-alb-sg"
  description = "Allow http inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "Allow HTTP from everywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "homework-alb-sg"
  }
}

resource "aws_lb" "alb" {
  name               = "homework-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = module.vpc.public_subnets

  tags = {
    Environment = "homework"
  }
}

resource "aws_lb_target_group" "foo" {
  name     = "homework-foo"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}

resource "aws_lb_target_group" "bar" {
  name     = "homework-bar"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}

resource "aws_alb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      status_code = "HTTP_301"
      path        = "/foo"
    }
  }
}

resource "aws_lb_listener_rule" "foo" {
  listener_arn = aws_alb_listener.listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.foo.arn
  }
  condition {
    path_pattern {
      values = ["/foo*"]
    }
  }
}

resource "aws_lb_listener_rule" "bar" {
  listener_arn = aws_alb_listener.listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.bar.arn
  }
  condition {
    path_pattern {
      values = ["/bar*"]
    }
  }
}

# Bastion
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

## Take home IP address
data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

resource "aws_security_group" "bastion" {
  name        = "homework-bastion-sg"
  description = "Allow ssh inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "Allow SSH from home"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["${chomp(data.http.myip.body)}/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "homework-bastion-sg"
  }
}

resource "aws_network_interface" "bastion" {
  subnet_id   = module.vpc.public_subnets[0]
  private_ips = ["10.0.101.100"]

  security_groups = [aws_security_group.bastion.id]

  tags = {
    Name = "homework_bastion_interface"
  }
}

resource "aws_instance" "bastion" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.bastion.id
  }

  key_name = aws_key_pair.ssh-key.key_name

  tags = {
    Name = "homework-bastion"
  }
}
