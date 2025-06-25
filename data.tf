#--------------------------------------------------------------------------------------
# Regions
#--------------------------------------------------------------------------------------
data "aws_region" "current" {}

#--------------------------------------------------------------------------------------
# Locals
#--------------------------------------------------------------------------------------

# In Terraform, order is not preserved in maps.
# This is fine for some resources eg IAM policies.
# However for replication rule priority, maps cannot be used.

locals {
  replication_configuration_unordered = {
    for idx, c in var.replication_configuration
    : idx => c
  }
}

#--------------------------------------------------------------------------------------
# Replication role policy documents
#--------------------------------------------------------------------------------------
data "aws_iam_policy_document" "replication_role_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["s3.amazonaws.com"]
      type        = "Service"
    }
  }
}

data "aws_iam_policy_document" "replication_role_policy_document" {
  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetReplicationConfiguration",
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging",
      "s3:GetObjectRetention",
      "s3:GetObjectLegalHold"
    ]
    resources = concat(
      [local.source_bucket_arn],
      ["${local.source_bucket_arn}/*"],
      [for c in local.replication_configuration_unordered : "arn:aws:s3:::${c.destination_bucket_name}"],
      [for c in local.replication_configuration_unordered : "arn:aws:s3:::${c.destination_bucket_name}/*"]
    )
  }

  statement {
    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
      "s3:ReplicateTags",
      "s3:GetObjectVersionTagging"
    ]
    resources = concat(
      ["${local.source_bucket_arn}/*"],
      [for c in local.replication_configuration_unordered : "arn:aws:s3:::${c.destination_bucket_name}/*"],
    )
  }

  dynamic "statement" {
    for_each = local.replication_configuration_unordered
    content {
      actions   = ["s3:ObjectOwnerOverrideToBucketOwner"]
      resources = ["arn:aws:s3:::${statement.value.destination_bucket_name}/*"]
    }
  }

  dynamic "statement" {
    for_each = var.source_bucket_kms_key_arn != null ? toset([1]) : toset([])
    content {
      actions   = ["kms:Decrypt"]
      resources = [var.source_bucket_kms_key_arn]
      condition {
        test     = "StringLike"
        variable = "kms:ViaService"
        values   = ["s3.${local.source_region}.amazonaws.com"]
      }
      condition {
        test     = "StringLike"
        variable = "kms:EncryptionContext:aws:s3:arn"
        values = [
          # When bucket_key_enabled
          local.source_bucket_arn,
          # When NOT bucket_key_enabled
          "${local.source_bucket_arn}/*"
        ]
      }
    }
  }

  dynamic "statement" {
    for_each = {
      for idx, c in local.replication_configuration_unordered :
      idx => c
      if c.destination_bucket_kms_key_arn != null
    }

    content {
      actions   = ["kms:Encrypt"]
      resources = [statement.value.destination_bucket_kms_key_arn]
      condition {
        test     = "StringLike"
        variable = "kms:ViaService"
        values = (
          statement.value.destination_bucket_region != null
          ? ["s3.${statement.value.destination_bucket_region}.amazonaws.com"]
          : ["s3.${data.aws_region.current.name}.amazonaws.com"]
        )
      }
      condition {
        test     = "StringLike"
        variable = "kms:EncryptionContext:aws:s3:arn"
        values = [
          # When bucket_key_enabled
          "arn:aws:s3:::${statement.value.destination_bucket_name}",
          # When NOT bucket_key_enabled
          "arn:aws:s3:::${statement.value.destination_bucket_name}/*"
        ]
      }
    }
  }
}
