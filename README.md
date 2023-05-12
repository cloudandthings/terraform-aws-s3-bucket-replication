# terraform-aws-s3-bucket-replication

## Description

Terraform module for enabling S3 replication between two buckets.

Will be used for *HashiTalks: Africa 2023*.

Features:

 - Enable S3 replication between buckets
 - Allow cross-region replication
 - Allow cross-account replication
 - Multiple destinations are supported

[AWS documentation](https://docs.aws.amazon.com...)

----
## Prerequisites

You will need to create 2 S3 buckets. The examples show possible ways to achieve this.

----
## Usage

See `examples` dropdown on Terraform Cloud, or [browse here](/examples/).

----
## Testing

This module is tested during development using [`pytest`](https://docs.pytest.org/en/7.2.x/) and [`tftest`](https://pypi.org/project/tftest/). See the `tests` folder for further details, and in particular the [testing readme](./tests/README.md).

----
## Notes

*This repo was created from [terraform-aws-template](https://github.com/cloudandthings/terraform-aws-template)*


----
## Known issues

This project is currently unlicenced. Please contact the maintaining team to add a licence.

----
## Contributing

Direct contributions are welcome.

See [`CONTRIBUTING.md`](./.github/CONTRIBUTING.md) for further information.

<!-- BEGIN_TF_DOCS -->
----
## Documentation

----
### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_iam_role_permissions_boundary"></a> [aws\_iam\_role\_permissions\_boundary](#input\_aws\_iam\_role\_permissions\_boundary) | AWS IAM Role permissions boundary. | `string` | `null` | no |
| <a name="input_create_iam_resources"></a> [create\_iam\_resources](#input\_create\_iam\_resources) | Whether to create IAM resources. | `bool` | `true` | no |
| <a name="input_name_for_created_iam_resources"></a> [name\_for\_created\_iam\_resources](#input\_name\_for\_created\_iam\_resources) | Name for created IAM resources. | `string` | n/a | yes |
| <a name="input_replication_configuration"></a> [replication\_configuration](#input\_replication\_configuration) | Replication configuration, in priority order. See the comments in `variables.tf` for usage. | <pre>list(object({<br><br>    destination_bucket_name = string<br><br>    # S3 bucket prefix to replicate.<br>    prefix = string # coalesced to ""<br><br>    # Destination S3 bucket KMS Key ARN if applicable.<br>    destination_bucket_kms_key_arn = string<br><br>    # Destination AWS Account ID. Only use for cross-account replication. When specified, replica object ownership will be set to this account.<br>    destination_aws_account_id = string<br><br>    # Destination S3 bucket region. If unspecified, then the provider region is used.<br>    destination_bucket_region = string<br><br>    # Whether delete markers are replicated.<br>    enable_delete_marker_replication = bool # coalesced to true<br><br>    # Whether to enable S3 Replication Time Control (S3 RTC) and Replication Metrics.<br>    enable_replication_time_control_and_metrics = bool # coalesced to false<br>    })<br>  )</pre> | n/a | yes |
| <a name="input_replication_role_arn"></a> [replication\_role\_arn](#input\_replication\_role\_arn) | IAM Role ARN for replication role. | `string` | `null` | no |
| <a name="input_source_bucket_kms_key_arn"></a> [source\_bucket\_kms\_key\_arn](#input\_source\_bucket\_kms\_key\_arn) | Source S3 bucket KMS Key ARN | `string` | `null` | no |
| <a name="input_source_bucket_name"></a> [source\_bucket\_name](#input\_source\_bucket\_name) | Source S3 bucket name | `string` | n/a | yes |
| <a name="input_source_bucket_region"></a> [source\_bucket\_region](#input\_source\_bucket\_region) | Source S3 bucket region. If unspecified, then the provider region is used. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of additional tags to assign to created resources. If configured with a provider `default_tags` configuration block present, tags with matching keys will overwrite those defined at the provider-level. | `map(string)` | n/a | yes |

----
### Modules

No modules.

----
### Outputs

No outputs.

----
### Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.9 |

----
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.9 |

----
### Resources

| Name | Type |
|------|------|
| [aws_iam_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_s3_bucket_replication_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_replication_configuration) | resource |
| [aws_iam_policy_document.replication_role_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.replication_role_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

----
<!-- END_TF_DOCS -->
