######################################################################
## Required
######################################################################

variable "name_for_created_iam_resources" {
  type        = string
  description = "Name for created IAM resources."
}

variable "aws_iam_role_permissions_boundary" {
  description = "AWS IAM Role permissions boundary."
  type        = string
  default     = null
}

variable "source_bucket_name" {
  description = "Source S3 bucket name"
  type        = string
}

variable "source_bucket_kms_key_arn" {
  description = "Source S3 bucket KMS Key ARN"
  type        = string
  default     = null
}

variable "source_bucket_region" {
  description = "Source S3 bucket region. If unspecified, then the provider region is used."
  type        = string
  default     = null
}

variable "replication_configuration" {
  description = "Replication configuration, in priority order. See the comments in `variables.tf` for usage."
  type = list(object({

    destination_bucket_name = string

    # S3 bucket prefix to replicate.
    prefix = string # coalesced to ""

    # Destination S3 bucket KMS Key ARN if applicable.
    destination_bucket_kms_key_arn = string

    # Destination AWS Account ID. Only use for cross-account replication. When specified, replica object ownership will be set to this account.
    destination_aws_account_id = string

    # Destination S3 bucket region. If unspecified, then the provider region is used.
    destination_bucket_region = string

    # Whether delete markers are replicated.
    enable_delete_marker_replication = bool # coalesced to true

    # Whether to enable S3 Replication Time Control (S3 RTC) and Replication Metrics.
    enable_replication_time_control_and_metrics = bool # coalesced to false
    })
  )
}

######################################################################
## Optional
######################################################################

variable "create_iam_resources" {
  description = "Whether to create IAM resources."
  type        = bool
  default     = true
}

variable "replication_role_arn" {
  description = "IAM Role ARN for replication role."
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of additional tags to assign to created resources. If configured with a provider `default_tags` configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = null
}
