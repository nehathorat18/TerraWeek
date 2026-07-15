# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "terraweek-import-bucket-neha"
resource "aws_s3_bucket" "imported" {
  bucket              = "terraweek-import-bucket-neha"
  bucket_namespace    = "global"
  force_destroy       = false
  object_lock_enabled = false
  region              = "us-east-1"
  tags                = {}
  tags_all            = {}
}
