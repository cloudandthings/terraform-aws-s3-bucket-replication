output "destination_bucket_policy" {
  description = "Destination S3 bucket policy for cross-account replication"
  value       = try(data.aws_iam_policy_document.destination_bucket_policy[0].json, "")
}

output "destination_kms_key_policy" {
  description = "Destination KMS key policy for cross-account replication"
  value       = try(data.aws_iam_policy_document.destination_kms_key_policy[0].json, "")
}
