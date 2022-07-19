provider "aws" {
  region = "us-east-2"
}



module "ec2_instance" {
  source = "../.."

  prefix      = "oozou"
  environment = "dev"
  name        = "bootstrap"

  is_create_eip = true # Deafult is `false`

  ami                         = "ami-02d1e544b84bf7502"
  instance_type               = "t2.nano"
  vpc_id                      = "vpc-xxxxxxxx"
  subnet_id                   = "subnet-xxxxxxxx"
  is_batch_run                = false # Default is `false`, If machine is need to be `terminated` with instance_initiated_shutdown_behavior
  #key_name                    = "ssh-key"
  additional_sg_attacment_ids = ["sg-xxxxxxx"] # The sg to associate with this instance
  is_create_default_profile = true

  user_data = "pwd"

  security_group_ingress_rules = {
    allow_to_https = {
      port        = "443"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  tags = { "Workspace" = "O-labtop" }
}