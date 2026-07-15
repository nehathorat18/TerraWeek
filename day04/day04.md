# 🗄️ TerraWeek Day 4 — State & Remote Backends (Native Locking)

**Date:** Wednesday, 15th July 2026

---

### Task 1: Why State Matters

#### What is the `terraform.tfstate` file and what does it store?

The `terraform.tfstate` file is automatically created when you run `terraform apply`. It stores the current state of your infrastructure, including resources, data sources, and outputs. Terraform uses it to track and manage your infrastructure.

#### Why should you **never** edit it by hand or commit it to Git?

- **Never edit it by hand** because it can corrupt the state and cause Terraform to lose track of your infrastructure.
- **Never commit it to Git** because it may contain sensitive information (such as IDs, IP addresses, or secrets) and can cause conflicts when multiple people work on the same infrastructure.

#### What is **state drift**, and how does `terraform plan` / `terraform refresh` relate to it?

- **State drift** happens when your actual infrastructure is changed outside of Terraform, so it no longer matches the Terraform state.
- `terraform plan` detects the differences between the state and the real infrastructure.
- `terraform refresh` updates the state file to match the current infrastructure.

#### Why is state **sensitive** (it can contain secrets in plaintext)?
The state file is **sensitive** because it can store secrets in plain text, such as passwords, API keys, and access tokens. Always keep it secure and never share it publicly.

---
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
<img width="1507" height="920" alt="22" src="https://github.com/user-attachments/assets/8472dc43-5ca9-4f56-bd37-60e925c131eb" />


### Task 3: Bootstrap the Backend Infrastructure
The S3 bucket that *holds* your state must exist **before** you configure the backend. Use [`./backend_infra`](./backend_infra) to create it (**local** state for this bootstrap step only):
```bash
cd backend_infra
terraform init
terraform apply    # creates the versioned, encrypted S3 state bucket
```
<img width="1775" height="717" alt="3" src="https://github.com/user-attachments/assets/acb1cd6d-c194-437c-9967-5f58b5614863" />
<img width="1657" height="672" alt="4" src="https://github.com/user-attachments/assets/c763c791-955a-48d8-b330-68281437a356" />
<img width="1022" height="525" alt="0" src="https://github.com/user-attachments/assets/8f451631-9c6b-43cf-ae91-3ea2f419807a" />
<img width="1896" height="897" alt="1" src="https://github.com/user-attachments/assets/acd13db7-6615-48a0-8079-b72c6363cf91" />
<img width="1892" height="807" alt="2" src="https://github.com/user-attachments/assets/ecb5a25f-86e3-4c93-8b12-89a37b7fc47c" />


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
<img width="1411" height="606" alt="5" src="https://github.com/user-attachments/assets/ef4c42b8-00b2-4526-b107-335fc053ea65" />
<img width="1892" height="900" alt="6" src="https://github.com/user-attachments/assets/bb53abe5-bd06-47d7-8df4-d58ae680053b" />
<img width="1887" height="867" alt="7" src="https://github.com/user-attachments/assets/aff2c5f2-7b3f-46fb-840d-193db159b7c2" />


### Task 5: Import an Existing Resource
Create something manually in the console (e.g. an S3 bucket), then bring it under Terraform management using an **`import` block** (Terraform 1.5+):
```hcl
import {
  to = aws_s3_bucket.imported
  id = "my-manually-created-bucket"
}
```
Run `terraform plan -generate-config-out=generated.tf` and review the generated config.
<img width="1242" height="552" alt="5 1" src="https://github.com/user-attachments/assets/c39bc399-171f-48e1-8965-4e0975ab3412" />
<img width="1416" height="867" alt="5 2" src="https://github.com/user-attachments/assets/009efccf-a1a0-4b81-87a6-f6e1a35f0830" />



---

## 🧹 Cleanup
```bash
cd backend_demo && terraform destroy
cd ../backend_infra && terraform destroy   # empty the bucket first if versioning blocks it
```
<img width="1817" height="892" alt="error-versioningenabled" src="https://github.com/user-attachments/assets/5ce8a31b-38e4-4688-aeda-77a32ec1caf9" />
<img width="1150" height="562" alt="destory" src="https://github.com/user-attachments/assets/84b1ce67-e8aa-40dc-a678-507892c9cb55" />

---
