/******************************************
  Quickstart VPC Deployment
 *****************************************/


data "aws_availability_zones" "available" {
    state = "available"
}

resource "aws_eip" "quickstart_nat_ip" {
    count = 1
    vpc = true
}

module "dev_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${resource_name_prefix}-vpc"
  cidr = "10.0.0.0/16"

  azs             = data.aws_availability_zones.available.names
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_dns_hostnames = true
  enable_nat_gateway = true
  create_igw = true
  single_nat_gateway = true
  enable_vpn_gateway = false
  reuse_nat_ips = false
  external_nat_ip_ids = "${aws_eip.quickstart_nat_ip.*.id}"

  default_security_group_egress = [{
    cidr_blocks = "0.0.0.0/0"
  }]

  default_security_group_ingress = [{
    description = "Allow all internal TCP and UDP"
    self        = true
  }]

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}