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

variable "destination_bucket_name" {
  description = "Destination S3 bucket name"
  type        = string
}

variable "destination_bucket_kms_key_arn" {
  description = "Destination S3 bucket KMS Key ARN"
  type        = string
  default     = null
}

variable "destination_bucket_region" {
  description = "Destination S3 bucket region. If unspecified, then the provider region is used."
  type        = string
  default     = null
}

variable "destination_aws_account_id" {
  description = "Destination AWS Account ID. Only use for cross-account replication. When specified, replica object ownership will be set to this account."
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of additional tags to assign to created resources. If configured with a provider `default_tags` configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
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

variable "prefix" {
  description = "S3 bucket prefix to replicate."
  type        = string
  default     = ""
}

variable "enable_delete_marker_replication" {
  description = "Whether delete markers are replicated."
  type        = bool
  default     = true
}

variable "enable_replication_time_control_and_metrics" {
  description = "Whether to enable S3 Replication Time Control (S3 RTC) and Replication Metrics."

  type    = bool
  default = false
}

/*
variable "create_destination_resources" {
  description = "Whether to create destination resources. Use when enabling cross-account replication."
  type        = bool
  default     = false
}
*/
