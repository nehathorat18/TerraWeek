# ☁️ TerraWeek Day 3 — Providers, Resources & Your First Cloud Infra

**Date:** Tuesday, 14th July 2026

---

## 🗺️ 60-Second Networking Primer (read this first!)

Today jumps from a single container to a real cloud network. Don't panic — here are the **6 building blocks** you'll create, in plain English:

| Block | What it is | Real-world analogy |
|-------|------------|--------------------|
| **VPC** | Your own private, isolated network in the cloud (a range of IPs like `10.0.0.0/16`) | Your own gated neighborhood |
| **Subnet** | A slice of the VPC's IPs (`10.0.1.0/24`), lives in one Availability Zone | A street in that neighborhood |
| **Internet Gateway (IGW)** | The door between your VPC and the public internet | The neighborhood's main gate |
| **Route Table** | Rules that say "traffic for the internet → go via the IGW" | Road signs / GPS routes |
| **Security Group (SG)** | A stateful virtual firewall on the instance (which ports are open) | A bouncer checking who gets in |
| **EC2 Instance** | The actual virtual machine running your app | A house on the street |

**How they connect:** an **EC2 instance** lives in a **subnet**, inside a **VPC**. To reach the internet, the subnet's **route table** sends traffic through the **IGW**, and the **security group** decides which ports (e.g. 80/HTTP) are allowed in.

```
Internet ──▶ [IGW] ──▶ [Route Table] ──▶ [ Public Subnet ] ──▶ [SG] ──▶ [EC2]
                                          (inside the VPC)
```

--- 

## 📝 Tasks

### Task 1: Providers & Version Pinning
- Add a `terraform` block with `required_version` and `required_providers` (pin with `~>`).
- Explain **why version pinning matters** and what the `~>` (pessimistic) operator does.
- **Version pinning** ensures everyone uses the same provider version, preventing unexpected changes and keeping deployments consistent.
- **`~>` (pessimistic operator)** allows compatible updates while preventing breaking major version upgrades.
- **Bonus:** configure a second provider **alias** (e.g. a second AWS region) and explain when you'd use it.
#### When would you use a Provider Alias?

- To create resources in **multiple AWS regions** (e.g., `us-west-2` and `us-east-1`).
- To manage **multiple AWS accounts** in the same Terraform project.
- To use different provider configurations for **Dev**, **QA**, and **Production** environments.

### Task 2: Resources vs Data Sources
- Create at least one **resource** (something new).
- Use at least one **`data`** source to *read* existing info (e.g. `aws_ami`, `aws_availability_zones`, or your default VPC).
- Explain the difference: **resources create/manage**, **data sources only read**.
- **Resources** create and manage infrastructure (e.g., EC2, VPC, Subnet).
- **Data sources** only read existing information (e.g., AMI, Availability Zones) and do not create anything.

### Task 3: Provision a Cloud Stack
Use the **AWS starter code in [`./example`](./example)** (or adapt to Azure/GCP). It builds a minimal, free-tier-friendly stack:
- a **VPC** + **public subnet** + **internet gateway** + **route table**
- a **security group**
- an **EC2 instance** using a **data source** to find the latest Amazon Linux 2023 AMI

```bash
cd example
terraform init
terraform validate
terraform plan
terraform apply      # type: yes
terraform state list # see everything Terraform now manages
```

### Task 4: Meta-Arguments in Action
Extend the config to practice each of these:
- **`count`** — create N identical resources (e.g. N EC2 instances).
- **`for_each`** — create resources from a `map`/`set` (preferred over `count` for named things).
- **`depends_on`** — force an explicit ordering.
- **`lifecycle`** — try `create_before_destroy`, `prevent_destroy`, and `ignore_changes`.
| Lifecycle Rule | Easy Memory Trick |
|----------------|-------------------|
| `create_before_destroy` | **Create first, delete later** |
| `prevent_destroy` | **Don't delete this resource** |
| `ignore_changes` | **Ignore changes to selected fields** |
```hcl
lifecycle {
  create_before_destroy = true
  ignore_changes        = [tags["LastModified"]]
}
```

### Task 5: Update & Destroy
- Change a `tag` or the `instance_type`, run `terraform plan`, and read the diff — notice what forces **replace** vs **in-place update**.
- **Always** finish with:
```bash
terraform destroy   # type: yes  — avoid surprise bills!
```

---

## 🧠 `count` vs `for_each` — which one?
- Use **`count`** for N *identical, interchangeable* resources.
- Use **`for_each`** when each instance has a *stable identity* (a name/key) — deleting one won't reindex the rest.

---

## 🍫 Bonus (Brownie Points)
- Attach an Elastic IP, or add user-data to install Nginx on boot.
- Use `terraform graph` and visualize the dependency graph.
- Try the **`moved`** block to rename a resource without destroying it.

---
