resource "aws_backup_vault" "main" {
  name        = var.vault_name
  kms_key_arn = aws_kms_key.main.arn

  lifecycle {
    prevent_destroy = true
  }

  tags = merge(
    var.additional_tags,
    local.enforced_tags
  )
}

data "aws_iam_policy_document" "vault_access_policy" {
  statement {
    sid    = "PreventManualDeletion"
    effect = "Deny"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "backup:DeleteRecoveryPoint",
      "backup:UpdateRecoveryPointLifecycle",
    ]
    resources = ["*"]
  }
}

resource "aws_backup_vault_policy" "main" {
  backup_vault_name = aws_backup_vault.main.name
  policy            = data.aws_iam_policy_document.vault_access_policy.json
}

resource "aws_backup_plan" "continuous" {
  count = var.continuous_backup_plan_config.enabled ? 1 : 0

  name = "${local.name_prefix}${var.continuous_backup_plan_config.name}"
  rule {
    completion_window = var.continuous_backup_plan_config.completion_window
    rule_name         = "${local.name_prefix}${var.continuous_backup_plan_config.name}"
    schedule          = var.continuous_backup_plan_config.schedule
    start_window      = var.continuous_backup_plan_config.start_window
    target_vault_name = aws_backup_vault.main.name
    lifecycle {
      delete_after = var.continuous_backup_plan_config.retention_in_days
    }
  }

  tags = merge(
    var.additional_tags,
    local.enforced_tags
  )
}

resource "aws_backup_selection" "continuous" {
  count = var.continuous_backup_plan_config.enabled ? 1 : 0

  iam_role_arn = aws_iam_role.main.arn
  name         = "${local.name_prefix}${var.continuous_backup_plan_config.name}_selection"
  plan_id      = aws_backup_plan.continuous[0].id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = var.continuous_backup_plan_config.selection_tag_key
    value = var.continuous_backup_plan_config.selection_tag_value
  }
}

resource "aws_backup_plan" "daily" {
  count = var.daily_backup_plan_config.enabled ? 1 : 0

  name = "${local.name_prefix}${var.daily_backup_plan_config.name}"
  rule {
    completion_window = var.daily_backup_plan_config.completion_window
    rule_name         = "${local.name_prefix}${var.daily_backup_plan_config.name}"
    schedule          = var.daily_backup_plan_config.schedule
    start_window      = var.daily_backup_plan_config.start_window
    target_vault_name = aws_backup_vault.main.name
    lifecycle {
      cold_storage_after = var.daily_backup_plan_config.cold_storage_after
      delete_after       = var.daily_backup_plan_config.retention_in_days
    }
  }
  dynamic "advanced_backup_setting" {
    for_each = var.daily_backup_plan_config.enable_vss ? [1] : []
    content {
      backup_options = {
        WindowsVSS = "enabled"
      }
      resource_type = "EC2"
    }
  }

  tags = merge(
    var.additional_tags,
    local.enforced_tags
  )
}

resource "aws_backup_selection" "daily" {
  count = var.daily_backup_plan_config.enabled ? 1 : 0

  iam_role_arn = aws_iam_role.main.arn
  name         = "${local.name_prefix}${var.daily_backup_plan_config.name}_selection"
  plan_id      = aws_backup_plan.daily[0].id

  resources = ["*"]

  condition {
    string_equals {
      key   = "aws:ResourceTag/${var.daily_backup_plan_config.selection_tag_key}"
      value = var.daily_backup_plan_config.selection_tag_value
    }

    dynamic "string_equals" {
      for_each = coalesce(var.daily_backup_plan_config.additional_selection_tags, [])
      content {
        key   = "aws:ResourceTag/${string_equals.value.key}"
        value = string_equals.value.value
      }
    }
  }
}

resource "aws_backup_plan" "hourly" {
  count = var.hourly_backup_plan_config.enabled ? 1 : 0

  name = "${local.name_prefix}${var.hourly_backup_plan_config.name}"
  rule {
    completion_window = var.hourly_backup_plan_config.completion_window
    rule_name         = "${local.name_prefix}${var.hourly_backup_plan_config.name}"
    schedule          = var.hourly_backup_plan_config.schedule
    start_window      = var.hourly_backup_plan_config.start_window
    target_vault_name = aws_backup_vault.main.name
    lifecycle {
      cold_storage_after = var.hourly_backup_plan_config.cold_storage_after
      delete_after       = var.hourly_backup_plan_config.retention_in_days
    }
  }
  dynamic "advanced_backup_setting" {
    for_each = var.hourly_backup_plan_config.enable_vss ? [1] : []
    content {
      backup_options = {
        WindowsVSS = "enabled"
      }
      resource_type = "EC2"
    }
  }

  tags = merge(
    var.additional_tags,
    local.enforced_tags
  )
}

