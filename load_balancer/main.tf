
module "alb_sg" {
  source = "./modules/alb_sg"

  vpc_id = var.vpc_id

  first_port  = var.first_port
  second_port = var.second_port
  third_port  = var.third_port
  alb_sg_tag  = var.alb_sg_tag
}

module "alb" {
  source = "./modules/alb"

  alb_sg = module.alb_sg.alb_sg # alb_sg output to get sg id

  instance_id = var.instance_id
  vpc_id      = var.vpc_id
  subnet_ids  = var.subnet_ids

  template_tag           = var.template_tag
  template_instance_type = var.template_instance_type
  template_key_name      = var.template_key_name
  app_port               = var.app_port
  /*
  as_capacity            = var.as_capacity
  as_max_size            = var.as_max_size
  as_min_size            = var.as_min_size
  */
}