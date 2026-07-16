# 📦 TerraWeek Day 5 — Modules: Reusable, Composable Infrastructure

**Date:** Thursday, 16th July 2026

---

## 📝 Tasks

### Task 1: Modules — the Why
Answer in your notes:
- What is a **module**? What counts as the **root module**?

A **module** is a group of Terraform files that work together to create infrastructure. It helps you **reuse code** instead of writing the same configuration again.

The **root module** is the main Terraform folder where you run commands like:

```bash
terraform init
terraform plan
terraform apply
```

It is the starting point of your Terraform project and can call other modules (child modules).

- What are the benefits — **reusability, consistency, encapsulation, versioning, testing**?

- **Reusability** – Write the code once and use it multiple times, saving time and reducing errors.

- **Consistency** – Ensures the same infrastructure is created across all environments (Dev, Staging, Production).

- **Encapsulation** – Groups related Terraform resources into a single module, making the code organized and easier to manage.

- **Versioning** – Lets you use a fixed module version to avoid unexpected changes.

- **Testing** – Modules can be tested before using them in production, helping catch errors early.

- What files make up a well-structured module (`main.tf`, `variables.tf`, `outputs.tf`, `README.md`)?

- **`main.tf`** – Contains the main Terraform resources.
- **`variables.tf`** – Defines input variables for the module.
- **`outputs.tf`** – Defines the values the module returns.
- **`README.md`** – Explains how to use the module and its inputs/outputs.

modules/
└── ec2/
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    └── README.md

### Task 2: Write Your Own Module
Use the **starter code in [`./example`](./example)**. It contains:
- A reusable module at [`./example/modules/ec2_instance`](./example/modules/ec2_instance)
- A **root module** ([`./example`](./example)) that calls it.

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

### Task 5: Ways to Lock Module Versions
Document, with code snippets, **each** way to pin a module source:
- **Registry:** `version = "~> 5.0"` (also `= 5.1.2`, `>= 5.0, < 6.0`).
- **Git tag/ref:** `source = "git::https://github.com/org/repo.git//path?ref=v1.2.0"`.
- **Git commit SHA** for immutability: `?ref=<full-sha>`.
Explain why **pinning matters** (reproducible builds, no surprise breaking changes).
- Ensures **reproducible builds** by using the same module version every time.
- Prevents **unexpected breaking changes** from newer module versions.
- Keeps deployments **stable and consistent** across all environments.

---


