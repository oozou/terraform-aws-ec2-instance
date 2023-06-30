/* -------------------------------------------------------------------------- */
/*                                  Generics                                  */
/* -------------------------------------------------------------------------- */
variable "prefix" {
  description = "The prefix name of customer to be displayed in AWS console and resource"
  type        = string
}

variable "environment" {
  description = "Environment Variable used as a prefix"
  type        = string
}

variable "name" {
  description = "name the purpose for the ec2 instance"
  type        = string
}

variable "tags" {
  description = "Tags to add more; default tags contian {terraform=true, environment=var.environment}"
  type        = map(string)
  default     = {}
}

/* -------------------------------------------------------------------------- */
/*                               Security Group                               */
/* -------------------------------------------------------------------------- */
variable "is_create_security_group" {
  description = "Determines whether to create security group for RDS cluster"
  type        = bool
  default     = true
}

variable "security_group_ingress_rules" {
  description = "Map of ingress and any specific/overriding attributes to be created"
  type        = any
  default     = {}
}

variable "security_group_egress_rules" {
  description = "A map of security group egress rule defintions to add to the security group created"
  type        = any
  default     = {}
}

/* -------------------------------------------------------------------------- */
/*                                     EC2                                    */
/* -------------------------------------------------------------------------- */
variable "is_create_eip" {
  description = "Whether to create EIP or not"
  type        = bool
  default     = false
}

variable "is_batch_run" {
  description = "wherther to create and terminate instance when script change or not"
  type        = bool
  default     = false
}

variable "ami" {
  type        = string
  description = "(Optional) AMI to use for the instance. Required unless launch_template is specified and the Launch Template specifes an AMI. If an AMI is specified in the Launch Template, setting ami will override the AMI specified in the Launch Template"
}

variable "instance_type" {
  description = "(Optional) The instance type to use for the instance. Updates to this field will trigger a stop/start of the EC2 instance."
  type        = string
  default     = "t2.micro"
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet relate to VPC"
  type        = string
}

variable "user_data" {
  description = "The user data to provide when launching the instance"
  type        = string
  default     = null
}

variable "key_name" {
  description = "(Optional) Key name of the Key Pair to use for the instance; which can be managed using"
  type        = string
  default     = null
}

variable "is_create_default_profile" {
  description = "(Optional) boolean flag for create instance profile and iam role to ec2 module"
  type        = bool
  default     = true
}

variable "iam_instance_profile" {
  description = "(Optional) IAM Instance Profile to launch the instance with. Specified as the name of the Instance Profile. It only affects when is_create_default_profile is false"
  type        = string
  default     = null
}

variable "override_profile_policy" {
  description = "List of IAM policy documents that are merged together into the exported document"
  type        = list(string)
  default     = []
}

variable "override_profile_assume_role_policy" {
  description = "List of IAM policy documents that are merged together into the assume role policy"
  type        = list(string)
  default     = []
}

variable "additional_profile_policy_arns" {
  description = "List of IAM policy arns that are attach to iam profile role"
  type        = list(string)
  default     = []
}

variable "additional_sg_attacment_ids" {
  description = "(Optional) The ID of the security group."
  type        = list(string)
  default     = []
}

variable "additional_disks" {
  description = "(Optional) additional ebs disks."
  type = list(object({
    device_name           = string
    volume_size           = number
    volume_type           = string
    delete_on_termination = bool
  }))
  # default = [
  #   {
  #     device_name = "/dev/sdb"
  #     volume_size = 50
  #     volume_type = "gp3"
  #     delete_on_termination = false
  #   },
  #   {
  #     device_name = "/dev/sdc"
  #     volume_size = 100
  #     volume_type = "gp3"
  #     delete_on_termination = false
  #   }
  # ]
  default = []
}

variable "kms_key_id" {
  description = "(Optional) Amazon Resource Name (ARN) of the KMS Key to use when encrypting the volume"
  type        = string
  default     = null
}
