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
    completion_window   = optional(number, 180)
    enabled             = optional(bool, true)
    name                = optional(string, "backupContinuous")
    retention_in_days   = optional(number, 3)
    schedule            = optional(string, "cron(0 * ? * * *)")
    selection_tag_key   = optional(string, "backup")
    selection_tag_value = optional(string, "Continuous")
    start_window        = optional(number, 60)
  })
  default = {}
}

variable "hourly_backup_plan_config" {
  description = "Contains the general configuration of the Hourly AWS Backup Plan."
  type = object({
    cold_storage_after  = optional(number)
    completion_window   = optional(number, 180)
    enabled             = optional(bool, true)
    enable_vss          = optional(bool, false)
    name                = optional(string, "backupHourly")
    retention_in_days   = optional(number, 14)
    schedule            = optional(string, "cron(0 * ? * * *)")
    selection_tag_key   = optional(string, "backup")
    selection_tag_value = optional(string, "Daily")
    start_window        = optional(number, 60)
    additional_selection_tags = optional(list(object({
      key   = string
      value = string
      type  = string
    })))
  })
  default = {}
  validation {
    condition     = !var.hourly_backup_plan_config.enabled ? true : (var.hourly_backup_plan_config.cold_storage_after == null ? true : var.hourly_backup_plan_config.cold_storage_after >= 90)
    error_message = "cold_storage_after must be at least 90 days when specified."
  }
  validation {
    condition     = !var.hourly_backup_plan_config.enabled ? true : (var.hourly_backup_plan_config.cold_storage_after == null ? true : var.hourly_backup_plan_config.retention_in_days >= (var.hourly_backup_plan_config.cold_storage_after + 90))
    error_message = "retention_in_days must be at least 90 days after cold_storage_after (cold_storage_after + 90)."
  }
}

variable "daily_backup_plan_config" {
  description = "Contains the general configuration of the Daily AWS Backup Plan."
  type = object({
    cold_storage_after  = optional(number)
    completion_window   = optional(number, 180)
    enabled             = optional(bool, true)
    enable_vss          = optional(bool, false)
    name                = optional(string, "backupDaily")
    retention_in_days   = optional(number, 35)
    schedule            = optional(string, "cron(0 10 ? * * *)")
    selection_tag_key   = optional(string, "backup")
    selection_tag_value = optional(string, "Daily")
    start_window        = optional(number, 60)
    additional_selection_tags = optional(list(object({
      key   = string
      value = string
      type  = string
    })))
  })
  default = {}
  validation {
    condition     = !var.daily_backup_plan_config.enabled ? true : (var.daily_backup_plan_config.cold_storage_after == null ? true : var.daily_backup_plan_config.cold_storage_after >= 90)
    error_message = "cold_storage_after must be at least 90 days when specified."
  }
  validation {
    condition     = !var.daily_backup_plan_config.enabled ? true : (var.daily_backup_plan_config.cold_storage_after == null ? true : var.daily_backup_plan_config.retention_in_days >= (var.daily_backup_plan_config.cold_storage_after + 90))
    error_message = "retention_in_days must be at least 90 days after cold_storage_after (cold_storage_after + 90)."
  }
}

variable "weekly_backup_plan_config" {
  description = "Contains the general configuration of the Weekly AWS Backup Plan."
  type = object({
    cold_storage_after  = optional(number)
    completion_window   = optional(number, 480)
    enabled             = optional(bool, true)
    enable_vss          = optional(bool, false)
    name                = optional(string, "backupWeekly")
    retention_in_days   = optional(number, 105)
    schedule            = optional(string, "cron(0 10 ? * FRI *)")
    selection_tag_key   = optional(string, "backup")
    selection_tag_value = optional(string, "Weekly")
    start_window        = optional(number, 60)
    additional_selection_tags = optional(list(object({
      key   = string
      value = string
      type  = string
    })))
  })
  default = {}
  validation {
    condition     = !var.weekly_backup_plan_config.enabled ? true : (var.weekly_backup_plan_config.cold_storage_after == null ? true : var.weekly_backup_plan_config.cold_storage_after >= 90)
    error_message = "cold_storage_after must be at least 90 days when specified."
  }
  validation {
    condition     = !var.weekly_backup_plan_config.enabled ? true : (var.weekly_backup_plan_config.cold_storage_after == null ? true : var.weekly_backup_plan_config.retention_in_days >= (var.weekly_backup_plan_config.cold_storage_after + 90))
    error_message = "retention_in_days must be at least 90 days after cold_storage_after (cold_storage_after + 90)."
  }
}

