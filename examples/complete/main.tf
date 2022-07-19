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
  vpc_id                      = "vpc-07ba2496c03937e14"
  subnet_id                   = "subnet-068288d493755aff2"
  is_batch_run                = false # Default is `false`, If machine is need to be `terminated` with instance_initiated_shutdown_behavior
  #key_name                    = "ssh-key"
  additional_sg_attacment_ids = ["sg-0f587ee2534a49013"] # The sg to associate with this instance
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