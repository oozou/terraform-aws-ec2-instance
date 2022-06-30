/* -------------------------------------------------------------------------- */
/*                                  Generics                                  */
/* -------------------------------------------------------------------------- */
locals {
  name = format("%s-%s-%s", var.prefix, var.environment, var.name)

  machine_type = var.is_batch_run ? "stop" : "terminate"

  profile_policy_arns = concat(var.additional_profile_policy_arns, ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"])
  tags = merge(
    {
      "Environment" = var.environment,
      "Terraform"   = true
    },
    var.tags
  )
}
