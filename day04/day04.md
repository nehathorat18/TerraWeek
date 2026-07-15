# 🗄️ TerraWeek Day 4 — State & Remote Backends (Native Locking)

**Date:** Wednesday, 15th July 2026

---

### Task 1: Why State Matters
Explain in your notes:
- What is the **`terraform.tfstate`** file and what does it store?
- The `terraform.tfstate` file is automatically created when you run `terraform apply`. It stores the current state of your infrastructure, including resources, data sources, and outputs. Terraform uses it to track and manage your infrastructure.

- Why should you **never** edit it by hand or commit it to Git?
- **Never edit it by hand** because it can corrupt the state and cause Terraform to lose track of your infrastructure.
- **Never commit it to Git** because it may contain sensitive information (such as IDs, IP addresses or secrets) and can cause conflicts when multiple people work on the same infrastructure.

- What is **state drift**, and how does `terraform plan` / `terraform refresh` relate to it?
- **State drift** happens when your actual infrastructure is changed outside of Terraform, so it no longer matches the Terraform state.
- `terraform plan` detects the differences between the state and the real infrastructure.
- `terraform refresh` updates the state file to match the current infrastructure.

- Why is state **sensitive** (it can contain secrets in plaintext)?
- The state file is **sensitive** because it can store secrets in plain text, such as passwords, API keys, and access tokens. Always keep it secure and never share it publicly.

### Task 2: Explore Local State & `terraform state`
Start from **any** working config (reuse Day 3's, or the [`./backend_demo`](./backend_demo) here). After an `apply`, practice:
```bash
terraform state list                       # list all managed resources
terraform state show <resource_address>    # inspect one resource
terraform state mv <src> <dest>            # rename/move within state
terraform state rm <resource_address>      # stop managing (does NOT delete infra)
terraform show                             # human-readable state
```
Document what each command does and when you'd use it.

### Task 3: Bootstrap the Backend Infrastructure
The S3 bucket that *holds* your state must exist **before** you configure the backend. Use [`./backend_infra`](./backend_infra) to create it (**local** state for this bootstrap step only):
```bash
cd backend_infra
terraform init
terraform apply    # creates the versioned, encrypted S3 state bucket
```

### Task 4: Configure the Remote Backend with Native Locking
Now point a real config at that bucket. See [`./backend_demo`](./backend_demo):
```hcl
terraform {
  backend "s3" {
    bucket       = "your-unique-terraweek-state-bucket"
    key          = "day04/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true   # ✅ native S3 state locking — no DynamoDB!
  }
}
```
```bash
cd backend_demo
terraform init     # Terraform will offer to migrate local state → S3
terraform apply
```
Verify in the S3 console that your `terraform.tfstate` is uploaded, and watch a `.tflock` file appear/disappear during an apply.

### Task 5: Import an Existing Resource
Create something manually in the console (e.g. an S3 bucket), then bring it under Terraform management using an **`import` block** (Terraform 1.5+):
```hcl
import {
  to = aws_s3_bucket.imported
  id = "my-manually-created-bucket"
}
```
Run `terraform plan -generate-config-out=generated.tf` and review the generated config.



---

## 🧹 Cleanup
```bash
cd backend_demo && terraform destroy
cd ../backend_infra && terraform destroy   # empty the bucket first if versioning blocks it
```

---
