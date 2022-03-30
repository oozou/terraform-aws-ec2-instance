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
  description = "The ID of the subnet relate to VPC"
  type        = string
  default     = null
}

variable "key_name" {
  description = "(Optional) Key name of the Key Pair to use for the instance; which can be managed using"
  type        = string
  default     = null
}
