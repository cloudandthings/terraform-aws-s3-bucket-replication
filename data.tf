#--------------------------------------------------------------------------------------
# Regions
#--------------------------------------------------------------------------------------
data "aws_region" "current" {}

#--------------------------------------------------------------------------------------
# Maps
#--------------------------------------------------------------------------------------
locals {
  distinct_destination_bucket_names = distinct([
    for c in var.replication_configuration : c.destination_bucket_name
  ])
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
      [for x in local.distinct_destination_bucket_names : "arn:aws:s3:::${x}"],
      [for x in local.distinct_destination_bucket_names : "arn:aws:s3:::${x}/*"]
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
      [for x in local.distinct_destination_bucket_names : "arn:aws:s3:::${x}/*"],
    )
  }

  dynamic "statement" {
    for_each = local.distinct_destination_bucket_names
    content {
      actions   = ["s3:ObjectOwnerOverrideToBucketOwner"]
      resources = ["arn:aws:s3:::${statement.value}/*"]
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
    for_each = [
      for c in var.replication_configuration :
      c if c.destination_bucket_kms_key_arn != null
    ]

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
