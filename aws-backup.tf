resource "aws_backup_vault" "main" {
  name        = "${var.vault_name}_${random_id.main.id}"
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
      "backup:PutBackupVaultAccessPolicy",
      "backup:UpdateRecoveryPointLifecycle"
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

  name = "${var.continuous_backup_plan_config.name}_${random_id.main.id}"
  rule {
    rule_name         = "${var.continuous_backup_plan_config.name}_${random_id.main.id}"
    target_vault_name = aws_backup_vault.main.name
    schedule          = var.continuous_backup_plan_config.schedule
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
  name         = "${var.continuous_backup_plan_config.name}_${random_id.main.id}_selection"
  plan_id      = aws_backup_plan.continuous[0].id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "backup"
    value = var.continuous_backup_plan_config.selection_tag_value
  }
}

resource "aws_backup_plan" "daily" {
  count = var.daily_backup_plan_config.enabled ? 1 : 0

  name = "${var.daily_backup_plan_config.name}_${random_id.main.id}"
  rule {
    rule_name         = "${var.daily_backup_plan_config.name}_${random_id.main.id}"
    target_vault_name = aws_backup_vault.main.name
    schedule          = var.daily_backup_plan_config.schedule
    lifecycle {
      delete_after = var.daily_backup_plan_config.retention_in_days
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
  name         = "${var.daily_backup_plan_config.name}_${random_id.main.id}_selection"
  plan_id      = aws_backup_plan.daily[0].id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "backup"
    value = var.daily_backup_plan_config.selection_tag_value
  }
}

resource "aws_backup_plan" "hourly" {
  count = var.hourly_backup_plan_config.enabled ? 1 : 0

  name = "${var.hourly_backup_plan_config.name}_${random_id.main.id}"
  rule {
    rule_name         = "${var.hourly_backup_plan_config.name}_${random_id.main.id}"
    target_vault_name = aws_backup_vault.main.name
    schedule          = var.hourly_backup_plan_config.schedule
    lifecycle {
      delete_after = var.hourly_backup_plan_config.retention_in_days
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
  name         = "${var.hourly_backup_plan_config.name}_${random_id.main.id}_selection"
  plan_id      = aws_backup_plan.hourly[0].id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "backup"
    value = var.hourly_backup_plan_config.selection_tag_value
  }
}

resource "aws_backup_plan" "weekly" {
  count = var.weekly_backup_plan_config.enabled ? 1 : 0

  name = "${var.weekly_backup_plan_config.name}_${random_id.main.id}"
  rule {
    rule_name         = "${var.weekly_backup_plan_config.name}_${random_id.main.id}"
    target_vault_name = aws_backup_vault.main.name
    schedule          = var.weekly_backup_plan_config.schedule
    lifecycle {
      delete_after = var.weekly_backup_plan_config.retention_in_days
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
  name         = "${var.weekly_backup_plan_config.name}_${random_id.main.id}_selection"
  plan_id      = aws_backup_plan.weekly[0].id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "backup"
    value = var.weekly_backup_plan_config.selection_tag_value
  }
}

resource "aws_backup_plan" "monthly" {
  count = var.monthly_backup_plan_config.enabled ? 1 : 0

  name = "${var.monthly_backup_plan_config.name}_${random_id.main.id}"
  rule {
    rule_name         = "${var.monthly_backup_plan_config.name}_${random_id.main.id}"
    target_vault_name = aws_backup_vault.main.name
    schedule          = var.monthly_backup_plan_config.schedule
    lifecycle {
      delete_after = var.monthly_backup_plan_config.retention_in_days
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
  name         = "${var.monthly_backup_plan_config.name}_${random_id.main.id}_selection"
  plan_id      = aws_backup_plan.monthly[0].id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "backup"
    value = var.monthly_backup_plan_config.selection_tag_value
  }
}

resource "aws_backup_plan" "yearly" {
  count = var.yearly_backup_plan_config.enabled ? 1 : 0

  name = "${var.yearly_backup_plan_config.name}_${random_id.main.id}"
  rule {
    rule_name         = "${var.yearly_backup_plan_config.name}_${random_id.main.id}"
    target_vault_name = aws_backup_vault.main.name
    schedule          = var.yearly_backup_plan_config.schedule
    lifecycle {
      delete_after = var.yearly_backup_plan_config.retention_in_days
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
  name         = "${var.yearly_backup_plan_config.name}_${random_id.main.id}_selection"
  plan_id      = aws_backup_plan.yearly[0].id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "backup"
    value = var.yearly_backup_plan_config.selection_tag_value
  }
}

resource "aws_backup_plan" "unscoped" {
  count = var.unscoped_backup_plan_config.enabled ? 1 : 0

  name = "${var.unscoped_backup_plan_config.name}_${random_id.main.id}"
  rule {
    rule_name         = "${var.unscoped_backup_plan_config.name}_${random_id.main.id}"
    target_vault_name = aws_backup_vault.main.name
    schedule          = var.unscoped_backup_plan_config.schedule
    lifecycle {
      delete_after = var.unscoped_backup_plan_config.retention_in_days
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
  name         = "${var.unscoped_backup_plan_config.name}_${random_id.main.id}_selection"
  plan_id      = aws_backup_plan.unscoped[0].id

  resources = ["*"]

  condition {
    string_not_like {
      key   = "aws:ResourceTag/backup"
      value = "*"
    }
  }
}

resource "aws_backup_plan" "additional_plans" {
  for_each = var.additional_backup_plan_config

  name = "${each.value.name}_${random_id.main.id}"
  rule {
    rule_name         = "${each.value.name}_${random_id.main.id}"
    target_vault_name = aws_backup_vault.main.name
    schedule          = each.value.schedule
    lifecycle {
      delete_after = each.value.retention_in_days
    }
  }
  advanced_backup_setting {
    backup_options = {
      WindowsVSS = each.value.enable_vss
    }
    resource_type = "EC2"
  }

  tags = merge(
    var.additional_tags,
    local.enforced_tags
  )
}

resource "aws_backup_selection" "additional" {
  for_each = var.additional_backup_plan_config

  iam_role_arn = aws_iam_role.main.arn
  name         = "${each.value.name}_${random_id.main.id}_selection"
  plan_id      = aws_backup_plan.additional_plans[each.key].id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "backup"
    value = each.value.selection_tag_value
  }
}
