// There is no requirement to provide any additional arguments to this module. It will deploy a working solution out of the box.
// Examples of how to modify the default behaviour of the module are demonstrated here, but this should only be done when needed.
module "backup" {
  source = "gitlab.ms.mantelgroup.com.au/managedservices/aws-backup/aws"

  // To create an additional, arbitrary backup plan follow this format
  additional_backup_plan_config = {
    example = {
        name = "example_plan",
        start_window = 1,
        completion_window = 3,
        enable_continuous_backup = false,
        retention_in_days = 10,
        selection_tag_value = "backup",
        selection_tag_value = "example_plan",
        schedule = "cron(0 * ? * * *)",
        enable_vss = "enabled"  // Must be set to "enabled", if VSS is not desired do not specify it.
                                //This is due to the behaviour of the Backup APIs and there isn't any realistic way to accept this as a boolean.
    }
  }

  // To set arbitrary, additional tags on the resources deployed by this module use this format.
  // Note this does not change resource selection rules, do this to comply with tagging policies a customer may have.
  additional_tags = {
    Name = "value",
    SecondName = "secondValue"
  }

  // To change the configuration fields of one of the pre-built backup plans do so like this.
  daily_backup_plan_config = {
    completion_window = 180
    enable_vss = "enabled"
    enabled = "true"
    name = "modifiedBackupDaily" // Call this whatever makes sense to both yourself and the customer.
    retention_in_days = 355
    schedule = "cron(0 10 ? * * *)"
    selection_tag_value = "modifiedDaily"
    start_window = 60
  }
}
