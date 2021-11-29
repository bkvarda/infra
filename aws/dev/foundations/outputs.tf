output "dev_vpc" {
    vpc_id = module.dev_vpc.vpc_id
    private_subnets = module.dev_vpc.private_subnets
    default_security_group_id = [module.dev_vpc.default_security_group_id]
}
