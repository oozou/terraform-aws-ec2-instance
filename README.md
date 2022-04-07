# terraform-aws-ec2-bootstrap
Generic Bootstrap Instance on AWS EC2

## Usage

```terraform
module "ecc" {
  source = "git::ssh://git@github.com/oozou/terraform-aws-ec2-instance.git?ref=<branch_or_version>"

  prefix      = "sbth"
  environment = "dev"

  is_create_eip = true # Deafult is `false`

  ami                         = "ami-055d15d9cfddf7bd3" # This value is ubuntu20.04
  vpc_id                      = module.vpc.vpc_id
  subnet_id                   = element(module.vpc.public_subnet_ids, 0)
  is_batch_run                = false # Default is `false`, If machine is need to be `terminated` with instance_initiated_shutdown_behavior
  key_name                    = "big-ssh-key"
  additional_sg_attacment_ids = ["sg-000da3cbe7e0d8713"] # The sg to associate with this instance

  user_data = file("./script/install-pritunlvpn.sh")

  security_group_ingress_rules = {
    allow_to_db = {
      port        = "443"
      cidr_blocks = ["1.1.1.1/32"]
    }
    allow_to_you = {
      port        = "22"
      cidr_blocks = ["0.0.0.0/0"]
    }
    allow_with_sg = {
      source_security_group_id = "sg-000daabcd7e0d2475"
    }
  }

  tags = { "Workspace" = "O-labtop" }
}

```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name                                                                      | Version  |
|---------------------------------------------------------------------------|----------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws)                   | >= 4.00  |

## Providers

| Name                                              | Version |
|---------------------------------------------------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.8.0   |

## Modules

No modules.

## Resources

| Name                                                                                                                               | Type     |
|------------------------------------------------------------------------------------------------------------------------------------|----------|
| [aws_eip.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip)                                    | resource |
| [aws_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)                          | resource |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)              | resource |
| [aws_security_group_rule.egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule)  | resource |
| [aws_security_group_rule.ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |

## Inputs

| Name                                                                                                                         | Description                                                                                                                                                                                                                                      | Type          | Default      | Required |
|------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------|--------------|:--------:|
| <a name="input_ami"></a> [ami](#input\_ami)                                                                                  | (Optional) AMI to use for the instance. Required unless launch\_template is specified and the Launch Template specifes an AMI. If an AMI is specified in the Launch Template, setting ami will override the AMI specified in the Launch Template | `string`      | n/a          |   yes    |
| <a name="input_environment"></a> [environment](#input\_environment)                                                          | Environment Variable used as a prefix                                                                                                                                                                                                            | `string`      | n/a          |   yes    |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type)                                                  | (Optional) The instance type to use for the instance. Updates to this field will trigger a stop/start of the EC2 instance.                                                                                                                       | `string`      | `"t2.micro"` |    no    |
| <a name="input_is_batch_run"></a> [is\_batch\_run](#input\_is\_batch\_run)                                                   | wherther to create and terminate instance when script change or not                                                                                                                                                                              | `bool`        | `false`      |    no    |
| <a name="input_is_create_eip"></a> [is\_create\_eip](#input\_is\_create\_eip)                                                | Whether to create EIP or not                                                                                                                                                                                                                     | `bool`        | `false`      |    no    |
| <a name="input_is_create_security_group"></a> [is\_create\_security\_group](#input\_is\_create\_security\_group)             | Determines whether to create security group for RDS cluster                                                                                                                                                                                      | `bool`        | `true`       |    no    |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name)                                                                 | (Optional) Key name of the Key Pair to use for the instance; which can be managed using                                                                                                                                                          | `string`      | `null`       |    no    |
| <a name="input_prefix"></a> [prefix](#input\_prefix)                                                                         | The prefix name of customer to be displayed in AWS console and resource                                                                                                                                                                          | `string`      | n/a          |   yes    |
| <a name="input_security_group_egress_rules"></a> [security\_group\_egress\_rules](#input\_security\_group\_egress\_rules)    | A map of security group egress rule defintions to add to the security group created                                                                                                                                                              | `any`         | `{}`         |    no    |
| <a name="input_security_group_ingress_rules"></a> [security\_group\_ingress\_rules](#input\_security\_group\_ingress\_rules) | Map of ingress and any specific/overriding attributes to be created                                                                                                                                                                              | `any`         | `{}`         |    no    |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id)                                                              | The ID of the subnet relate to VPC                                                                                                                                                                                                               | `string`      | n/a          |   yes    |
| <a name="input_tags"></a> [tags](#input\_tags)                                                                               | Tags to add more; default tags contian {terraform=true, environment=var.environment}                                                                                                                                                             | `map(string)` | `{}`         |    no    |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data)                                                              | The ID of the subnet relate to VPC                                                                                                                                                                                                               | `string`      | `null`       |    no    |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id)                                                                       | The ID of the VPC                                                                                                                                                                                                                                | `string`      | n/a          |   yes    |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
