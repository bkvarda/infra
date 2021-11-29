# Provider
provider "databricks" {
  alias    = "mws"
  host     = "https://accounts.cloud.databricks.com"
  username = var.databricks_account_username
  password = var.databricks_account_password
}

# Datasource config (existing customer VPC)
data "terraform_remote_state" "vpc" {
    backend = "remote"

    config = {
        organization = "kvarda-dev"
        workspaces = {
            name = "infra-dev-foundations"
        }
    }
}


# Network configuration
resource "databricks_mws_networks" "this" {
  provider           = databricks.mws
  account_id         = var.databricks_account_id
  network_name       = "${var.workspace_prefix}-network"
  security_group_ids = [terraform_remote_state.vpc.outputs.dev_default_security_group_id]
  subnet_ids         = terraform_remote_state.vpc.outputs.dev_private_subnets
  vpc_id             = terraform_remote_state.vpc.outputs.dev_vpc_id
}

# Root bucket configuration
resource "aws_s3_bucket" "root_storage_bucket" {
  bucket = "${var.workspace_prefix}-rootbucket"
  acl    = "private"
  versioning {
    enabled = false
  }
  force_destroy = true
  tags = {
    Name = "${var.workspace_prefix}-rootbucket"
  }
}

resource "aws_s3_bucket_public_access_block" "root_storage_bucket" {
  bucket             = aws_s3_bucket.root_storage_bucket.id
  ignore_public_acls = true
  depends_on         = [aws_s3_bucket.root_storage_bucket]
}

data "databricks_aws_bucket_policy" "this" {
  bucket = aws_s3_bucket.root_storage_bucket.bucket
}

resource "aws_s3_bucket_policy" "root_bucket_policy" {
  bucket = aws_s3_bucket.root_storage_bucket.id
  policy = data.databricks_aws_bucket_policy.this.json
}

resource "databricks_mws_storage_configurations" "this" {
  provider                   = databricks.mws
  account_id                 = var.databricks_account_id
  bucket_name                = aws_s3_bucket.root_storage_bucket.bucket
  storage_configuration_name = "${var.workspace_prefix}-storage"
}

# Cross-account IAM role 
data "databricks_aws_assume_role_policy" "this" {
  external_id = var.databricks_account_id
}

resource "aws_iam_role" "cross_account_role" {
  name               = "${var.workspace_prefix}-crossaccount"
  assume_role_policy = data.databricks_aws_assume_role_policy.this.json
}

data "databricks_aws_crossaccount_policy" "this" {
}

resource "aws_iam_role_policy" "this" {
  name   = "${var.workspace_prefix}-policy"
  role   = aws_iam_role.cross_account_role.id
  policy = data.databricks_aws_crossaccount_policy.this.json
}

resource "databricks_mws_credentials" "this" {
  provider         = databricks.mws
  account_id       = var.databricks_account_id
  role_arn         = aws_iam_role.cross_account_role.arn
  credentials_name = "${var.workspace_prefix}-creds"
  depends_on       = [aws_iam_role_policy.this]
}

### Provision workspace
resource "databricks_mws_workspaces" "this" {
  provider        = databricks.mws
  account_id      = var.databricks_account_id
  aws_region      = var.region
  workspace_name  = var.workspace_prefix
  deployment_name = var.workspace_prefix

  credentials_id           = databricks_mws_credentials.this.credentials_id
  storage_configuration_id = databricks_mws_storage_configurations.this.storage_configuration_id
  network_id               = databricks_mws_networks.this.network_id
}

// create PAT token to provision entities within workspace
resource "databricks_token" "pat" {
  provider = databricks.created_workspace
  comment  = "Terraform Provisioning"
  lifetime_seconds = 86400
}