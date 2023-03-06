#--------------------------------------------------------------------------------------
# Supporting resources
#--------------------------------------------------------------------------------------
# Generate unique naming for resources
resource "random_integer" "naming" {
  min = 100000
  max = 999999
}

locals {
  naming_prefix = "example-repl-${random_integer.naming.id}"
}

resource "aws_kms_key" "source" {
  description = "${local.naming_prefix}-source"

  deletion_window_in_days = 7
  enable_key_rotation     = true

  provider = aws.afs1
}

module "s3_bucket_source" {
  # source  = "app.terraform.io/cloudandthings/s3-bucket/aws"
  # version = "1.2.0"
  source = "../../modules/external/s3_bucket"

  name       = "${local.naming_prefix}-afs1-source"
  kms_key_id = aws_kms_key.source.arn

  enable_versioning = true # Required for replication
  force_destroy     = true

  tags = {}

  providers = {
    aws = aws.afs1
  }
}

resource "aws_kms_key" "destination" {
  description = "${local.naming_prefix}-dest"

  deletion_window_in_days = 7
  enable_key_rotation     = true

  provider = aws.euw1
}

module "s3_bucket_destination" {
  # source  = "app.terraform.io/cloudandthings/s3-bucket/aws"
  # version = "1.2.0"
  source = "../../modules/external/s3_bucket"

  name       = "${local.naming_prefix}-euw1-dest"
  kms_key_id = aws_kms_key.destination.arn

  enable_versioning = true # Required for replication
  force_destroy     = true

  tags = {}

  providers = {
    aws = aws.euw1
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

  source_bucket_name      = module.s3_bucket_source.bucket
  destination_bucket_name = module.s3_bucket_destination.bucket

  enable_replication_time_control_and_metrics = true

  tags = {}

  providers = {
    aws.source      = aws.afs1
    aws.destination = aws.euw1
  }
}
