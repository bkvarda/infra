variable "account_ids" {
    description = "List of allowed AWS account ids where resources can be created"
    type = list
    default = []
}

variable "region" {
    description = "Region to be used"
}

variable "resource_name_prefix" {
    description = "Name prefix used when creating resources"

}