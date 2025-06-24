# Changelog

## [3.0.1](https://github.com/cloudandthings/terraform-aws-s3-bucket-replication/compare/v3.0.0...v3.0.1) (2025-06-24)


### Bug Fixes

* Make tags an optional variable ([#13](https://github.com/cloudandthings/terraform-aws-s3-bucket-replication/issues/13)) ([de350bf](https://github.com/cloudandthings/terraform-aws-s3-bucket-replication/commit/de350bfa89cd0171270af7d6a6aec600f8ff0ce1))

## [3.0.0](https://github.com/cloudandthings/terraform-aws-s3-bucket-replication/compare/v2.1.0...v3.0.0) (2023-12-19)


### ⚠ BREAKING CHANGES

* Bump AWS provider ([#11](https://github.com/cloudandthings/terraform-aws-s3-bucket-replication/issues/11))

### Bug Fixes

* Bump AWS provider ([#11](https://github.com/cloudandthings/terraform-aws-s3-bucket-replication/issues/11)) ([417599d](https://github.com/cloudandthings/terraform-aws-s3-bucket-replication/commit/417599d031d85c2f681fdb22ed2a349d2126a5c6))

## [2.1.0](https://github.com/cloudandthings/terraform-aws-s3-bucket-replication/compare/v2.0.0...v2.1.0) (2023-05-05)


### Features

* Cross-account example ([#7](https://github.com/cloudandthings/terraform-aws-s3-bucket-replication/issues/7)) ([30bc4bb](https://github.com/cloudandthings/terraform-aws-s3-bucket-replication/commit/30bc4bb1992f85704490ecb14811dc89ba59e4c6))


### Bug Fixes

* 2023-05-05-update-conftest ([#10](https://github.com/cloudandthings/terraform-aws-s3-bucket-replication/issues/10)) ([250b48e](https://github.com/cloudandthings/terraform-aws-s3-bucket-replication/commit/250b48e1ada2c983967eda0adf16ed5637078ed9))

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
