output "bucket_arn" {
  description = "The bucket ARN that is created."
  value       = aws_s3_bucket.this.arn
}

output "bucket" {
  description = "The bucket that is created."
  value       = aws_s3_bucket.this.bucket
}

output "bucket_id" {
  description = "The bucket id that is created."
  value       = aws_s3_bucket.this.id
}

output "kms_key_id" {
  description = "The KMS key ID used for encrypting bucket objects."
  value       = var.kms_key_id
}

output "region" {
  description = "The bucket region."
  value       = aws_s3_bucket.this.region
}

output "default_bucket_policy_document" {
  description = "Default bucket policy document, attached to the bucket if `var.attach_default_bucket_policy=true`."
  value       = data.aws_iam_policy_document.default_bucket_policy_document
}
