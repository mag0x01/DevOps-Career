data "aws_ssm_parameter" "ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

data "template_file" "user_data" {
  template = file("${path.module}/files/user_data.sh")
  vars = {
    nginx_message = var.nginx_message
    nginx_path    = var.nginx_path
  }
}

resource "aws_launch_template" "launch_template" {
  name_prefix   = var.name_prefix
  image_id      = data.aws_ssm_parameter.ami.value
  instance_type = var.instance_type

  vpc_security_group_ids = var.security_groups
  key_name               = var.ssh_key_name

  user_data = base64encode(data.template_file.user_data.rendered)
}

resource "aws_autoscaling_group" "asg" {
  vpc_zone_identifier = var.subnets
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size

  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }

  target_group_arns = var.target_groups

  tag {
    key                 = "Name"
    value               = var.name_prefix
    propagate_at_launch = true
  }
}