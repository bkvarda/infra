resource "aws_s3_bucket" "root_storage_bucket" {
  bucket = "${var.vpc_name}-rootbucket"
  acl    = "private"
  versioning {
    enabled = false
  }
  force_destroy = true
  tags = {
    Name = "${var.vpc_name}-rootbucket"
  }
}