# terraform-aws-ec2-bootstrap
Generic Bootstrap Instance on AWS EC2

## Usage

```terraform
module "ecc" {
  source = "git::ssh://git@github.com/oozou/terraform-aws-ec2-instance.git?ref=<branch_or_version>"

  prefix      = "sbth"
  environment = "dev"
  name        = "eks-bootstrap"

  is_create_eip = true # Deafult is `false`

  ami                         = "ami-055d15d9cfddf7bd3" # This value is ubuntu20.04
  vpc_id                      = module.vpc.vpc_id
  subnet_id                   = element(module.vpc.public_subnet_ids, 0)
  is_batch_run                = false # Default is `false`, If machine is need to be `terminated` with instance_initiated_shutdown_behavior
  key_name                    = "big-ssh-key"
  additional_sg_attacment_ids = ["sg-000da3cbe7e0d8713"] # The sg to associate with this instance
  iam_instance_profile = null # Default is `null`
  override_profile_policy = data.json

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

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.00 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.10.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eip.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_iam_instance_profile.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.this_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_profile_policy_arns"></a> [additional\_profile\_policy\_arns](#input\_additional\_profile\_policy\_arns) | List of IAM policy arns that are attach to iam profile role | `list(string)` | `[]` | no |
| <a name="input_additional_sg_attacment_ids"></a> [additional\_sg\_attacment\_ids](#input\_additional\_sg\_attacment\_ids) | (Optional) The ID of the security group. | `list(string)` | `[]` | no |
| <a name="input_ami"></a> [ami](#input\_ami) | (Optional) AMI to use for the instance. Required unless launch\_template is specified and the Launch Template specifes an AMI. If an AMI is specified in the Launch Template, setting ami will override the AMI specified in the Launch Template | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment Variable used as a prefix | `string` | n/a | yes |
| <a name="input_iam_instance_profile"></a> [iam\_instance\_profile](#input\_iam\_instance\_profile) | (Optional) IAM Instance Profile to launch the instance with. Specified as the name of the Instance Profile. It only affects when is\_create\_default\_profile is false | `string` | `null` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | (Optional) The instance type to use for the instance. Updates to this field will trigger a stop/start of the EC2 instance. | `string` | `"t2.micro"` | no |
| <a name="input_is_batch_run"></a> [is\_batch\_run](#input\_is\_batch\_run) | wherther to create and terminate instance when script change or not | `bool` | `false` | no |
| <a name="input_is_create_default_profile"></a> [is\_create\_default\_profile](#input\_is\_create\_default\_profile) | (Optional) boolean flag for create instance profile and iam role to ec2 module | `bool` | `true` | no |
| <a name="input_is_create_eip"></a> [is\_create\_eip](#input\_is\_create\_eip) | Whether to create EIP or not | `bool` | `false` | no |
| <a name="input_is_create_security_group"></a> [is\_create\_security\_group](#input\_is\_create\_security\_group) | Determines whether to create security group for RDS cluster | `bool` | `true` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | (Optional) Key name of the Key Pair to use for the instance; which can be managed using | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | name the purpose for the ec2 instance | `string` | n/a | yes |
| <a name="input_override_profile_assume_role_policy"></a> [override\_profile\_assume\_role\_policy](#input\_override\_profile\_assume\_role\_policy) | List of IAM policy documents that are merged together into the assume role policy | `list(string)` | `[]` | no |
| <a name="input_override_profile_policy"></a> [override\_profile\_policy](#input\_override\_profile\_policy) | List of IAM policy documents that are merged together into the exported document | `list(string)` | `[]` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | The prefix name of customer to be displayed in AWS console and resource | `string` | n/a | yes |
| <a name="input_security_group_egress_rules"></a> [security\_group\_egress\_rules](#input\_security\_group\_egress\_rules) | A map of security group egress rule defintions to add to the security group created | `any` | `{}` | no |
| <a name="input_security_group_ingress_rules"></a> [security\_group\_ingress\_rules](#input\_security\_group\_ingress\_rules) | Map of ingress and any specific/overriding attributes to be created | `any` | `{}` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The ID of the subnet relate to VPC | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to add more; default tags contian {terraform=true, environment=var.environment} | `map(string)` | `{}` | no |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | The ID of the subnet relate to VPC | `string` | `null` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the instance. |
| <a name="output_capacity_reservation_specification"></a> [capacity\_reservation\_specification](#output\_capacity\_reservation\_specification) | Capacity reservation specification of the instance. |
| <a name="output_outpost_arn"></a> [outpost\_arn](#output\_outpost\_arn) | The ARN of the Outpost the instance is assigned to. |
| <a name="output_primary_network_interface_id"></a> [primary\_network\_interface\_id](#output\_primary\_network\_interface\_id) | The ID of the instance's primary network interface. |
| <a name="output_private_dns"></a> [private\_dns](#output\_private\_dns) | The private DNS name assigned to the instance. Can only be used inside the Amazon EC2, and only available if you've enabled DNS hostnames for your VPC. |
| <a name="output_private_ip"></a> [private\_ip](#output\_private\_ip) | The public IP address assigned to the instance, if applicable. NOTE: If you are using an aws\_eip with your instance, you should refer to the EIP's address directly and not use public\_ip as this field will change after the EIP is attached. |
| <a name="output_public_dns"></a> [public\_dns](#output\_public\_dns) | The public DNS name assigned to the instance. For EC2-VPC, this is only available if you've enabled DNS hostnames for your VPC. |
| <a name="output_public_ip"></a> [public\_ip](#output\_public\_ip) | The public IP address assigned to the instance, if applicable. NOTE: If you are using an aws\_eip with your instance, you should refer to the EIP's address directly and not use public\_ip as this field will change after the EIP is attached. |
| <a name="output_security_group_arn"></a> [security\_group\_arn](#output\_security\_group\_arn) | ARN of the security group associated to this ec2 |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | ID of the security group associated to this ec2 |
<!-- END_TF_DOCS -->