resource "aws_backup_selection" "hourly" {
  count = var.hourly_backup_plan_config.enabled ? 1 : 0

  iam_role_arn = aws_iam_role.main.arn
  name         = "${local.name_prefix}${var.hourly_backup_plan_config.name}_selection"
  plan_id      = aws_backup_plan.hourly[0].id

  resources = ["*"]

  condition {
    string_equals {
      key   = "aws:ResourceTag/${var.hourly_backup_plan_config.selection_tag_key}"
      value = var.hourly_backup_plan_config.selection_tag_value
    }

    dynamic "string_equals" {
      for_each = coalesce(var.hourly_backup_plan_config.additional_selection_tags, [])
      content {
        key   = "aws:ResourceTag/${string_equals.value.key}"
        value = string_equals.value.value
      }
    }
  }
}

resource "aws_backup_plan" "weekly" {
  count = var.weekly_backup_plan_config.enabled ? 1 : 0

  name = "${local.name_prefix}${var.weekly_backup_plan_config.name}"
  rule {
    completion_window = var.weekly_backup_plan_config.completion_window
    rule_name         = "${local.name_prefix}${var.weekly_backup_plan_config.name}"
    schedule          = var.weekly_backup_plan_config.schedule
    start_window      = var.weekly_backup_plan_config.start_window
    target_vault_name = aws_backup_vault.main.name
    lifecycle {
      cold_storage_after = var.weekly_backup_plan_config.cold_storage_after
      delete_after       = var.weekly_backup_plan_config.retention_in_days
    }
  }
  dynamic "advanced_backup_setting" {
    for_each = var.weekly_backup_plan_config.enable_vss ? [1] : []
    content {
      backup_options = {
        WindowsVSS = "enabled"
      }
      resource_type = "EC2"
    }
  }

  tags = merge(
    var.additional_tags,
    local.enforced_tags
  )
}

resource "aws_backup_selection" "weekly" {
  count = var.weekly_backup_plan_config.enabled ? 1 : 0

  iam_role_arn = aws_iam_role.main.arn
  name         = "${local.name_prefix}${var.weekly_backup_plan_config.name}_selection"
  plan_id      = aws_backup_plan.weekly[0].id

  resources = ["*"]

  condition {
    string_equals {
      key   = "aws:ResourceTag/${var.weekly_backup_plan_config.selection_tag_key}"
      value = var.weekly_backup_plan_config.selection_tag_value
    }

    dynamic "string_equals" {
      for_each = coalesce(var.weekly_backup_plan_config.additional_selection_tags, [])
      content {
        key   = "aws:ResourceTag/${string_equals.value.key}"
        value = string_equals.value.value
      }
    }
  }
}

resource "aws_backup_plan" "monthly" {
  count = var.monthly_backup_plan_config.enabled ? 1 : 0

  name = "${local.name_prefix}${var.monthly_backup_plan_config.name}"
  rule {
    completion_window = var.monthly_backup_plan_config.completion_window
    rule_name         = "${local.name_prefix}${var.monthly_backup_plan_config.name}"
    schedule          = var.monthly_backup_plan_config.schedule
    start_window      = var.monthly_backup_plan_config.start_window
    target_vault_name = aws_backup_vault.main.name
    lifecycle {
      cold_storage_after = var.monthly_backup_plan_config.cold_storage_after
      delete_after       = var.monthly_backup_plan_config.retention_in_days
    }
  }
  dynamic "advanced_backup_setting" {
    for_each = var.monthly_backup_plan_config.enable_vss ? [1] : []
    content {
      backup_options = {
        WindowsVSS = "enabled"
      }
      resource_type = "EC2"
    }
  }

  tags = merge(
    var.additional_tags,
    local.enforced_tags
  )
}

resource "aws_backup_selection" "monthly" {
  count = var.monthly_backup_plan_config.enabled ? 1 : 0

  iam_role_arn = aws_iam_role.main.arn
  name         = "${local.name_prefix}${var.monthly_backup_plan_config.name}_selection"
  plan_id      = aws_backup_plan.monthly[0].id

  resources = ["*"]

  condition {
    string_equals {
      key   = "aws:ResourceTag/${var.monthly_backup_plan_config.selection_tag_key}"
      value = var.monthly_backup_plan_config.selection_tag_value
    }

    dynamic "string_equals" {
      for_each = coalesce(var.monthly_backup_plan_config.additional_selection_tags, [])
      content {
        key   = "aws:ResourceTag/${string_equals.value.key}"
        value = string_equals.value.value
      }
    }
  }
}

