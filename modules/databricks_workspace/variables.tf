# WIP example
variable "workspace_name" {
    description = "Workspace Name"
    type = string
}

variable "deployment_name" {
    description = "Deployment Name"
    type = string
}

variable "cloud" {
    description = "Cloud that workspace is going to be deployed into"
    type = string
    validation {
        condition = contains(["aws", "gcp", "azure"], var.cloud)
        error_message = "Valid values for cloud are: (aws, gcp, azure)"
    }
}

variable "account_or_project_id" {
    description = "AWS Account or GCP Project ID where workspace will be deployed"
    type = string
}

variable "region" {
    description = "Region to be used"
    default     = ""
}

variable "region" {
    description = "Region to be used"
    default     = ""
}