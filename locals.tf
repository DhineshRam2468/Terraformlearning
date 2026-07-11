locals {
  prefix = "${var.project}-${var.environment}"

  tags = merge(var.common_tags, {
    environment = var.environment
  })

  # Subnet IDs shorthand – consumed by multiple modules
  subnet_ids = module.network.subnet_ids
}
