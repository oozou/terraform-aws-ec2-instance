/* -------------------------------------------------------------------------- */
/*                                  Generics                                  */
/* -------------------------------------------------------------------------- */
locals {
  name = format("%s-%s-%s", var.prefix, var.environment, var.name)

  machine_type = var.is_batch_run ? "stop" : "terminate"

  tags = merge(
    {
      "Environment" = var.environment,
      "Terraform"   = true
    },
    var.tags
  )
}
