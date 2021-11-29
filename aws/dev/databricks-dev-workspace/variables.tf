variable "workspace_prefix" {
    description = "Prefix for workspace name"
    type = string
}

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

# These are stored in Terraform Cloud as variables/variable set
variable "databricks_account_username" {}
variable "databricks_account_password" {}
variable "databricks_account_id" {}