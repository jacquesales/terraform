resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_config.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "main_vpc"
  }
}

resource "aws_subnet" "subnet" {
  for_each                = { for subnet in var.vpc_config.subnets : subnet.name => subnet }
  availability_zone_id    = local.az_pairs[each.key]
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = each.value.cidr_block
  map_public_ip_on_launch = each.value.public
  tags = {
    Name = each.key
  }
}

resource "aws_nat_gateway" "main_natgw" {
  for_each      = toset(local.private_subnets)
  allocation_id = aws_eip.eip_natgw[each.value].id
  subnet_id     = aws_subnet.subnet[local.subnets_pairs[each.value]].id
}

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "main_igw"
  }
}

resource "aws_eip" "eip_natgw" {
  for_each   = toset(local.private_subnets)
  depends_on = [aws_internet_gateway.main_igw]
}

resource "aws_route_table" "rtb_public" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "rtb_public"
  }
}

resource "aws_route" "main_route_internet_gateway" {
  destination_cidr_block  = "0.0.0.0/0"
  route_table_id          = aws_route_table.rtb_public.id
  gateway_id              = aws_internet_gateway.main_igw.id
}

resource "aws_route_table_association" "association_public" {
  for_each        = toset(local.public_subnets)
  subnet_id       = aws_subnet.subnet[each.value].id
  route_table_id  = aws_route_table.rtb_public.id
}

resource "aws_route_table" "rtb_private" {
  for_each = toset(local.private_subnets)
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_route" "route_nat_gateway" {
  for_each = toset(local.private_subnets)
  destination_cidr_block  = "0.0.0.0/0"
  route_table_id          = aws_route_table.rtb_private[each.value].id
  gateway_id              = aws_nat_gateway.main_natgw[each.value].id
}

resource "aws_route_table_association" "association_private" {
  for_each        = toset(local.private_subnets)
  subnet_id       = aws_subnet.subnet[each.value].id
  route_table_id  = aws_route_table.rtb_private[each.value].id
}

