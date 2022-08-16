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

