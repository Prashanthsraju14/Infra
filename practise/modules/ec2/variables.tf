variable "ec2_name" {
    description = "name of instance"
    type = string
    default = "dev-ec2"
}


variable "ami_name" {
    description = "ami"
    type = string
    default = "ami-1234567"
}

variable "instance_type" {
    description = "type"
    type = string
    default = "t2.micro"
  
}

variable "ssd" {
    description = "type"
    type = string
    default = "gp3"
  
}

variable "volume_size" {
    description = ""
    type = string
    default = "20"
  
}
