variable "vault_name" {
  description = "The name of the AWS Backup Vault that will be created."
  type        = string
  default     = "mgms_backup_vault"
}

variable "continuous_backup_plan_config" {
  description = "Contains the general configuration of the Continuous AWS Backup Plan."
  type = object({
    enabled             = bool
    name                = string
    start_window        = number
    completion_window   = number
    retention_in_days   = number
    selection_tag_value = string
    schedule            = string
  })
  default = {
    enabled             = true
    name                = "backupContinuous"
    start_window        = 60
    completion_window   = 180
    retention_in_days   = 3
    selection_tag_value = "Continuous"
    schedule            = "cron(0 * ? * * *)"
  }
}

variable "hourly_backup_plan_config" {
  description = "Contains the general configuration of the Hourly AWS Backup Plan. To enable Windows VSS set `enable_vss` to `enabled`"
  type = object({
    enabled             = bool
    name                = string
    start_window        = number
    completion_window   = number
    retention_in_days   = number
    selection_tag_value = string
    schedule            = string
    enable_vss          = string
  })
  default = {
    enabled             = true
    name                = "backupHourly"
    start_window        = 60
    completion_window   = 180
    retention_in_days   = 14
    selection_tag_value = "Daily"
    schedule            = "cron(0 * ? * * *)"
    enable_vss          = "disabled"
  }
}

variable "daily_backup_plan_config" {
  description = "Contains the general configuration of the Daily AWS Backup Plan. To enable Windows VSS set `enable_vss` to `enabled`"
  type = object({
    enabled             = bool
    name                = string
    start_window        = number
    completion_window   = number
    retention_in_days   = number
    selection_tag_value = string
    schedule            = string
    enable_vss          = string
  })
  default = {
    enabled             = true
    name                = "backupDaily"
    start_window        = 60
    completion_window   = 180
    retention_in_days   = 35
    selection_tag_value = "Daily"
    schedule            = "cron(0 10 ? * * *)"
    enable_vss          = "disabled"
  }
}

variable "weekly_backup_plan_config" {
  description = "Contains the general configuration of the Weekly AWS Backup Plan. To enable Windows VSS set `enable_vss` to `enabled`"
  type = object({
    enabled             = bool
    name                = string
    start_window        = number
    completion_window   = number
    retention_in_days   = number
    selection_tag_value = string
    schedule            = string
    enable_vss          = string
  })
  default = {
    enabled             = true
    name                = "backupWeekly"
    start_window        = 60
    completion_window   = 480
    retention_in_days   = 105
    selection_tag_value = "Weekly"
    schedule            = "cron(0 10 ? * FRI *)"
    enable_vss          = "disabled"
  }
}

variable "monthly_backup_plan_config" {
  description = "Contains the general configuration of the Daily AWS Backup Plan. To enable Windows VSS set `enable_vss` to `enabled`"
  type = object({
    enabled             = bool
    name                = string
    start_window        = number
    completion_window   = number
    retention_in_days   = number
    selection_tag_value = string
    schedule            = string
    enable_vss          = string
  })
  default = {
    enabled             = true
    name                = "backupMonthly"
    start_window        = 60
    completion_window   = 480
    retention_in_days   = 455
    selection_tag_value = "Monthly"
    schedule            = "cron(0 19 1 * ? *)"
    enable_vss          = "disabled"
  }
}

variable "yearly_backup_plan_config" {
  description = "Contains the general configuration of the Daily AWS Backup Plan. To enable Windows VSS set `enable_vss` to `enabled`."
  type = object({
    enabled             = bool
    name                = string
    start_window        = number
    completion_window   = number
    retention_in_days   = number
    selection_tag_value = string
    schedule            = string
    enable_vss          = string
  })
  default = {
    enabled             = true
    name                = "backupYearly"
    start_window        = 60
    completion_window   = 480
    retention_in_days   = 765
    selection_tag_value = "Yearly"
    schedule            = "cron(0 19 1 1 ? *)"
    enable_vss          = "disabled"
  }
}

variable "additional_backup_plan_config" {
  description = "Contains the general configuration of an AWS Backup Plan. To enable Windows VSS set `enable_vss` to `enabled`. This can be used to set any number of arbitrary additional Backup Plans."
  type = map(object({
    name                     = string
    start_window             = number
    completion_window        = number
    enable_continuous_backup = bool
    retention_in_days        = number
    selection_tag_value      = string
    schedule                 = string
    enable_vss               = string
  }))
  default = {}
}

variable "unscoped_backup_plan_config" {
  description = "Contains the configuration of the Unscoped backup plan for untagged resources. To enable Windows VSS set `enable_vss` to `enabled`"
  type = object({
    enabled                  = bool
    name                     = string
    start_window             = number
    completion_window        = number
    enable_continuous_backup = bool
    retention_in_days        = number
    schedule                 = string
    enable_vss               = string
  })
  default = {
    enabled                  = true
    name                     = "mgms_unscoped_backup_plan"
    start_window             = 60
    completion_window        = 180
    enable_continuous_backup = false
    retention_in_days        = 14
    schedule                 = "cron(0 10 ? * * *)"
    enable_vss               = "disabled"
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
