output "quickstart_vpc_id" {
    value = module.quickstart_vpc.vpc_id
}

output "quickstart_vpc_private_subnets" {
    value = module.quickstart_vpc.private_subnets
}

output "quickstart_vpc_default_security_group_id" {
    value = [module.quickstart_vpc.default_security_group_id]
}