variable "monthly_backup_plan_config" {
  description = "Contains the general configuration of the Monthly AWS Backup Plan."
  type = object({
    cold_storage_after  = optional(number)
    completion_window   = optional(number, 480)
    enabled             = optional(bool, true)
    enable_vss          = optional(bool, false)
    name                = optional(string, "backupMonthly")
    retention_in_days   = optional(number, 455)
    schedule            = optional(string, "cron(0 19 1 * ? *)")
    selection_tag_key   = optional(string, "backup")
    selection_tag_value = optional(string, "Monthly")
    start_window        = optional(number, 60)
    additional_selection_tags = optional(list(object({
      key   = string
      value = string
      type  = string
    })))
  })
  default = {}
  validation {
    condition     = !var.monthly_backup_plan_config.enabled ? true : (var.monthly_backup_plan_config.cold_storage_after == null ? true : var.monthly_backup_plan_config.cold_storage_after >= 90)
    error_message = "cold_storage_after must be at least 90 days when specified."
  }
  validation {
    condition     = !var.monthly_backup_plan_config.enabled ? true : (var.monthly_backup_plan_config.cold_storage_after == null ? true : var.monthly_backup_plan_config.retention_in_days >= (var.monthly_backup_plan_config.cold_storage_after + 90))
    error_message = "retention_in_days must be at least 90 days after cold_storage_after (cold_storage_after + 90)."
  }
}

variable "yearly_backup_plan_config" {
  description = "Contains the general configuration of the Yearly AWS Backup Plan."
  type = object({
    cold_storage_after  = optional(number)
    completion_window   = optional(number, 480)
    enabled             = optional(bool, true)
    enable_vss          = optional(bool, false)
    name                = optional(string, "backupYearly")
    retention_in_days   = optional(number, 765)
    schedule            = optional(string, "cron(0 19 1 1 ? *)")
    selection_tag_key   = optional(string, "backup")
    selection_tag_value = optional(string, "Yearly")
    start_window        = optional(number, 60)
    additional_selection_tags = optional(list(object({
      key   = string
      value = string
      type  = string
    })))
  })
  default = {}
  validation {
    condition     = !var.yearly_backup_plan_config.enabled ? true : (var.yearly_backup_plan_config.cold_storage_after == null ? true : var.yearly_backup_plan_config.cold_storage_after >= 90)
    error_message = "cold_storage_after must be at least 90 days when specified."
  }
  validation {
    condition     = !var.yearly_backup_plan_config.enabled ? true : (var.yearly_backup_plan_config.cold_storage_after == null ? true : var.yearly_backup_plan_config.retention_in_days >= (var.yearly_backup_plan_config.cold_storage_after + 90))
    error_message = "retention_in_days must be at least 90 days after cold_storage_after (cold_storage_after + 90)."
  }
}

variable "additional_backup_plan_config" {
  description = "Contains the general configuration of an AWS Backup Plan. This can be used to set any number of arbitrary additional Backup Plans."
  type = map(object({
    cold_storage_after       = optional(number)
    completion_window        = number
    enable_continuous_backup = bool
    enable_vss               = bool
    name                     = string
    retention_in_days        = number
    schedule                 = string
    selection_tag_key        = string
    selection_tag_value      = string
    start_window             = number
    additional_selection_tags = optional(list(object({
      key   = string
      value = string
      type  = string
    })))
  }))
  default = {}
  validation {
    condition = alltrue([
      for k, v in var.additional_backup_plan_config :
      v.cold_storage_after == null ? true : v.cold_storage_after >= 90
    ])
    error_message = "cold_storage_after must be at least 90 days when specified."
  }
  validation {
    condition = alltrue([
      for k, v in var.additional_backup_plan_config :
      v.cold_storage_after == null ? true : v.retention_in_days >= (v.cold_storage_after + 90)
    ])
    error_message = "retention_in_days must be at least 90 days after cold_storage_after (cold_storage_after + 90)."
  }
}

variable "unscoped_backup_plan_config" {
  description = "Contains the configuration of the Unscoped backup plan for untagged resources."
  type = object({
    completion_window        = optional(number, 180)
    enabled                  = optional(bool, true)
    enable_continuous_backup = optional(bool, false)
    enable_vss               = optional(bool, false)
    name                     = optional(string, "mgms_unscoped_backup_plan")
    retention_in_days        = optional(number, 14)
    schedule                 = optional(string, "cron(0 10 ? * * *)")
    selection_tag_key        = optional(string, "backup")
    start_window             = optional(number, 60)
  })
  default = {}
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
