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

locals {
  naming_prefix = "example-repl-${random_integer.naming.id}"
}

resource "aws_kms_key" "source" {
  description = "${local.naming_prefix}-source"

  deletion_window_in_days = 7
  enable_key_rotation     = true

  provider = aws.afs1
}

module "s3_bucket_source" {
  # source  = "app.terraform.io/cloudandthings/s3-bucket/aws"
  # version = "1.2.0"
  source = "../../modules/external/s3_bucket"

  name       = "${local.naming_prefix}-afs1-source"
  kms_key_id = aws_kms_key.source.arn

  enable_versioning = true # Required for replication
  force_destroy     = true

  tags = {}

  providers = {
    aws = aws.afs1
  }
}

resource "aws_kms_key" "destination" {
  description = "${local.naming_prefix}-dest"

  deletion_window_in_days = 7
  enable_key_rotation     = true

  provider = aws.euw1
}

module "s3_bucket_destination" {
  # source  = "app.terraform.io/cloudandthings/s3-bucket/aws"
  # version = "1.2.0"
  source = "../../modules/external/s3_bucket"

  name       = "${local.naming_prefix}-euw1-dest"
  kms_key_id = aws_kms_key.destination.arn

  enable_versioning = true # Required for replication
  force_destroy     = true

  tags = {}

  providers = {
    aws = aws.euw1
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

  naming_prefix_role = local.naming_prefix

  source_bucket_name      = module.s3_bucket_source.bucket
  destination_bucket_name = module.s3_bucket_destination.bucket

  enable_replication_time_control_and_metrics = true

  tags = {}

  providers = {
    aws.source      = aws.afs1
    aws.destination = aws.euw1
  }
}
```
----

## Documentation

----
### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_profile"></a> [profile](#input\_profile) | AWS profile | `string` | n/a | yes |

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
| <a name="provider_aws.afs1"></a> [aws.afs1](#provider\_aws.afs1) | ~> 4.9 |
| <a name="provider_aws.euw1"></a> [aws.euw1](#provider\_aws.euw1) | ~> 4.9 |
| <a name="provider_random"></a> [random](#provider\_random) | ~> 3.4 |

----
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.9 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.4 |

----
### Resources

| Name | Type |
|------|------|
| [aws_kms_key.destination](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key.source](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [random_integer.naming](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) | resource |

----
<!-- END_TF_DOCS -->
