#--------------------------------------------------------------------------------------
# Supporting resources
#--------------------------------------------------------------------------------------
# Generate unique naming for resources
resource "random_integer" "naming" {
  min = 100000
  max = 999999
}

data "aws_caller_identity" "current" {}

locals {
  naming_prefix = "example-repl-${random_integer.naming.id}-${data.aws_caller_identity.current.account_id}"
}

resource "aws_kms_key" "source" {
  description = "${local.naming_prefix}-source"

  deletion_window_in_days = 7
  enable_key_rotation     = true

  provider = aws.account_A
}

module "s3_bucket_source" {
  source  = "app.terraform.io/cloudandthings/s3-bucket/aws"
  version = "2.0.0"

  name       = "${local.naming_prefix}-source"
  kms_key_id = aws_kms_key.source.arn

  enable_versioning = true # Required for replication
  force_destroy     = true

  tags = {}

  providers = {
    aws = aws.account_A
  }
}

module "s3_bucket_destination" {
  source  = "app.terraform.io/cloudandthings/s3-bucket/aws"
  version = "2.0.0"

  name = "${local.naming_prefix}-dest"

  enable_versioning = true # Required for replication
  force_destroy     = true

  tags = {}

  providers = {
    aws = aws.account_B
  }
}

#--------------------------------------------------------------------------------------
# Example
#--------------------------------------------------------------------------------------
module "example" {
  # Uncomment and update as needed
  # source  = "app.terraform.io/cloudandthings/s3-bucket-replication/aws"
  # version = "~> 1.0"
  source = "../../"

  name_for_created_iam_resources = local.naming_prefix

  source_bucket_name        = module.s3_bucket_source.bucket
  source_bucket_kms_key_arn = aws_kms_key.source.arn

  replication_configuration = [
    {
      prefix = null # will replicate entire bucket

      destination_bucket_name        = module.s3_bucket_destination.bucket
      destination_bucket_region      = null # will use provider region
      destination_bucket_kms_key_arn = null
      destination_aws_account_id     = "000273210632"

      enable_delete_marker_replication            = true
      enable_replication_time_control_and_metrics = true
    }
  ]

  tags = {}

  providers = {
    aws = aws.account_A
  }
  depends_on = [
    module.s3_bucket_source, module.s3_bucket_destination
  ]
}
