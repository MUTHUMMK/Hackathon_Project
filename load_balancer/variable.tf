
# this values replaced by shell script

variable "instance_id" {
  default = "instance_id"
}
variable "vpc_id" {
  default = "vpc_id"
}
variable "subnet_ids" {
 default = ["subnet_1","subnet_2"]
}

#-------------------------------------------------------
# input configuration values

variable "alb_region" {
  default = "ap-south-1"
}
variable "template_tag" {
  default = {
    Name = "alb_ami"
  }
}
variable "template_instance_type" {
  default = "t2.micro"
}
variable "template_key_name" {
  default = "linux"
}
variable "app_port" {
  default = 5000
}

/*
variable "as_capacity" {
  default = 3
}
variable "as_max_size" {
  default = 4
}
variable "as_min_size" {
  default = 2
}
*/


#---------------------------------------------------------------------
# alb_sg configuration

variable "first_port" {
  default = 22
}
variable "second_port" {
  default = 80
}
variable "third_port" {
  default = 5000
}
variable "alb_sg_tag" {
  default = {
    Name = "alb_sg"
  }
}