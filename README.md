# Terraform AWS Template

## Description

*...example content; edit as needed...*

Terraform module for...

Features:

 - Creates an...

[AWS documentation](https://docs.aws.amazon.com...)

----
## Prerequisites

*...example content; edit as needed...*

None.

----
## Usage

*...example content; edit as needed...*

See `examples` dropdown on Terraform Cloud, or [browse here](/examples/).

----
## Testing

*...example content; edit as needed...*

This module is tested during development using [`pytest`](https://docs.pytest.org/en/7.2.x/) and [`tftest`](https://pypi.org/project/tftest/). See the `tests` folder for further details, and in particular the [testing readme](./tests/README.md).

----
## Notes

*...example content; edit as needed...*

*This repo was created from [terraform-aws-template](https://github.com/cloudandthings/terraform-aws-template)*


----
## Known issues

*...example content; edit as needed...*

This project is currently unlicenced. Please contact the maintaining team to add a licence.

----
## Contributing

*...example content; edit as needed...*

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
| <a name="input_create_destination_resources"></a> [create\_destination\_resources](#input\_create\_destination\_resources) | Whether to create destination resources. Use when enabling cross-account replication. | `bool` | `false` | no |
| <a name="input_create_source_resources"></a> [create\_source\_resources](#input\_create\_source\_resources) | Whether to create source resources. Use when enabling cross-account replication | `bool` | `true` | no |
| <a name="input_destination_bucket_kms_key_arn"></a> [destination\_bucket\_kms\_key\_arn](#input\_destination\_bucket\_kms\_key\_arn) | Destination S3 bucket KMS Key ARN | `string` | `null` | no |
| <a name="input_destination_bucket_name"></a> [destination\_bucket\_name](#input\_destination\_bucket\_name) | Destination S3 bucket name | `string` | n/a | yes |
| <a name="input_enable_delete_marker_replication"></a> [enable\_delete\_marker\_replication](#input\_enable\_delete\_marker\_replication) | Whether delete markers are replicated. | `bool` | `true` | no |
| <a name="input_enable_object_owner_override"></a> [enable\_object\_owner\_override](#input\_enable\_object\_owner\_override) | Whether to change replica object ownership to the destination account. Use when enabling cross-account replication. | `bool` | `false` | no |
| <a name="input_enable_replication_time_control_and_metrics"></a> [enable\_replication\_time\_control\_and\_metrics](#input\_enable\_replication\_time\_control\_and\_metrics) | Whether to enable S3 Replication Time Control (S3 RTC) and Replication Metrics. | `bool` | `false` | no |
| <a name="input_naming_prefix_role"></a> [naming\_prefix\_role](#input\_naming\_prefix\_role) | Naming prefix for replication role. | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | S3 bucket prefix to replicate. | `string` | `""` | no |
| <a name="input_source_bucket_kms_key_arn"></a> [source\_bucket\_kms\_key\_arn](#input\_source\_bucket\_kms\_key\_arn) | Source S3 bucket KMS Key ARN | `string` | `null` | no |
| <a name="input_source_bucket_name"></a> [source\_bucket\_name](#input\_source\_bucket\_name) | Source S3 bucket name | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of additional tags to assign to created resources. If configured with a provider `default_tags` configuration block present, tags with matching keys will overwrite those defined at the provider-level. | `map(string)` | n/a | yes |

----
### Modules

No modules.

----
### Outputs

| Name | Description |
|------|-------------|
| <a name="output_destination_bucket_policy"></a> [destination\_bucket\_policy](#output\_destination\_bucket\_policy) | Destination S3 bucket policy for cross-account replication |
| <a name="output_destination_kms_key_policy"></a> [destination\_kms\_key\_policy](#output\_destination\_kms\_key\_policy) | Destination KMS key policy for cross-account replication |

----
### Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.9 |
| <a name="provider_aws.destination"></a> [aws.destination](#provider\_aws.destination) | ~> 4.9 |
| <a name="provider_aws.source"></a> [aws.source](#provider\_aws.source) | ~> 4.9 |

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
| [aws_iam_policy_document.destination_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.destination_kms_key_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.replication_role_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.replication_role_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.destination](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_region.source](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

----
<!-- END_TF_DOCS -->
