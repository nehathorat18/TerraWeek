# ☁️ TerraWeek Day 3 — Providers, Resources & Your First Cloud Infra

**Date:** Tuesday, 14th July 2026

--- 

## 📝 Tasks
### Task 1: Providers & Version Pinning

- Add a `terraform` block with `required_version` and `required_providers` (pin with `~>`).
- Explain **why version pinning matters** and what the `~>` (pessimistic) operator does.

#### Why Version Pinning Matters

- **Version pinning** ensures everyone uses the same provider version, preventing unexpected changes and keeping deployments consistent.

#### What Does `~>` Do?

- **`~>` (pessimistic operator)** allows compatible updates while preventing breaking major version upgrades.

#### Bonus

- Configure a second provider **alias** (e.g. a second AWS region) and explain when you'd use it.

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
<img width="1872" height="822" alt="INIT" src="https://github.com/user-attachments/assets/34072630-d51b-41c2-9f63-c7227a1932f5" />
<img width="1822" height="952" alt="apply" src="https://github.com/user-attachments/assets/518cfc69-7d27-46a4-ba4a-6ae80f624f1d" />

<img width="1900" height="907" alt="ec2" src="https://github.com/user-attachments/assets/a87dfd3b-3f1d-42c7-8d31-2148af343761" />
<img width="1895" height="902" alt="elasticip" src="https://github.com/user-attachments/assets/106d3b3b-78aa-48ad-9d7c-c8a9e9771ab1" />
<img width="1892" height="897" alt="sg" src="https://github.com/user-attachments/assets/6fcca8b0-d96d-4923-809d-956a80071ee9" />
<img width="1901" height="861" alt="vpc-2" src="https://github.com/user-attachments/assets/6990b470-0e16-400d-bfd6-1b432807f6cd" />
<img width="1542" height="497" alt="statelist" src="https://github.com/user-attachments/assets/06034dab-e968-43d3-b173-daf21c3419a5" />

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
prevent_destroy       = true
ignore_changes        = [tags]
  # }
}
- It will not allow us to destroy because we have added lifecycle condition hence we are getting below error.
```
<img width="1822" height="770" alt="lifecycledestroyerror" src="https://github.com/user-attachments/assets/76760ad6-e702-4e8e-888c-9e616a4fccb6" />

<img width="1817" height="712" alt="graph" src="https://github.com/user-attachments/assets/b7c9f2d4-159f-46ac-8c29-0abaf1021eb9" />
<img width="1840" height="727" alt="qaprod" src="https://github.com/user-attachments/assets/3205b798-b49d-4e54-bd57-5f4aed2cdfc6" />
<img width="1907" height="900" alt="ec22" src="https://github.com/user-attachments/assets/24452c46-cce0-49d2-9c74-4ae0981bfedd" />
<img width="1912" height="892" alt="bucket" src="https://github.com/user-attachments/assets/3b63466f-2580-4a45-9527-23da34093d57" />

### Task 5: Update & Destroy
- Change a `tag` or the `instance_type`, run `terraform plan`, and read the diff — notice what forces **replace** vs **in-place update**.
- **Always** finish with:
```bash
terraform destroy   # type: yes  — avoid surprise bills!
```
<img width="1817" height="712" alt="graph" src="https://github.com/user-attachments/assets/af8426e0-fa1b-4c7a-9a04-b455b421fe3c" />

---
