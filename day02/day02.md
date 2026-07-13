# 🧩 TerraWeek Day 2 — HCL Deep Dive: Variables, Types & Expressions

**Date:** Monday, 13th July 2026

---

## 📝 Tasks

### Task 1: Master HCL Syntax
Explain (with examples) in your notes:
- The anatomy of a **block**: `block_type "label_one" "label_two" { argument = value }`.
- The difference between an **argument** and a **block**.
- **Expressions**: string interpolation `"${...}"`, references (`resource.name.attr`), and operators.
## 1. Anatomy of a Block

A block is the basic building unit in Terraform.

**Syntax:**
```hcl
block_type "label_one" "label_two" {
  argument = value
}
```

**Example:**
```hcl
resource "aws_instance" "web" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"
}
```

- `resource` → Block type
- `aws_instance` → Resource type
- `web` → Resource name

---

## 2. Argument vs Block

**Argument:** Assigns a value using `=`

```hcl
instance_type = "t2.micro"
```

**Block:** Groups related settings inside `{}`

```hcl
network_interface {
  device_index = 0
}
```

---

## 3. Expressions

**String Interpolation**
```hcl
name = "server-${var.environment}"
```

**Reference**
```hcl
subnet_id = aws_subnet.public.id
```

**Operators**
```hcl
count = 2 + 3
var.size == "large"
var.enabled && var.create
```

### Task 2: Variables, Types & Validation
Create a `variables.tf` and define variables covering **each major type**:
- Primitives: `string`, `number`, `bool`
- Collections: `list(string)`, `map(string)`, `set(string)`
- Structural: `object({...})`, `tuple([...])`

Add at least one variable with:
- a **`default`**,
- a **`validation`** block (e.g. only allow certain values),
- the **`sensitive = true`** flag.

**[`./variables.tf`](./variables.tf)**

### Task 3: Locals, Outputs & Functions
- Use a **`locals`** block to compute a value (e.g. a common `name_prefix` or merged tags).
- Add **`outputs`** that expose useful values.
- Use at least **3 built-in functions** — e.g. `upper()`, `merge()`, `join()`, `lookup()`, `length()`, `format()`.
  Explore them live with `terraform console`:

**[`./locals.tf`](.locals.tf)**

<img width="1067" height="347" alt="3" src="https://github.com/user-attachments/assets/427e5644-a5c0-458d-9872-d62652432b81" />


### Task 4: Build Something Real (Docker provider — no cloud cost)
Use the **starter code in [`./example`](./example)**. It uses the **`kreuzwerker/docker`** provider to pull an Nginx image and run a container — fully driven by variables.

```bash
cd example
terraform init
terraform plan  -var 'container_name=tws-web' -var 'external_port=8080'
terraform apply -var 'container_name=tws-web' -var 'external_port=8080'
# visit http://localhost:8080
terraform output
terraform destroy -var 'container_name=tws-web' -var 'external_port=8080'
```
<img width="1742" height="916" alt="4" src="https://github.com/user-attachments/assets/05f2181d-48b3-4e0f-aba2-8f931b43736c" />
<img width="1821" height="907" alt="5" src="https://github.com/user-attachments/assets/577095a2-ab4f-4379-8e30-27a41ab20c64" />
<img width="997" height="127" alt="7" src="https://github.com/user-attachments/assets/45e767bc-feb4-4679-b7e3-b05effcd972d" />

<img width="1912" height="867" alt="6" src="https://github.com/user-attachments/assets/c1d611fd-1871-4c2b-860c-6f2541250250" />
<img width="1786" height="912" alt="8" src="https://github.com/user-attachments/assets/b580a42f-8e23-4715-aa0a-b1a9b261ec32" />


Then try the same run using a **`terraform.tfvars`** file instead of `-var` flags and note the difference.
- **`-var`** → Variables are passed through the command line for each run.
- **`terraform.tfvars`** → Variables are stored in a file, so Terraform loads them automatically, making commands shorter and easier to reuse.
---

## 📊 Variable Precedence (highest wins)
```
-var / -var-file  ▶  *.auto.tfvars  ▶  terraform.tfvars  ▶  TF_VAR_ env vars  ▶  default
```
