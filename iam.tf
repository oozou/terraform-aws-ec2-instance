data "aws_iam_policy_document" "this" {
  override_policy_documents = var.override_profile_policy
  statement {
    sid       = "IamPassRole"
    actions   = ["iam:PassRole"]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values   = ["ec2.amazonaws.com"]
    }
  }
  statement {
    sid = "ListEc2AndListInstanceProfiles"
    actions = [
      "iam:ListInstanceProfiles",
      "ec2:Describe*",
      "ec2:Search*",
      "ec2:Get*"
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values   = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "this_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  count              = var.is_create_default_profile ? 1 : 0
  name               = format("%s-role", local.name)
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.this_assume_role.json
}

resource "aws_iam_role_policy" "this" {
  count = var.is_create_default_profile ? 1 : 0
  name  = format("%s-policy", local.name)
  role  = aws_iam_role.this[0].id

  policy = data.aws_iam_policy_document.this.json
}

resource "aws_iam_role_policy_attachment" "this" {
  count      = length(var.additional_profile_policy_arns)
  role       = aws_iam_role.this[0].name
  policy_arn = var.additional_profile_policy_arns[count.index]
}

resource "aws_iam_instance_profile" "this" {
  count = var.is_create_default_profile ? 1 : 0
  name  = format("%s-profile", local.name)
  role  = aws_iam_role.this[0].name
}
