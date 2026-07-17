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
- Write a **native test** with the **`terraform test`** framework (Terraform 1.6+). See [`./example/tests/basic.tftest.hcl`](./example/tests/basic.tftest.hcl):
```bash
cd example
terraform init
terraform test
```
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
### **Trivy Findings & Resolutions**

| Issue | Resolution |
|--------|------------|
| **VPC Flow Logs not enabled** | Enable VPC Flow Logs by setting `enable_flow_log = true` in the VPC module and configure CloudWatch Logs or S3. |
| **IMDSv2 not enforced** | Add `metadata_options { http_tokens = "required" }` to the `aws_instance` resource. |
| **Root EBS volume not encrypted** | Add `root_block_device { encrypted = true }` to the `aws_instance` resource to encrypt the root disk. |
- or **[Checkov](https://www.checkov.io/)**: `checkov -d .`
- or **[tfsec](https://github.com/aquasecurity/tfsec)** (now part of Trivy).
- **Bonus:** estimate cloud cost of a plan with **[Infracost](https://www.infracost.io/)**.

### Task 4: CI/CD with GitHub Actions
- Use the starter workflow at [`./example/.github-workflow-example.yml`](./example/.github-workflow-example.yml).
- Copy it to `.github/workflows/terraform.yml` in your repo.
- It runs `fmt -check`, `init`, `validate`, and `plan` on every PR. Explain each step.

### Task 5: Best Practices Checklist
Document how your capstone honors these:
- ✅ Remote state with locking (Day 4) — **never commit `.tfstate`**.
- ✅ **Pin** Terraform + provider + module versions.
- ✅ Reusable **modules** (Day 5), consistent naming & tagging.
- ✅ **No hard-coded secrets** — use variables / env / a secrets manager.
- ✅ `fmt` + `validate` + `test` + a security scan in CI.
- ✅ A clear **`README.md`** and a working `terraform destroy`.

---

## 🚫 A Note on Provisioners (`remote-exec` / `local-exec`)

You'll see older tutorials configure servers with **provisioners** over SSH. HashiCorp calls these a **last resort**, and here's why:
- They break Terraform's declarative model — Terraform can't track what a script did.
- They need SSH keys + open ingress, and fail unpredictably on retries/replacements.

**Modern alternatives (use these instead):**
- **`user_data`** / cloud-init for boot-time setup (what we used on Day 3).
- **Baked images** with Packer.
- **Config management** (Ansible) or **containers** for app-level setup.

Know provisioners exist and how to read them — but reach for them last.

---

## 🏗️ CAPSTONE PROJECT — Build Your Own Infra

Bring the whole week together. **Design and deploy a small but real project** on AWS / Azure / GCP / Utho. Ideas:
- A **2-tier web app**: VPC + public/private subnets + EC2/ASG + security groups + an S3 bucket.
- A **static website**: S3 + CloudFront (+ optional Route53).
- A **containerized app** on ECS/Fargate or a small EKS/AKS/GKE cluster.

### 🧭 Reference Implementations (companion repo)
Two production-grade blueprints to study and adapt — don't just copy, **understand and extend** them:
- 🏢 **Multi-environment app** → [`aws_module_project/`](https://github.com/LondheShubham153/terraform-for-devops/tree/main/aws_module_project): one reusable module deployed to dev/stg/prd — a great template for requirement #1 (custom module).
- ☸️ **Production EKS cluster** → [`eks/`](https://github.com/LondheShubham153/terraform-for-devops/tree/main/eks): VPC + EKS via official **registry modules** (VPC `~> 6.0`, EKS `~> 21.0`, Kubernetes **1.35**), Pod Identity, SPOT node groups. Perfect for requirements #1 **and** #2 (registry module).
  > ⚠️ **Cost warning:** an EKS cluster + 2 NAT gateways is **~$155/mo**. Only spin it up briefly and run `terraform destroy` immediately after. Beginners: start with the multi-env app.

**Requirements:**
1. Use at least **one custom module** and **one registry module**.
2. Use **remote state with native S3 locking**.
3. Drive everything with **variables** + sensible **outputs**.
4. Pass **`fmt`**, **`validate`**, a **security scan**, and at least one **`terraform test`**.
5. Wire up the **GitHub Actions** workflow.
6. Write a **`README.md`** with an architecture diagram and run instructions.
7. **`terraform destroy`** cleanly when done.

---

## 🍫 Bonus (Brownie Points)
- Use **HCP Terraform (Terraform Cloud)** for remote runs + a private module registry.
- Add **pre-commit hooks** (`terraform fmt`, `tflint`, `trivy`).
- Explore **ephemeral resources / write-only arguments** (Terraform 1.10–1.11) for secret handling.
- Try **OpenTofu** as a drop-in and compare.

---
