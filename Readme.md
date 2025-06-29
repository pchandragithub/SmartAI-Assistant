## Azure AI Foundry RBAC Implementation Guide
# Table of Contents
1.	Overview
2.	Architecture
3.	Prerequisites
4.	Implementation Steps
5.	CSV File Format
6.	Custom Roles
7.	Deployment
8.	Validation
9.	Maintenance
10.	Troubleshooting

# Overview
This Terraform implementation provides a complete Role-Based Access Control (RBAC) solution for Azure AI Foundry using CSV files for principal management. The solution combines built-in Azure roles with custom roles specifically designed for AI Foundry operations.

# Architecture
![Azure RBAC Flow](https://rbac_structure.png)

# The solution consists of:
•	Principal Management: CSV-based user/group/SP configuration
•	Role Definitions: Both built-in and custom roles
•	Role Assignments: Automatic mapping of principals to roles
•	Resource Coverage: AI Foundry Hub, Storage, Key Vault
# Prerequisites
1.	Azure Access:
o	Contributor role on the target subscription
o	Azure AD read permissions
2.	Tools:
o	Terraform v1.3+
o	Azure CLI
o	Git (for version control)
3.	Permissions:
```
az login
az account set --subscription <your-subscription-id>
```
## Implementation Steps

# 1. Clone the Repository
```
git clone https://github.com/your-org/ai-foundry-rbac.git
cd ai-foundry-rbac
```
## 2. Prepare Environment
1.	Create principals.csv (see format below)
2.	Update dev.tfvars with your resource IDs
3.	Initialize Terraform:
```
terraform init
```
## 3. CSV File Format
## Create/edit principals.csv following this structure:

role,principal_type,principal_name
admin,user,ai-admin@company.com
admin,group,ai-foundry-admins@company.com
data_scientist,user,ds1@company.com
ai_engineer,user,ai-engineer1@company.com
ml_ops,sp,ai-foundry-mlops-sp

# Columns:
•	role: Role category (admin, data_scientist, ai_engineer, ml_ops, viewer)
•	principal_type: "user", "group", or "sp" (service principal)
•	principal_name: Email for users, name for groups/SPs

## 4. Custom Roles
The implementation creates these custom roles:

| Role Name        | Description                              | Key Permissions                                           |
|------------------|------------------------------------------|---------------------------------------------------------  |
| AI Data Scientist| For data exploration and experimentation | Read access to datasets, experiments; limited compute     |
| AI Engineer      | For model development and deployment     | Full model/deployment access; storage write               |
| MLOps Engineer   | For pipeline management                  | Pipeline run permissions; monitoring access               |
| AI Viewer        | Read-only access                         | View all resources without modification                   |
--------------------------------------------------------------------------------------------------------------------------
## Deployment
1. Plan Deployment
```
terraform plan -var-file=dev.tfvars
```
2. Apply Configuration
```
terraform apply -var-file=dev.tfvars
```
3. Verify Outputs
After successful deployment, Terraform will output:
•	Custom role definitions
•	All role assignments
•	Resource mappings
## Validation
1. Check Role Assignments
```
az role assignment list --all --output table
```
2. Verify Custom Roles
```
az role definition list --custom-role true --output json
```
3. Test Access
Use the Azure Portal to verify:
1.	Log in as different users
2.	Check expected access levels
3.	Verify restrictions work as intended

## Maintenance
# Adding New Principals
1.	Edit principals.csv
2.	Add new entries following the same format
3.	Re-run Terraform:
```
terraform apply -var-file=dev.tfvars
```
## Modifying Roles
1.	Edit the role definitions in modules/rbac/main.tf
2.	Update permissions as needed
3.	Apply changes:
```
terraform apply -var-file=dev.tfvars
```
### Troubleshooting
## Common Issues
1.	Principal Not Found:
o	Verify the principal exists in Azure AD
o	Check for typos in the CSV file
o	Ensure you have Azure AD read permissions
2.	Permission Errors:
```
Error: authorization.RoleAssignmentsClient#Create: Failure responding to request
```
o	Verify the deploying identity has Owner/User Access Administrator rights
3.	CSV Format Issues:
o	Ensure no trailing commas
o	Verify UTF-8 encoding
o	Check line endings (LF vs CRLF)
Debugging Tips
1.	Enable verbose logging:
```
export TF_LOG=DEBUG
terraform apply -var-file=dev.tfvars
```
2.	Validate CSV format:
```
python -c "import csv; csv.DictReader(open('principals.csv')); print('CSV valid')"
```
3.	Check Azure AD objects:
```
# For users
az ad user show --id user@company.com

# For groups
az ad group list --display-name "AI Admins"

# For service principals
az ad sp list --display-name "ai-foundry-sp"
```
Security Considerations
1.	Least Privilege: Custom roles follow least privilege principles
2.	Audit Trail: All changes are tracked through Terraform state
3.	Version Control: CSV file changes are version controlled
4.	Sensitive Data: No secrets are stored in configuration
Best Practices
1.	Review CSV Changes: Peer-review all CSV modifications
2.	Regular Audits: Quarterly access reviews
3.	Automated Validation: Implement CI/CD checks for CSV format
4.	Documentation: Keep role definitions documented
## Sample Output After Deployment
```
Apply complete! Resources: 12 added, 0 changed, 0 destroyed.

Outputs:

custom_role_definitions = {
  "ai_data_scientist" = {
    "id" = "/subscriptions/.../roleDefinitions/...",
    "name" = "AI Data Scientist - ai-foundry-dev"
  }
  "ai_engineer" = {
    "id" = "/subscriptions/.../roleDefinitions/...",
    "name" = "AI Engineer - ai-foundry-dev"
  }
  "mlops_engineer" = {
    "id" = "/subscriptions/.../roleDefinitions/...",
    "name" = "MLOps Engineer - ai-foundry-dev"
  }
}

role_assignments = {
  "built_in_roles" = {
    "key_vault_admins" = {
      "/subscriptions/.../..." = {
        "principal_id" = "00000000-0000-0000-0000-000000000001",
        "role_definition_name" = "Key Vault Administrator"
      }
    }
  }
  "custom_roles" = {
    "ai_engineers" = {
      "/subscriptions/.../..." = {
        "principal_id" = "00000000-0000-0000-0000-000000000002",
        "role_definition_name" = "AI Engineer - ai-foundry-dev"
      }
    }
  }
}
```
