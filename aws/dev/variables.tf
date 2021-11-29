variable "allowed_account_ids" {
    description = "List of allowed AWS account ids where resources can be created"
    type = list
    default = []
}

variable "vpc_name" {
    description = "Name to be used on all the resources as identifier"
    default     = ""
}

variable "region" {
    description = "Region to be used"
    default     = ""
}

variable "provision_nat_gw" {
    description = "Toggle for provisioning/de-provisioning NAT gw to save money"
    default     = true
}