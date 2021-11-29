resource "aws_s3_bucket" "root_storage_bucket" {
  bucket = "${vars.vpc_name}-rootbucket"
  acl    = "private"
  versioning {
    enabled = false
  }
  force_destroy = true
  tags = {
    Name = "${vars.vpc_name}-rootbucket"
  }
}