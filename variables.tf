variable "vault_name" {
  description = "The name of the AWS Backup Vault that will be created."
  type        = string
  default     = "mgms_backup_vault"
}

variable "kms_key_alias" {
  description = "The alias name for the KMS key used to encrypt the backup vault."
  type        = string
  default     = "alias/mgms_backup_key"
}

variable "iam_role_name" {
  description = "The name of the IAM role used by AWS Backup."
  type        = string
  default     = "mgms_cs_backup_role"
}

variable "iam_policy_name" {
  description = "The name of the IAM policy attached to the AWS Backup service role."
  type        = string
  default     = "mg_cs_backup_role_policy"
}

variable "iam_path" {
  description = "The IAM path for the role and policy."
  type        = string
  default     = "/mgms/"
}

variable "backup_plan_name_prefix" {
  description = "Prefix to prepend to all backup plan names (e.g., 'myapp' results in 'myapp_backupDaily')."
  type        = string
  default     = ""
}

variable "continuous_backup_plan_config" {
  description = "Contains the general configuration of the Continuous AWS Backup Plan."
  type = object({
    enabled             = bool
    name                = string
    start_window        = number
    completion_window   = number
    retention_in_days   = number
    selection_tag_key   = string
    selection_tag_value = string
    schedule            = string
  })
  default = {
    enabled             = true
    name                = "backupContinuous"
    start_window        = 60
    completion_window   = 180
    retention_in_days   = 3
    selection_tag_key   = "backup"
    selection_tag_value = "Continuous"
    schedule            = "cron(0 * ? * * *)"
  }
}

variable "hourly_backup_plan_config" {
  description = "Contains the general configuration of the Hourly AWS Backup Plan."
  type = object({
    enabled             = bool
    enable_vss          = bool
    name                = string
    start_window        = number
    completion_window   = number
    retention_in_days   = number
    schedule            = string
    selection_tag_key   = string
    selection_tag_value = string
    additional_selection_tags = list(object({
      key   = string
      value = string
      type  = string
    }))
  })
  default = {
    enabled                   = true
    enable_vss                = false
    name                      = "backupHourly"
    start_window              = 60
    completion_window         = 180
    retention_in_days         = 14
    schedule                  = "cron(0 * ? * * *)"
    selection_tag_key         = "backup"
    selection_tag_value       = "Daily"
    additional_selection_tags = []
  }
}

variable "daily_backup_plan_config" {
  description = "Contains the general configuration of the Daily AWS Backup Plan."
  type = object({
    enabled             = bool
    enable_vss          = bool
    name                = string
    start_window        = number
    completion_window   = number
    retention_in_days   = number
    schedule            = string
    selection_tag_key   = string
    selection_tag_value = string
    additional_selection_tags = list(object({
      key   = string
      value = string
      type  = string
    }))


  })
  default = {
    enabled                   = true
    enable_vss                = false
    name                      = "backupDaily"
    start_window              = 60
    completion_window         = 180
    retention_in_days         = 35
    schedule                  = "cron(0 10 ? * * *)"
    selection_tag_key         = "backup"
    selection_tag_value       = "Daily"
    additional_selection_tags = []
  }
}

variable "weekly_backup_plan_config" {
  description = "Contains the general configuration of the Weekly AWS Backup Plan."
  type = object({
    enabled             = bool
    enable_vss          = bool
    name                = string
    start_window        = number
    completion_window   = number
    retention_in_days   = number
    schedule            = string
    selection_tag_key   = string
    selection_tag_value = string
    additional_selection_tags = list(object({
      key   = string
      value = string
      type  = string
    }))
  })
  default = {
    enabled                   = true
    enable_vss                = false
    name                      = "backupWeekly"
    start_window              = 60
    completion_window         = 480
    retention_in_days         = 105
    schedule                  = "cron(0 10 ? * FRI *)"
    selection_tag_key         = "backup"
    selection_tag_value       = "Weekly"
    additional_selection_tags = []
  }
}

variable "monthly_backup_plan_config" {
  description = "Contains the general configuration of the Monthly AWS Backup Plan."
  type = object({
    enabled             = bool
    enable_vss          = bool
    name                = string
    start_window        = number
    completion_window   = number
    retention_in_days   = number
    schedule            = string
    selection_tag_key   = string
    selection_tag_value = string
    additional_selection_tags = list(object({
      key   = string
      value = string
      type  = string
    }))
  })
  default = {
    enabled                   = true
    enable_vss                = false
    name                      = "backupMonthly"
    start_window              = 60
    completion_window         = 480
    retention_in_days         = 455
    schedule                  = "cron(0 19 1 * ? *)"
    selection_tag_key         = "backup"
    selection_tag_value       = "Monthly"
    additional_selection_tags = []
  }
}

variable "yearly_backup_plan_config" {
  description = "Contains the general configuration of the Yearly AWS Backup Plan."
  type = object({
    enabled             = bool
    enable_vss          = bool
    name                = string
    start_window        = number
    completion_window   = number
    retention_in_days   = number
    schedule            = string
    selection_tag_key   = string
    selection_tag_value = string
    additional_selection_tags = list(object({
      key   = string
      value = string
      type  = string
    }))
  })
  default = {
    enabled                   = true
    enable_vss                = false
    name                      = "backupYearly"
    start_window              = 60
    completion_window         = 480
    retention_in_days         = 765
    schedule                  = "cron(0 19 1 1 ? *)"
    selection_tag_key         = "backup"
    selection_tag_value       = "Yearly"
    additional_selection_tags = []
  }
}

variable "additional_backup_plan_config" {
  description = "Contains the general configuration of an AWS Backup Plan. This can be used to set any number of arbitrary additional Backup Plans."
  type = map(object({
    name                     = string
    start_window             = number
    completion_window        = number
    enable_continuous_backup = bool
    retention_in_days        = number
    selection_tag_key        = string
    selection_tag_value      = string
    schedule                 = string
    enable_vss               = bool
  }))
  default = {}
}

variable "unscoped_backup_plan_config" {
  description = "Contains the configuration of the Unscoped backup plan for untagged resources."
  type = object({
    enabled                  = bool
    name                     = string
    start_window             = number
    completion_window        = number
    enable_continuous_backup = bool
    retention_in_days        = number
    selection_tag_key        = string
    schedule                 = string
    enable_vss               = bool
  })
  default = {
    enabled                  = true
    name                     = "mgms_unscoped_backup_plan"
    start_window             = 60
    completion_window        = 180
    enable_continuous_backup = false
    retention_in_days        = 14
    selection_tag_key        = "backup"
    schedule                 = "cron(0 10 ? * * *)"
    enable_vss               = false
  }
}

variable "service_role_managed_policies" {
  description = "List of managed IAM Policies for the AWS Backup Service Role."
  type        = set(string)
  default = [
    "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup",
    "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForRestores"
  ]
}

variable "additional_tags" {
  type        = map(string)
  description = "Map of strings for providing arbitrary additional tags in addition to the ones enforced in the terraform.tf file and the Terraform provider."
  default     = {}
}
