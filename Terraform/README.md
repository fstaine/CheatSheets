# Terraform / Terragrunt

### Move a folder

```bash
terragrunt state pull > ~/copy.tfstate

# Move folder
terragrunt init
terragrunt state push ~/copy.tfstate

# Verify no changes
terragrunt plan
```

_Source: https://www.maxivanov.io/how-to-move-resources-and-modules-in-terragrunt/_
