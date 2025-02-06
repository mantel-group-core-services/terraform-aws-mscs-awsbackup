output "iam_role_arn" {
  value = aws_iam_role.main.arn
}

output "vault_kms_key_id" {
  value = aws_kms_key.main.id
}

output "vault_kms_key_arn" {
  value = aws_kms_key.main.arn
}

output "vault_kms_key_alias_name" {
  value = aws_kms_alias.main.name
}

output "vault_kms_key_alias_arn" {
  value = aws_kms_alias.main.arn
}

output "vault_kms_key_alias_id" {
  value = aws_kms_alias.main.id
}

output "vault_arn" {
  value = aws_backup_vault.main.arn
}
