<!-- BEGIN_TF_DOCS -->
----
## main.tf
```hcl
#--------------------------------------------------------------------------------------
# Supporting resources
#--------------------------------------------------------------------------------------
# Generate unique naming for resources
resource "random_integer" "naming" {
  min = 100000
  max = 999999
}

data "aws_caller_identity" "current" {}

locals {
  naming_prefix = "example-repl-${random_integer.naming.id}-${data.aws_caller_identity.current.account_id}"
}

resource "aws_kms_key" "source" {
  description = "${local.naming_prefix}-source"

  deletion_window_in_days = 7
  enable_key_rotation     = true

  provider = aws.account_A
}

module "s3_bucket_source" {
  # source  = "app.terraform.io/cloudandthings/s3-bucket/aws"
  # version = "1.2.0"
  source = "../../modules/external/s3_bucket"

  name       = "${local.naming_prefix}-source"
  kms_key_id = aws_kms_key.source.arn

  enable_versioning = true # Required for replication
  force_destroy     = true

  tags = {}

  providers = {
    aws = aws.account_A
  }
}

module "s3_bucket_destination" {
  # source  = "app.terraform.io/cloudandthings/s3-bucket/aws"
  # version = "1.2.0"
  source = "../../modules/external/s3_bucket"

  name = "${local.naming_prefix}-dest"

  enable_versioning = true # Required for replication
  force_destroy     = true

  tags = {}

  providers = {
    aws = aws.account_B
  }
}

#--------------------------------------------------------------------------------------
# Example
#--------------------------------------------------------------------------------------
module "example" {
  # Uncomment and update as needed
  # source  = "app.terraform.io/cloudandthings/s3-bucket-replication/aws"
  # version = "~> 1.0"
  source = "../../"

  name_for_created_iam_resources = local.naming_prefix

  source_bucket_name        = module.s3_bucket_source.bucket
  source_bucket_kms_key_arn = aws_kms_key.source.arn

  replication_configuration = [
    {
      prefix = null # will replicate entire bucket

      destination_bucket_name        = module.s3_bucket_destination.bucket
      destination_bucket_region      = null # will use provider region
      destination_bucket_kms_key_arn = null
      destination_aws_account_id     = "000273210632"

      enable_delete_marker_replication            = true
      enable_replication_time_control_and_metrics = true
    }
  ]

  tags = {}

  providers = {
    aws = aws.account_A
  }
  depends_on = [
    module.s3_bucket_source, module.s3_bucket_destination
  ]
}
```
----

## Documentation

----
### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_profile"></a> [profile](#input\_profile) | AWS profile | `string` | `null` | no |

----
### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_example"></a> [example](#module\_example) | ../../ | n/a |
| <a name="module_s3_bucket_destination"></a> [s3\_bucket\_destination](#module\_s3\_bucket\_destination) | ../../modules/external/s3_bucket | n/a |
| <a name="module_s3_bucket_source"></a> [s3\_bucket\_source](#module\_s3\_bucket\_source) | ../../modules/external/s3_bucket | n/a |

----
### Outputs

| Name | Description |
|------|-------------|
| <a name="output_module_example"></a> [module\_example](#output\_module\_example) | module.example |
| <a name="output_module_s3_bucket_destination"></a> [module\_s3\_bucket\_destination](#output\_module\_s3\_bucket\_destination) | module.s3\_bucket\_destination |
| <a name="output_module_s3_bucket_source"></a> [module\_s3\_bucket\_source](#output\_module\_s3\_bucket\_source) | module.s3\_bucket\_source |

----
### Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |
| <a name="provider_aws.account_A"></a> [aws.account\_A](#provider\_aws.account\_A) | ~> 5.0 |
| <a name="provider_random"></a> [random](#provider\_random) | ~> 3.4 |

----
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.4 |

----
### Resources

| Name | Type |
|------|------|
| [aws_kms_key.source](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [random_integer.naming](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

----
<!-- END_TF_DOCS -->
