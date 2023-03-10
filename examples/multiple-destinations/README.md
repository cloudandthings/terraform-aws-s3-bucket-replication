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

  name       = "${local.naming_prefix}-source"
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

  provider = aws.afs1
}

module "s3_bucket_destinations" {
  count = 2
  # source  = "app.terraform.io/cloudandthings/s3-bucket/aws"
  # version = "1.2.0"
  source = "../../modules/external/s3_bucket"

  name       = "${local.naming_prefix}-dest-${count.index}"
  kms_key_id = aws_kms_key.destination.arn

  enable_versioning = true # Required for replication
  force_destroy     = true

  tags = {}

  providers = {
    aws = aws.afs1
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
    for s3_bucket_destination in module.s3_bucket_destinations :
    {
      destination_bucket_name        = s3_bucket_destination.bucket
      destination_bucket_kms_key_arn = aws_kms_key.destination.arn

      enable_replication_time_control_and_metrics = true
    }
  ]

  tags = {}

  depends_on = [
    module.s3_bucket_source, module.s3_bucket_destinations
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
| <a name="module_s3_bucket_destinations"></a> [s3\_bucket\_destinations](#module\_s3\_bucket\_destinations) | ../../modules/external/s3_bucket | n/a |
| <a name="module_s3_bucket_source"></a> [s3\_bucket\_source](#module\_s3\_bucket\_source) | ../../modules/external/s3_bucket | n/a |

----
### Outputs

| Name | Description |
|------|-------------|
| <a name="output_module_example"></a> [module\_example](#output\_module\_example) | module.example |
| <a name="output_module_s3_bucket_destinations"></a> [module\_s3\_bucket\_destinations](#output\_module\_s3\_bucket\_destinations) | module.s3\_bucket\_destinations |
| <a name="output_module_s3_bucket_source"></a> [module\_s3\_bucket\_source](#output\_module\_s3\_bucket\_source) | module.s3\_bucket\_source |

----
### Providers

| Name | Version |
|------|---------|
| <a name="provider_aws.afs1"></a> [aws.afs1](#provider\_aws.afs1) | ~> 4.9 |
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
