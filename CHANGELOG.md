# Change Log

All notable changes to this module will be documented in this file.

## [1.0.5] - 2022-07-01

### Added

- default policy for aws ssm

## [1.0.4] - 2022-06-28

### Added

- resources
  - iam for create default instance profile

- variables
  - `is_create_default_profile`
  - `override_profile_policy`
  - `override_profile_assume_role_policy`
  - `additional_profile_policy_arns`

## [1.0.3] - 2022-06-18

Here we would have the update steps for 1.0.3 for people to follow.

### Added

- outputs
  - `security_group_id`
  - `security_group_arn`

### Changed

- naming security group

## [1.0.2] - 2022-04-22
  
Here we would have the update steps for 1.0.2 for people to follow.

### Added

- variables
  - `name` for naming ec2

## [1.0.1] - 2022-04-18

### Fix

- bug network interface

## [1.0.0] - 2022-04-08

### Added

- init terraform-aws-ec2-instance module
