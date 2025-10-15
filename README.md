# core-services / aws-backup

This module is used to deploy a per-account AWS Backup solution following the Mantel Group MS Core Services pattern. It will deploy AWS Backup with sensible defaults while allowing for customisation.

If using this module, the resulting AWS Backup Plans will provide basic coverage according to best practices and is suitable for most workloads, provided inter-region backups and restores are not required.

AWS Organizations Backup Policies will be handled in their own module.

Note this repository is mirrored from our internal GitLab cluster and all development work takes place there.

## For Contributors

This repository has `pre-commit` hooks so installing `pre-commit` is required. Instructions can be found here: https://pre-commit.com/

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.85.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_backup_plan.additional_plans](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_plan) | resource |
| [aws_backup_plan.continuous](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_plan) | resource |
| [aws_backup_plan.daily](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_plan) | resource |
| [aws_backup_plan.hourly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_plan) | resource |
| [aws_backup_plan.monthly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_plan) | resource |
| [aws_backup_plan.unscoped](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_plan) | resource |
| [aws_backup_plan.weekly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_plan) | resource |
| [aws_backup_plan.yearly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_plan) | resource |
| [aws_backup_selection.additional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_selection) | resource |
| [aws_backup_selection.continuous](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_selection) | resource |
| [aws_backup_selection.daily](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_selection) | resource |
| [aws_backup_selection.hourly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_selection) | resource |
| [aws_backup_selection.monthly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_selection) | resource |
| [aws_backup_selection.unscoped](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_selection) | resource |
| [aws_backup_selection.weekly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_selection) | resource |
| [aws_backup_selection.yearly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_selection) | resource |
| [aws_backup_vault.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_vault) | resource |
| [aws_backup_vault_policy.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_vault_policy) | resource |
| [aws_iam_policy.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.kms_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.managed_policy_attachments](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.kms_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.service_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.service_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.vault_access_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_backup_plan_config"></a> [additional\_backup\_plan\_config](#input\_additional\_backup\_plan\_config) | Contains the general configuration of an AWS Backup Plan. To enable Windows VSS set `enable_vss` to `enabled`. This can be used to set any number of arbitrary additional Backup Plans. | <pre>map(object({<br>    name                     = string<br>    start_window             = number<br>    completion_window        = number<br>    enable_continuous_backup = bool<br>    retention_in_days        = number<br>    selection_tag_value      = string<br>    schedule                 = string<br>    enable_vss               = string<br>  }))</pre> | `{}` | no |
| <a name="input_additional_tags"></a> [additional\_tags](#input\_additional\_tags) | Map of strings for providing arbitrary additional tags in addition to the ones enforced in the terraform.tf file and the Terraform provider. | `map(string)` | `{}` | no |
| <a name="input_continuous_backup_plan_config"></a> [continuous\_backup\_plan\_config](#input\_continuous\_backup\_plan\_config) | Contains the general configuration of the Continuous AWS Backup Plan. | <pre>object({<br>    enabled             = bool<br>    name                = string<br>    start_window        = number<br>    completion_window   = number<br>    retention_in_days   = number<br>    selection_tag_value = string<br>    schedule            = string<br>  })</pre> | <pre>{<br>  "completion_window": 180,<br>  "enabled": true,<br>  "name": "backupContinuous",<br>  "retention_in_days": 3,<br>  "schedule": "cron(0 * ? * * *)",<br>  "selection_tag_value": "Continuous",<br>  "start_window": 60<br>}</pre> | no |
| <a name="input_daily_backup_plan_config"></a> [daily\_backup\_plan\_config](#input\_daily\_backup\_plan\_config) | Contains the general configuration of the Daily AWS Backup Plan. To enable Windows VSS set `enable_vss` to `enabled` | <pre>object({<br>    enabled             = bool<br>    name                = string<br>    start_window        = number<br>    completion_window   = number<br>    retention_in_days   = number<br>    selection_tag_value = string<br>    schedule            = string<br>    enable_vss          = string<br>  })</pre> | <pre>{<br>  "completion_window": 180,<br>  "enable_vss": "disabled",<br>  "enabled": true,<br>  "name": "backupDaily",<br>  "retention_in_days": 35,<br>  "schedule": "cron(0 10 ? * * *)",<br>  "selection_tag_value": "Daily",<br>  "start_window": 60<br>}</pre> | no |
| <a name="input_hourly_backup_plan_config"></a> [hourly\_backup\_plan\_config](#input\_hourly\_backup\_plan\_config) | Contains the general configuration of the Hourly AWS Backup Plan. To enable Windows VSS set `enable_vss` to `enabled` | <pre>object({<br>    enabled             = bool<br>    name                = string<br>    start_window        = number<br>    completion_window   = number<br>    retention_in_days   = number<br>    selection_tag_value = string<br>    schedule            = string<br>    enable_vss          = string<br>  })</pre> | <pre>{<br>  "completion_window": 180,<br>  "enable_vss": "disabled",<br>  "enabled": true,<br>  "name": "backupHourly",<br>  "retention_in_days": 14,<br>  "schedule": "cron(0 * ? * * *)",<br>  "selection_tag_value": "Daily",<br>  "start_window": 60<br>}</pre> | no |
| <a name="input_monthly_backup_plan_config"></a> [monthly\_backup\_plan\_config](#input\_monthly\_backup\_plan\_config) | Contains the general configuration of the Daily AWS Backup Plan. To enable Windows VSS set `enable_vss` to `enabled` | <pre>object({<br>    enabled             = bool<br>    name                = string<br>    start_window        = number<br>    completion_window   = number<br>    retention_in_days   = number<br>    selection_tag_value = string<br>    schedule            = string<br>    enable_vss          = string<br>  })</pre> | <pre>{<br>  "completion_window": 480,<br>  "enable_vss": "disabled",<br>  "enabled": true,<br>  "name": "backupMonthly",<br>  "retention_in_days": 455,<br>  "schedule": "cron(0 19 1 * ? *)",<br>  "selection_tag_value": "Monthly",<br>  "start_window": 60<br>}</pre> | no |
| <a name="input_service_role_managed_policies"></a> [service\_role\_managed\_policies](#input\_service\_role\_managed\_policies) | List of managed IAM Policies for the AWS Backup Service Role. | `set(string)` | <pre>[<br>  "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup",<br>  "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForRestores"<br>]</pre> | no |
| <a name="input_unscoped_backup_plan_config"></a> [unscoped\_backup\_plan\_config](#input\_unscoped\_backup\_plan\_config) | Contains the configuration of the Unscoped backup plan for untagged resources. To enable Windows VSS set `enable_vss` to `enabled` | <pre>object({<br>    enabled                  = bool<br>    name                     = string<br>    start_window             = number<br>    completion_window        = number<br>    enable_continuous_backup = bool<br>    retention_in_days        = number<br>    schedule                 = string<br>    enable_vss               = string<br>  })</pre> | <pre>{<br>  "completion_window": 180,<br>  "enable_continuous_backup": false,<br>  "enable_vss": "disabled",<br>  "enabled": true,<br>  "name": "mgms_unscoped_backup_plan",<br>  "retention_in_days": 14,<br>  "schedule": "cron(0 10 ? * * *)",<br>  "start_window": 60<br>}</pre> | no |
| <a name="input_vault_name"></a> [vault\_name](#input\_vault\_name) | The name of the AWS Backup Vault that will be created. | `string` | `"mgms_backup_vault"` | no |
| <a name="input_weekly_backup_plan_config"></a> [weekly\_backup\_plan\_config](#input\_weekly\_backup\_plan\_config) | Contains the general configuration of the Weekly AWS Backup Plan. To enable Windows VSS set `enable_vss` to `enabled` | <pre>object({<br>    enabled             = bool<br>    name                = string<br>    start_window        = number<br>    completion_window   = number<br>    retention_in_days   = number<br>    selection_tag_value = string<br>    schedule            = string<br>    enable_vss          = string<br>  })</pre> | <pre>{<br>  "completion_window": 480,<br>  "enable_vss": "disabled",<br>  "enabled": true,<br>  "name": "backupWeekly",<br>  "retention_in_days": 105,<br>  "schedule": "cron(0 10 ? * FRI *)",<br>  "selection_tag_value": "Weekly",<br>  "start_window": 60<br>}</pre> | no |
| <a name="input_yearly_backup_plan_config"></a> [yearly\_backup\_plan\_config](#input\_yearly\_backup\_plan\_config) | Contains the general configuration of the Daily AWS Backup Plan. To enable Windows VSS set `enable_vss` to `enabled`. | <pre>object({<br>    enabled             = bool<br>    name                = string<br>    start_window        = number<br>    completion_window   = number<br>    retention_in_days   = number<br>    selection_tag_value = string<br>    schedule            = string<br>    enable_vss          = string<br>  })</pre> | <pre>{<br>  "completion_window": 480,<br>  "enable_vss": "disabled",<br>  "enabled": true,<br>  "name": "backupYearly",<br>  "retention_in_days": 765,<br>  "schedule": "cron(0 19 1 1 ? *)",<br>  "selection_tag_value": "Yearly",<br>  "start_window": 60<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_role_arn"></a> [iam\_role\_arn](#output\_iam\_role\_arn) | n/a |
| <a name="output_vault_arn"></a> [vault\_arn](#output\_vault\_arn) | n/a |
| <a name="output_vault_kms_key_alias_arn"></a> [vault\_kms\_key\_alias\_arn](#output\_vault\_kms\_key\_alias\_arn) | n/a |
| <a name="output_vault_kms_key_alias_id"></a> [vault\_kms\_key\_alias\_id](#output\_vault\_kms\_key\_alias\_id) | n/a |
| <a name="output_vault_kms_key_alias_name"></a> [vault\_kms\_key\_alias\_name](#output\_vault\_kms\_key\_alias\_name) | n/a |
| <a name="output_vault_kms_key_arn"></a> [vault\_kms\_key\_arn](#output\_vault\_kms\_key\_arn) | n/a |
| <a name="output_vault_kms_key_id"></a> [vault\_kms\_key\_id](#output\_vault\_kms\_key\_id) | n/a |
<!-- END_TF_DOCS -->
