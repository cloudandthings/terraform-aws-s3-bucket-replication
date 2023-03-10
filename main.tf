
locals {
  source_region     = coalesce(var.source_bucket_region, data.aws_region.current.name)
  source_bucket_arn = "arn:aws:s3:::${var.source_bucket_name}"
}

######################################################################
## IAM
######################################################################
resource "aws_iam_role" "this" {
  count = var.create_iam_resources ? 1 : 0

  name               = var.name_for_created_iam_resources
  assume_role_policy = data.aws_iam_policy_document.replication_role_assume_role_policy.json

  permissions_boundary = var.aws_iam_role_permissions_boundary

  tags = var.tags
}

resource "aws_iam_policy" "this" {
  count = var.create_iam_resources ? 1 : 0

  name   = var.name_for_created_iam_resources
  policy = data.aws_iam_policy_document.replication_role_policy_document.json
}

resource "aws_iam_role_policy_attachment" "this" {
  count = var.create_iam_resources ? 1 : 0

  role       = aws_iam_role.this[0].name
  policy_arn = aws_iam_policy.this[0].arn
}

locals {
  replication_role_arn = try(aws_iam_role.this[0].arn, var.replication_role_arn)
}

## Bucket Replication Configuration
resource "aws_s3_bucket_replication_configuration" "this" {
  # Must have bucket versioning enabled first

  role   = local.replication_role_arn
  bucket = var.source_bucket_name

  dynamic "rule" {
    for_each = {
      for c in var.replication_configuration :
      index(var.replication_configuration, c) => c
    }

    content {
      id       = "rule-${rule.key}"
      priority = rule.key

      filter {
        prefix = rule.value.prefix
      }
      status = "Enabled"

      destination {
        # TODO
        bucket = "arn:aws:s3:::${rule.value.destination_bucket_name}"
        # storage_class = "STANDARD"
        dynamic "encryption_configuration" {
          for_each = var.source_bucket_kms_key_arn != null ? toset([1]) : toset([])
          content {
            replica_kms_key_id = rule.value.destination_bucket_kms_key_arn
          }
        }

        dynamic "access_control_translation" {
          for_each = rule.value.destination_aws_account_id != null ? toset([1]) : toset([])
          content {
            owner = "Destination"
          }
        }
        account = rule.value.destination_aws_account_id

        replication_time {
          status = rule.value.enable_replication_time_control_and_metrics ? "Enabled" : "Disabled"
          time {
            minutes = 15
          }
        }
        metrics {
          status = rule.value.enable_replication_time_control_and_metrics ? "Enabled" : "Disabled"
          event_threshold {
            minutes = 15
          }
        }
      }

      dynamic "source_selection_criteria" {
        for_each = var.source_bucket_kms_key_arn != null ? toset([1]) : toset([])
        content {
          sse_kms_encrypted_objects {
            status = "Enabled"
          }
        }
      }

      delete_marker_replication {
        status = rule.value.enable_delete_marker_replication ? "Enabled" : "Disabled"
      }

    }
  }
}
