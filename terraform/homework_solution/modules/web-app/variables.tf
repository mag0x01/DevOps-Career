variable "name_prefix" {
  type = string
  description = "Name prefix for instances in ASG"
}

variable "subnets" {
  type = list(string)
  description = "List of subnets id"
}

variable "security_groups" {
  type = list(string)
  description = "List of security groups for instances"
}

variable "target_groups" {
  type = list(string)
  description = "List of target group arn"
}

variable "ssh_key_name" {
  type = string
  description = "SSH key name"
}

variable "instance_type" {
  type = string
  description = "Instance type"
  default = "t2.micro"
}

variable "desired_capacity" {
  type = number
  description = "Desired capacity for ASG"
  default = 1
}

variable "min_size" {
  type = number
  description = "Minimum number of instances in ASG"
  default = 1
}

variable "max_size" {
  type = number
  description = "Maximum number of instances in ASG"
  default = 3
}

variable "nginx_message" {
  type = string
  description = "Web page message"
  default = "Congratulations! You did it!"
}

variable "nginx_path" {
  type = string
  description = "Nginx path"
  default = "/"
}
