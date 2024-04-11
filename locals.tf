locals {
  private_subnets = sort([for subnet in var.vpc_config.subnets : subnet.name if subnet.public == false])
  public_subnets  = sort([for subnet in var.vpc_config.subnets : subnet.name if subnet.public == true])
  az              = sort(slice(data.aws_availability_zones.az_available.zone_ids, 0, length(local.private_subnets)))
  subnets_pairs   = zipmap(local.private_subnets, local.public_subnets)

  az_pairs = merge(
    zipmap(local.private_subnets, local.az),
    zipmap(local.public_subnets, local.az)
  )
}