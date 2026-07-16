# 📦 TerraWeek Day 5 — Modules: Reusable, Composable Infrastructure

**Date:** Thursday, 16th July 2026

---

### Task 1: Modules — the Why

Answer in your notes:

#### What is a **module**? What counts as the **root module**?

A **module** is a group of Terraform files that work together to create infrastructure. It helps you **reuse code** instead of writing the same configuration again.

The **root module** is the main Terraform folder where you run commands like:

```bash
terraform init
terraform plan
terraform apply
```

It is the starting point of your Terraform project and can call other modules (child modules).

#### What are the benefits — **reusability, consistency, encapsulation, versioning, testing**?

- **Reusability** – Write the code once and use it multiple times, saving time and reducing errors.
- **Consistency** – Ensures the same infrastructure is created across all environments (Dev, Staging, Production).
- **Encapsulation** – Groups related Terraform resources into a single module, making the code organized and easier to manage.
- **Versioning** – Lets you use a fixed module version to avoid unexpected changes.
- **Testing** – Modules can be tested before using them in production, helping catch errors early.

#### What files make up a well-structured module (`main.tf`, `variables.tf`, `outputs.tf`, `README.md`)?

- **`main.tf`** – Contains the main Terraform resources.
- **`variables.tf`** – Defines input variables for the module.
- **`outputs.tf`** – Defines the values the module returns.
- **`README.md`** – Explains how to use the module and its inputs/outputs.

```text
modules/
└── ec2/
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    └── README.md
```

---

### Task 2: Write Your Own Module

Use the **starter code in** `./example`. It contains:

- A reusable module at `./example/modules/ec2_instance`
- A **root module** (`./example`) that calls it.

Study how the root resolves shared lookups **once** (AMI, subnet, security group) and passes them as **inputs**, then reads the module's **outputs**:

```hcl
module "web_server" {
  source                 = "./modules/ec2_instance"
  name                   = "web"
  instance_type          = "t2.micro"
  environment            = "dev"
  ami                    = data.aws_ami.al2023.id   # resolved in the root
  subnet_id              = local.subnet_id
  vpc_security_group_ids = local.security_group_ids
}

output "web_public_ip" {
  value = module.web_server.public_ip
}
```

> 💡 Notice the module takes **IDs as inputs** instead of doing its own lookups. That keeps it reusable and avoids running the same data source once per instance.

```bash
cd example
terraform init      # note how Terraform initializes the module
terraform plan
terraform apply
terraform destroy
```
<img width="1912" height="1012" alt="1" src="https://github.com/user-attachments/assets/fc8c782a-4247-487c-b5e1-2daf0cacd0e6" />
<img width="1815" height="737" alt="3" src="https://github.com/user-attachments/assets/b865f2cd-1e63-4b38-b7c2-778915ba0584" />

---

### Task 3: Modular Composition (`for_each`)

Instantiate the **same module multiple times** to build multiple servers cleanly:

```hcl
module "servers" {
  source   = "./modules/ec2_instance"
  for_each = toset(["app", "worker", "cache"])

  name                   = each.key
  instance_type          = "t2.micro"
  environment            = "dev"
  ami                    = data.aws_ami.al2023.id
  subnet_id              = local.subnet_id
  vpc_security_group_ids = local.security_group_ids
}
```

Add this to the root module and observe the plan.
<img width="1901" height="897" alt="2" src="https://github.com/user-attachments/assets/f28a2e54-2f07-49a1-ac88-62af0a747ef1" />

---

### Task 4: Consume a Registry Module + Version Locking

Use a real, popular module from the **[Terraform Registry](https://registry.terraform.io/)** — e.g. the official AWS VPC module — and **pin its version**:

```hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"   # ✅ always pin registry/git module versions

  name = "terraweek-vpc"
  cidr = "10.0.0.0/16"

  # ...
}
```
<img width="1821" height="977" alt="4" src="https://github.com/user-attachments/assets/9f30fe60-aa3d-478a-82fd-42e8fac49182" />

---

### Task 5: Ways to Lock Module Versions

Document, with code snippets, **each** way to pin a module source:

- **Registry:** `version = "~> 5.0"` (also `= 5.1.2`, `>= 5.0, < 6.0`).
- **Git tag/ref:** `source = "git::https://github.com/org/repo.git//path?ref=v1.2.0"`.
- **Git commit SHA** for immutability: `?ref=<full-sha>`.
<img width="1477" height="971" alt="5" src="https://github.com/user-attachments/assets/40c0578c-e958-41d3-854b-7d29540a8d8f" />
<img width="1446" height="887" alt="6" src="https://github.com/user-attachments/assets/bd66fc3a-bf1d-485a-9536-d6348d934320" />
<img width="1481" height="937" alt="7" src="https://github.com/user-attachments/assets/d0762f94-7e1a-4836-9b26-e2ebdc305255" />
<img width="1457" height="725" alt="8" src="https://github.com/user-attachments/assets/62e29c0e-5444-4ec2-9862-8cfb4bc5c521" />


Explain why **pinning matters** (reproducible builds, no surprise breaking changes).

- Ensures **reproducible builds** by using the same module version every time.
- Prevents **unexpected breaking changes** from newer module versions.
- Keeps deployments **stable and consistent** across all environments.

---
