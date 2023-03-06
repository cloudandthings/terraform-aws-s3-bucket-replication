#--------------------------------------------------------------------------------------
# Regions
#--------------------------------------------------------------------------------------
data "aws_region" "source" {
  provider = aws.source
}

data "aws_region" "destination" {
  provider = aws.destination
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
    resources = [
      local.source_bucket_arn,
      local.destination_bucket_arn,
      "${local.destination_bucket_arn}/*",
      "${local.source_bucket_arn}/*"
    ]
  }

  statement {
    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
      "s3:ReplicateTags",
      "s3:GetObjectVersionTagging"
    ]
    resources = [
      "${local.destination_bucket_arn}/*",
      "${local.source_bucket_arn}/*"
    ]
  }

  dynamic "statement" {
    for_each = var.enable_object_owner_override ? toset([1]) : toset([])
    content {
      actions   = ["s3:ObjectOwnerOverrideToBucketOwner"]
      resources = ["${local.destination_bucket_arn}/*"]
    }
  }

  statement {
    actions = [
      "kms:Decrypt"
    ]
    resources = [var.source_bucket_kms_key_arn]

    condition {
      test     = "StringLike"
      variable = "kms:ViaService"
      values = [
        "s3.${local.source_region}.amazonaws.com"
      ]
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

  statement {
    actions = [
      "kms:Encrypt"
    ]
    resources = [var.destination_bucket_kms_key_arn]

    condition {
      test     = "StringLike"
      variable = "kms:ViaService"
      values = [
        "s3.${local.destination_region}.amazonaws.com"
      ]
    }
    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:s3:arn"
      values = [
        # When bucket_key_enabled
        local.destination_bucket_arn,
        # When NOT bucket_key_enabled
        "${local.destination_bucket_arn}/*"
      ]
    }
  }
}

#--------------------------------------------------------------------------------------
# Destination bucket policy document
#--------------------------------------------------------------------------------------
/*

Doesnt make sense to create dest resources in the same module
They only apply in cross-account scenarios and need input of the IAM role ARN.

data "aws_iam_policy_document" "destination_bucket_policy" {
  count = var.create_destination_resources ? 1 : 0
  statement {
    actions = [
      "s3:List*",
      "s3:GetBucketVersioning",
      "s3:PutBucketVersioning"
    ]
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.this[0].arn]
    }
    resources = [local.destination_bucket_arn]
  }
  statement {
    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete"
    ]
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.this[0].arn]
    }
    resources = ["${local.destination_bucket_arn}/*"]
  }

  dynamic "statement" {
    for_each = var.enable_object_owner_override ? toset([1]) : toset([])
    content {
      principals {
        type        = "AWS"
        identifiers = [aws_iam_role.this[0].arn]
      }
      actions   = ["s3:ObjectOwnerOverrideToBucketOwner"]
      resources = ["${local.destination_bucket_arn}/*"]
    }
  }
}

#--------------------------------------------------------------------------------------
# Destination kms_key policy document
#--------------------------------------------------------------------------------------
data "aws_iam_policy_document" "destination_kms_key_policy" {
  count = var.create_destination_resources ? 1 : 0
  statement {
    actions = [
      "kms:Encrypt"
    ]
    resources = [var.destination_bucket_kms_key_arn]

    condition {
      test     = "StringLike"
      variable = "kms:ViaService"
      values = [
        "s3.${local.destination_region}.amazonaws.com"
      ]
    }
    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:s3:arn"
      values = [
        # When bucket_key_enabled
        local.destination_bucket_arn,
        # When NOT bucket_key_enabled
        "${local.destination_bucket_arn}/*"
      ]
    }
  }
}
*/
