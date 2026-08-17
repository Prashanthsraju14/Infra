resource "aws_instance" "web" {
  ami=var.ami
  instance_type=var.instance_type
  key_name      = var.key_name
  subnet_id=var.subnet_id
  vpc_security_group_ids=var.security_group_ids
  root_block_device{
    volume_size=var.root_volume_size
    volume_type=var.root_volume_type

  }
   tags = {
    Name = var.ec2_name
  }
}