resource "aws_backup_plan" "yearly" {
  count = var.yearly_backup_plan_config.enabled ? 1 : 0

  name = "${local.name_prefix}${var.yearly_backup_plan_config.name}"
  rule {
    completion_window = var.yearly_backup_plan_config.completion_window
    rule_name         = "${local.name_prefix}${var.yearly_backup_plan_config.name}"
    schedule          = var.yearly_backup_plan_config.schedule
    start_window      = var.yearly_backup_plan_config.start_window
    target_vault_name = aws_backup_vault.main.name
    lifecycle {
      cold_storage_after = var.yearly_backup_plan_config.cold_storage_after
      delete_after       = var.yearly_backup_plan_config.retention_in_days
    }
  }
  dynamic "advanced_backup_setting" {
    for_each = var.yearly_backup_plan_config.enable_vss ? [1] : []
    content {
      backup_options = {
        WindowsVSS = "enabled"
      }
      resource_type = "EC2"
    }
  }

  tags = merge(
    var.additional_tags,
    local.enforced_tags
  )
}

resource "aws_backup_selection" "yearly" {
  count = var.yearly_backup_plan_config.enabled ? 1 : 0

  iam_role_arn = aws_iam_role.main.arn
  name         = "${local.name_prefix}${var.yearly_backup_plan_config.name}_selection"
  plan_id      = aws_backup_plan.yearly[0].id

  resources = ["*"]

  condition {
    string_equals {
      key   = "aws:ResourceTag/${var.yearly_backup_plan_config.selection_tag_key}"
      value = var.yearly_backup_plan_config.selection_tag_value
    }

    dynamic "string_equals" {
      for_each = coalesce(var.yearly_backup_plan_config.additional_selection_tags, [])
      content {
        key   = "aws:ResourceTag/${string_equals.value.key}"
        value = string_equals.value.value
      }
    }
  }
}

resource "aws_backup_plan" "unscoped" {
  count = var.unscoped_backup_plan_config.enabled ? 1 : 0

  name = "${local.name_prefix}${var.unscoped_backup_plan_config.name}"
  rule {
    completion_window = var.unscoped_backup_plan_config.completion_window
    rule_name         = "${local.name_prefix}${var.unscoped_backup_plan_config.name}"
    schedule          = var.unscoped_backup_plan_config.schedule
    start_window      = var.unscoped_backup_plan_config.start_window
    target_vault_name = aws_backup_vault.main.name
    lifecycle {
      delete_after = var.unscoped_backup_plan_config.retention_in_days
    }
  }
  dynamic "advanced_backup_setting" {
    for_each = var.unscoped_backup_plan_config.enable_vss ? [1] : []
    content {
      backup_options = {
        WindowsVSS = "enabled"
      }
      resource_type = "EC2"
    }
  }

  tags = merge(
    var.additional_tags,
    local.enforced_tags
  )
}

resource "aws_backup_selection" "unscoped" {
  count = var.unscoped_backup_plan_config.enabled ? 1 : 0

  iam_role_arn = aws_iam_role.main.arn
  name         = "${local.name_prefix}${var.unscoped_backup_plan_config.name}_selection"
  plan_id      = aws_backup_plan.unscoped[0].id

  resources = [
    "arn:aws:dynamodb:*:*:table/*",
    "arn:aws:rds:*:*:db:*",
    "arn:aws:rds:*:*:cluster:*",
  ]

  condition {
    string_not_like {
      key   = "aws:ResourceTag/${var.unscoped_backup_plan_config.selection_tag_key}"
      value = "*"
    }
  }
}

resource "aws_backup_plan" "additional_plans" {
  for_each = var.additional_backup_plan_config

  name = "${local.name_prefix}${each.value.name}"
  rule {
    completion_window = each.value.completion_window
    rule_name         = "${local.name_prefix}${each.value.name}"
    schedule          = each.value.schedule
    start_window      = each.value.start_window
    target_vault_name = aws_backup_vault.main.name
    lifecycle {
      cold_storage_after = each.value.cold_storage_after
      delete_after       = each.value.retention_in_days
    }
  }
  dynamic "advanced_backup_setting" {
    for_each = each.value.enable_vss ? [1] : []
    content {
      backup_options = {
        WindowsVSS = "enabled"
      }
      resource_type = "EC2"
    }
  }

  tags = merge(
    var.additional_tags,
    local.enforced_tags
  )
}

resource "aws_backup_selection" "additional" {
  for_each = var.additional_backup_plan_config

  iam_role_arn = aws_iam_role.main.arn
  name         = "${local.name_prefix}${each.value.name}_selection"
  plan_id      = aws_backup_plan.additional_plans[each.key].id

  resources = ["*"]

  condition {
    string_equals {
      key   = "aws:ResourceTag/${each.value.selection_tag_key}"
      value = each.value.selection_tag_value
    }

    dynamic "string_equals" {
      for_each = coalesce(each.value.additional_selection_tags, [])
      content {
        key   = "aws:ResourceTag/${string_equals.value.key}"
        value = string_equals.value.value
      }
    }
  }
}
