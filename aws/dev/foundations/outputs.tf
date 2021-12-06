output "dev_vpc_id" {
    value = module.dev_vpc.vpc_id
}

output "dev_vpc_private_subnets" {
    value = module.dev_vpc.private_subnets
}

output "dev_vpc_default_security_group_id" {
    value = [module.dev_vpc.default_security_group_id]
}

output "other_dev_vpc_id" {
    value = module.other_dev_vpc.vpc_id
}

output "other_dev_vpc_private_subnets" {
    value = module.other_dev_vpc.private_subnets
}

output "dev_vpc_default_security_group_id" {
    value = [module.other_dev_vpc.default_security_group_id]
}

