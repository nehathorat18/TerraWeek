# 🚀 TerraWeek Day 6 — Advanced Terraform + Capstone Project

**Date:** Friday, 17th July 2026
---
### Task 1: Workspaces & Environments
- Learn what **workspaces** are and how they isolate state per environment.

- **Workspaces** let you use the **same Terraform code** for multiple environments (like `dev`, `test`, and `prod`).
- Each workspace has its **own state file**, so changes in one environment don't affect the others.

**Example:**
- `dev` workspace → Creates Dev resources
- `prod` workspace → Creates Production resources


```bash
terraform workspace list
terraform workspace new staging
terraform workspace select staging
terraform workspace show
```
<img width="1137" height="667" alt="1" src="https://github.com/user-attachments/assets/7e7b4b7c-9726-4c0b-a264-52cd36896b08" />


- Use `terraform.workspace` in your config (e.g. size things differently per env):
```hcl
locals {
  instance_type = terraform.workspace == "prod" ? "t3.medium" : "t3.micro"
}
```
- Discuss the **trade-offs**: workspaces vs separate directories/backends per environment.

| Workspaces | Separate Directories/Backends |
|------------|-------------------------------|
| Same code, different state | Separate code and state |
| Easy for small projects | Better for production |
| Quick to switch | More secure and isolated |

**Summary:**
- **Workspaces** → Best for small/simple projects.
- **Separate directories/backends** → Best for production projects.

### Task 2: Quality Gates — `fmt`, `validate`, `test`
- Format and validate everything:
```bash
terraform fmt -recursive
terraform validate
```
<img width="877" height="117" alt="2" src="https://github.com/user-attachments/assets/962bc601-b76c-410f-b788-3e7fc0819b5c" />


- Write a **native test** with the **`terraform test`** framework (Terraform 1.6+). See [`./example/tests/basic.tftest.hcl`](./example/tests/basic.tftest.hcl):
```bash
cd example
terraform init
terraform test
```
<img width="1355" height="737" alt="3" src="https://github.com/user-attachments/assets/3f472bb5-6213-4036-b50a-14807e021f80" />


### **Tearing Down**

- **Tearing down** means Terraform is **cleaning up (destroying)** the resources created during the test.
- It happens after the tests finish to keep the environment clean and avoid unnecessary costs.

**Example:**
`terraform test` → Create resources → Run tests → **Tear down (destroy resources)**.

Explain the difference between a `plan`-based `command` and an `apply`-based one in a test.
- **`plan`** → Checks the execution plan only (no changes).
- **`apply`** → Creates the infrastructure and verifies the actual result.


### Task 3: Security & Cost Scanning
Run a static analysis tool against your Day 3 or Day 5 code and fix what it flags:
- **[Trivy](https://github.com/aquasecurity/trivy)**: `trivy config .`
<img width="1425" height="500" alt="4" src="https://github.com/user-attachments/assets/6f768ad0-9fe9-4452-a739-8f38cf6883aa" />
<img width="1412" height="875" alt="5" src="https://github.com/user-attachments/assets/dabdc444-fd41-4c81-9f4c-c44faa50a8be" />
<img width="767" height="147" alt="6" src="https://github.com/user-attachments/assets/b7568c44-5a61-4e77-a2c0-8e4b491a3b20" />

### **Trivy Findings & Resolutions**

| Issue | Resolution |
|--------|------------|
| **VPC Flow Logs not enabled** | Enable VPC Flow Logs by setting `enable_flow_log = true` in the VPC module and configure CloudWatch Logs or S3. |
| **IMDSv2 not enforced** | Add `metadata_options { http_tokens = "required" }` to the `aws_instance` resource. |
| **Root EBS volume not encrypted** | Add `root_block_device { encrypted = true }` to the `aws_instance` resource to encrypt the root disk. |


### Task 4: CI/CD with GitHub Actions
- Use the starter workflow at [`./example/.github-workflow-example.yml`](./example/.github-workflow-example.yml).
- Copy it to `.github/workflows/terraform.yml` in your repo.
- It runs `fmt -check`, `init`, `validate`, and `plan` on every PR. Explain each step.
<img width="1347" height="775" alt="7" src="https://github.com/user-attachments/assets/ee8b7d1f-370f-4706-9552-eb36855d52be" />
<img width="1396" height="647" alt="8" src="https://github.com/user-attachments/assets/6e40bed4-1314-436d-b79e-bd2b5abc4dc7" />
<img width="1907" height="757" alt="9" src="https://github.com/user-attachments/assets/9524d693-bff8-46e3-8984-a81aeba83ff2" />
<img width="1882" height="900" alt="10" src="https://github.com/user-attachments/assets/994e447c-7042-47a3-a8ae-b031709e14d7" />


### Task 5: Best Practices Checklist
Document how your capstone honors these:
- ✅ Remote state with locking (Day 4) — **never commit `.tfstate`**.
- ✅ **Pin** Terraform + provider + module versions.
- ✅ Reusable **modules** (Day 5), consistent naming & tagging.
- ✅ **No hard-coded secrets** — use variables / env / a secrets manager.
- ✅ `fmt` + `validate` + `test` + a security scan in CI.
- ✅ A clear **`README.md`** and a working `terraform destroy`.

---

