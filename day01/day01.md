# 🌱 TerraWeek Day 1 — Introduction to IaC & Terraform Basics

**Date:** Sunday, 12th July 2026

---


## Task 1: Understand IaC & Terraform

### What is **Infrastructure as Code**, and what problems does it solve compared to clicking around a cloud console?

> Terraform is an Infrastructure as Code (IaC) tool that can automate your infrastructure management and provisioning of instances, storage, backups and databases using code instead of manually configuring resources.

Compared to manually clicking around a cloud console, Infrastructure as Code (IaC) solves these key problems:

- Reduces errors – Fewer manual mistakes.
- Ensures consistency – Same infrastructure every time.
- Saves time – Automates provisioning.
- Version control – Tracks changes in Git.
- Repeatable – Recreate infrastructure anytime.
- Prevents drift – Keeps environments consistent.
- Improves collaboration – Teams work from the same code.
- Easy recovery – Rebuild infrastructure from code.

---

### What is **Terraform**, and why is it so popular?

Terraform is an IaC tool made by HashiCorp. It lets you create and manage cloud infrastructure by writing code in HCL instead of clicking through the cloud console.

It is popular because:

- Declarative – You write what infrastructure you want, and Terraform figures out how to create it.
- Provider-agnostic – You can use Terraform with AWS, Azure, GCP and many other platforms.
- Huge ecosystem – It supports thousands of providers and reusable modules, making it easy to manage different types of infrastructure.

---

### Terraform vs alternatives — write one line each on how Terraform compares to **OpenTofu**, **Pulumi**, **CloudFormation**, and **Ansible**

- **Terraform** – Declarative Infrastructure as Code tool. Uses HCL and works with multiple cloud providers.
- **OpenTofu** – Open-source fork of Terraform. Uses HCL and is mostly compatible with Terraform.
- **Pulumi** – Infrastructure as Code tool that uses programming languages like Python, Java, TypeScript, Go, and C# instead of HCL.
- **CloudFormation** – AWS-specific Infrastructure as Code tool. Uses YAML or JSON and works only with AWS.
- **Ansible** – Configuration management and automation tool. Uses YAML playbooks and follows an imperative/procedural approach for tasks.

---

## Task 2: Install Terraform (latest version)

- Install **Terraform ≥ 1.15** using the official install guide.

```bash
terraform version
terraform -help
```
<img width="847" height="322" alt="1" src="https://github.com/user-attachments/assets/236a99bf-fe55-4c25-817c-68e79787bdd4" />
<img width="1012" height="872" alt="1" src="https://github.com/user-attachments/assets/45bb5b4e-10be-4267-a589-e12d398d188b" />

- Install the **HashiCorp Terraform** extension in VS Code for syntax highlighting and autocomplete.
<img width="1801" height="905" alt="3" src="https://github.com/user-attachments/assets/821f7070-1032-4043-b056-662c3749e620" />

---

## Task 3: Learn 6 Crucial Terraform Terminologies

Explain each of these **in your own words** with a one-line example.

### Provider

A plugin that lets Terraform connect to a cloud or platform like AWS, Azure, or Docker.

**Example:** AWS provider lets Terraform create an EC2 instance.

### Resource

A cloud resource or infrastructure component that Terraform creates and manages.

**Example:** An EC2 instance, S3 bucket, or VPC.

### State

A file (`terraform.tfstate`) that keeps track of the resources Terraform has created and manages.

**Example:** After creating an EC2 instance, its details are stored in `terraform.tfstate`.

### Plan

A preview showing what Terraform will create, update, or delete before making changes.

**Example:** `terraform plan` shows that it will create one EC2 instance.

### HCL (HashiCorp Configuration Language)

The simple, human-readable language used to write Terraform configuration files.

**Example:** Writing an `aws_instance` resource in a `.tf` file.

### Module

A reusable collection of Terraform files that can be used multiple times.

**Example:** A VPC module that creates a VPC, subnets, and route tables with one call.

---

## Task 4: Your First Terraform Config (no cloud account needed!)

Use the **starter code in `./example`** — it uses the `local` and `random` providers, so it costs **nothing** and needs **no credentials**.

Run the **core Terraform workflow** and capture the output of each step:


- cd example
- terraform init      # download providers, initialize the working directory
<img width="866" height="590" alt="image" src="https://github.com/user-attachments/assets/a48a82dc-13b1-49d3-a25a-81ade755d712" />

- terraform fmt       # format your code
- terraform validate  # check for syntax errors
- terraform plan      # preview what will be created
<img width="1413" height="837" alt="image" src="https://github.com/user-attachments/assets/cae349f9-c2f5-4b8d-b734-e44116a47d47" />

- terraform apply     # create the resources (type: yes)
<img width="978" height="877" alt="image" src="https://github.com/user-attachments/assets/f59c60e2-2ab8-4e46-9d56-e565eec4da91" />

- cat greeting.txt    # see the file Terraform generated
<img width="733" height="72" alt="image" src="https://github.com/user-attachments/assets/97d79def-5a35-4164-af59-b210639ef485" />

- terraform destroy   # clean up (type: yes)
<img width="1447" height="880" alt="image" src="https://github.com/user-attachments/assets/33812776-2557-40d7-a3ee-14b16ceff891" />


---

# 🔁 The Core Terraform Workflow

```text
Write  ──▶  Init  ──▶  Plan  ──▶  Apply  ──▶  Destroy
(.tf)     (init)     (preview)   (create)    (clean up)
```

---

# 🍫 Bonus (Brownie Points)

- Set up **tab completion** for the Terraform CLI:

```bash
terraform -install-autocomplete
```
This enables **tab completion** for Terraform commands and resource names, making the CLI easier and faster to use.

- Try **OpenTofu** (the open-source fork) and note the differences.
**OpenTofu** is the open-source fork of Terraform.

**Difference:**
- **Terraform** → Owned by HashiCorp (BUSL license)
- **OpenTofu** → Community-maintained and fully open source (MPL 2.0)

Most Terraform code works in OpenTofu without changes.

- Explore the `.terraform.lock.hcl` lock file that gets created — what is it for?
The **`.terraform.lock.hcl`** file is created during `terraform init`.

It stores:
- The exact provider versions
- Provider checksums (hashes)

**Why is it used?**
- Keeps provider versions consistent for everyone.
- Verifies downloaded providers are safe.
- Prevents unexpected version changes.

---
