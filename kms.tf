resource "aws_kms_key" "main" {
  enable_key_rotation = true

  lifecycle {
    prevent_destroy = true
  }

  tags = merge(
    var.additional_tags,
    local.enforced_tags
  )
}

resource "aws_kms_alias" "main" {
  name          = "alias/mgms_backup_key_${random_id.main.id}"
  target_key_id = aws_kms_key.main.id
}


data "aws_iam_policy_document" "kms_policy" {
  statement {
    sid = "AllowUseOfKey"
    actions = [
      "kms:CancelKeyDeletion",
      "kms:Create*",
      "kms:Delete*",
      "kms:Describe*",
      "kms:Disable*",
      "kms:Enable*",
      "kms:Get*",
      "kms:List*",
      "kms:Put*",
      "kms:Revoke*",
      "kms:ScheduleKeyDeletion",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:Update*"
    ]
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    resources = ["*"]
  }
}
