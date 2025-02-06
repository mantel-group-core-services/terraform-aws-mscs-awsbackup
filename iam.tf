data "aws_caller_identity" "current" {}

resource "aws_iam_role" "main" {
  name               = "mgms_cs_backup_role"
  path               = "/mgms/"
  assume_role_policy = data.aws_iam_policy_document.service_assume_role_policy.json
  tags = merge(
    var.additional_tags,
    local.enforced_tags
  )
}


data "aws_iam_policy_document" "service_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["backup.amazonaws.com"]
    }
    effect = "Allow"
  }
}


data "aws_iam_policy_document" "service_role_policy" {
  statement {
    sid = "AllowAccessToKmsKey"
    actions = [
      "kms:CreateGrant",
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:GenerateDataKey*",
      "kms:ReEncrypt*"
    ]
    effect    = "Allow"
    resources = [aws_kms_key.main.arn]
  }
  statement {
    sid       = "AllowListingTags"
    actions   = ["tag:GetResources"]
    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_policy" "main" {
  depends_on  = [aws_kms_key.main]
  name        = "mg_cs_backup_role_policy-${random_id.main.hex}"
  path        = "/mgms/"
  description = "IAM Policy to allow the AWS Backup Service Role permissions to the Vault's KMS Key"
  policy      = data.aws_iam_policy_document.service_role_policy.json

  tags = merge(
    var.additional_tags,
    local.enforced_tags
  )
}

resource "aws_iam_role_policy_attachment" "kms_policy_attachment" {
  role       = aws_iam_role.main.name
  policy_arn = aws_iam_policy.main.arn
}

resource "aws_iam_role_policy_attachment" "managed_policy_attachments" {
  for_each   = var.service_role_managed_policies
  role       = aws_iam_role.main.name
  policy_arn = each.value
}
