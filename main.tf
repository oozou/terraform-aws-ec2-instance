/* -------------------------------------------------------------------------- */
/*                                  Generics                                  */
/* -------------------------------------------------------------------------- */
locals {
  name = format("%s-%s", var.prefix, var.environment)

  instance_initiated_shutdown_behavior = var.is_bootstrap_instance ? "terminate" : "stop"

  tags = merge(
    {
      "Environment" = var.environment,
      "Terraform"   = true
    },
    var.tags
  )
}

/* -------------------------------------------------------------------------- */
/*                                    Data                                    */
/* -------------------------------------------------------------------------- */
/* ------------------------------- ubuntu ami ------------------------------- */
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

/* -------------------------------------------------------------------------- */
/*                               Security Group                               */
/* -------------------------------------------------------------------------- */
resource "aws_security_group" "this" {
  count = var.is_create_instance && var.is_create_security_group ? 1 : 0

  name        = format("%s-ec2-bootstrap-sg", local.name)
  vpc_id      = var.vpc_id
  description = "ec2 bootstrap security group for allow egress"

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(
    local.tags,
    { "Name" = format("%s-ec2-bootstrap-sg", local.name) },
  )
}

resource "aws_security_group_rule" "ingress" {
  for_each = var.is_create_instance && var.is_create_security_group ? var.security_group_ingress_rules : null

  type              = "ingress"
  from_port         = lookup(each.value, "from_port", lookup(each.value, "port", null))
  to_port           = lookup(each.value, "to_port", lookup(each.value, "port", null))
  protocol          = lookup(each.value, "protocol", "tcp")
  security_group_id = aws_security_group.this[0].id

  cidr_blocks              = lookup(each.value, "cidr_blocks", null)
  description              = lookup(each.value, "description", null)
  ipv6_cidr_blocks         = lookup(each.value, "ipv6_cidr_blocks", null)
  prefix_list_ids          = lookup(each.value, "prefix_list_ids", null)
  source_security_group_id = lookup(each.value, "source_security_group_id", null)
}

resource "aws_security_group_rule" "egress" {
  for_each = var.is_create_instance && var.is_create_security_group ? var.security_group_egress_rules : null

  type              = "egress"
  from_port         = lookup(each.value, "from_port", lookup(each.value, "port", null))
  to_port           = lookup(each.value, "to_port", lookup(each.value, "port", null))
  protocol          = lookup(each.value, "protocol", "tcp")
  security_group_id = aws_security_group.this[0].id

  cidr_blocks              = lookup(each.value, "cidr_blocks", null)
  description              = lookup(each.value, "description", null)
  ipv6_cidr_blocks         = lookup(each.value, "ipv6_cidr_blocks", null)
  prefix_list_ids          = lookup(each.value, "prefix_list_ids", null)
  source_security_group_id = lookup(each.value, "source_security_group_id", null)
}

/* -------------------------------------------------------------------------- */
/*                                     EC2                                    */
/* -------------------------------------------------------------------------- */
resource "aws_instance" "this" {
  count = var.is_create_instance ? 1 : 0

  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  user_data     = var.user_data

  vpc_security_group_ids               = [aws_security_group.this[0].id]
  instance_initiated_shutdown_behavior = local.instance_initiated_shutdown_behavior

  lifecycle {
    ignore_changes = [
      instance_state
    ]
  }

  tags = merge(
    local.tags,
    { "Name" = format("%s-ec2", local.name) },
  )
}
