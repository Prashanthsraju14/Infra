module "ec2_instance" {
  source             = "../../modules/ec2"
  ec2_name           = var.ec2_name
  ami                = var.ami
  instance_type      = var.instance_type
  key_name           = var.key_name
  root_volume_size   = var.root_volume_size
  root_volume_type   = var.root_volume_type
  subnet_id          = var.subnet_id
  security_group_ids = var.security_group_ids
}