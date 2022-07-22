# Outputs
output "bastion-public-ip" {
  value = aws_instance.bastion.public_ip
}

output "url" {
  value = "http://${aws_lb.alb.dns_name}/"
}

output "foo-url" {
  value = "http://${aws_lb.alb.dns_name}/foo"
}

output "bar-url" {
  value = "http://${aws_lb.alb.dns_name}/bar"
}

