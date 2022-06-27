/* -------------------------------------------------------------------------- */
/*                               Security Group                               */
/* -------------------------------------------------------------------------- */
resource "aws_security_group" "this" {
  count = var.is_create_security_group ? 1 : 0

  name        = format("%s-ec2-sg", local.name)
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
    { "Name" = format("%s-ec2-sg", local.name) },
  )
}

resource "aws_security_group_rule" "ingress" {
  for_each = var.is_create_security_group ? var.security_group_ingress_rules : null

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
  for_each = var.is_create_security_group ? var.security_group_egress_rules : null

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
/* -------------------------------- Instance -------------------------------- */
resource "aws_instance" "this" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  user_data     = var.user_data
  key_name      = var.key_name

  vpc_security_group_ids               = concat([aws_security_group.this[0].id], var.additional_sg_attacment_ids)
  instance_initiated_shutdown_behavior = local.machine_type
  iam_instance_profile                 = var.is_create_default_profile ? aws_iam_instance_profile.this[0].name : var.iam_instance_profile

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

/* ----------------------------------- EIP ---------------------------------- */
resource "aws_eip" "this" {
  count = var.is_create_eip ? 1 : 0

  vpc      = true
  instance = aws_instance.this.id

  tags = local.tags
}
