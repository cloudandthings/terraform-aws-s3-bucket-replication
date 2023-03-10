# Changelog

## [2.0.0](https://github.com/cloudandthings/terraform-aws-s3-bucket-replication/compare/v1.0.0...v2.0.0) (2023-03-10)


### ⚠ BREAKING CHANGES

* Support multiple replication rules. Use `replication_configuration` map instead of previous variables.
* Rework cross-region handling

### Features

* Add `destination_aws_account_id` for cross-account replication ([b832226](https://github.com/cloudandthings/terraform-aws-s3-bucket-replication/commit/b832226e6a29a9e1f994286abddce2eff223197e))
* Support multiple replication rules. Use `replication_configuration` map instead of previous variables. ([30fcb54](https://github.com/cloudandthings/terraform-aws-s3-bucket-replication/commit/30fcb54f12321a6626cb871f3abba9cd62c1da28))


### Bug Fixes

* Remove destination resources ([517dabd](https://github.com/cloudandthings/terraform-aws-s3-bucket-replication/commit/517dabd615686d5a3dc5a75d5a112b7acd59270e))
* Rework cross-region handling ([744f3df](https://github.com/cloudandthings/terraform-aws-s3-bucket-replication/commit/744f3dfe3aa533f50cbd91b7a33d49ccfee39af0))

## 1.0.0 (2023-03-06)


### Features

* Initial commit ([#1](https://github.com/cloudandthings/terraform-aws-s3-bucket-replication/issues/1)) ([e17d503](https://github.com/cloudandthings/terraform-aws-s3-bucket-replication/commit/e17d50349c7e5a785689b6e4bc47d1b7a8374b61))
