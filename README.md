# Production-Grade AWS EKS Platform with Terraform

[![Terraform Validate](https://github.com/your-username/aws-eks-production-terraform/actions/workflows/terraform-ci.yml/badge.svg)](https://github.com/your-username/aws-eks-production-terraform/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Terraform: >= 1.5.0](https://img.shields.io/badge/Terraform-%3E%3D%201.5.0-blue.svg)](https://www.terraform.io)
[![AWS Provider: ~> 5.0](https://img.shields.io/badge/AWS%20Provider-~%3E%205.0-orange.svg)](https://registry.terraform.io/providers/hashicorp/aws/latest)

Enterprise-ready Infrastructure-as-Code (IaC) repository that provisions a highly available, secure, and multi-tenant AWS EKS cluster across multiple Availability Zones following AWS Well-Architected and CIS Kubernetes Benchmark standards.

---

## 🏛️ Architecture Overview

```
                                      AWS Cloud (VPC: 10.0.0.0/16)
 ┌─────────────────────────────────────────────────────────────────────────────────────────────┐
 │                                                                                             │
 │   Public Subnets (Multi-AZ)                                                                │
 │   ├── Internet Gateway (IGW)                                                                │
 │   ├── NAT Gateways (Multi-AZ for HA egress)                                                 │
 │   └── Public ALBs (AWS Load Balancer Controller)                                            │
 │                                                                                             │
 │   Private App Subnets (Multi-AZ)                                                            │
 │   ├── EKS Control Plane (Private API Endpoint with Authorized CIDRs)                       │
 │   ├── Managed Node Groups (Bottlerocket / Amazon Linux 2, Encrypted EBS, IMDSv2)           │
 │   └── Workloads & Microservices (KMS-encrypted Secrets, IRSA)                               │
 │                                                                                             │
 │   Database Subnets (Multi-AZ, Isolated)                                                     │
 │   └── Amazon RDS / Aurora (No direct Internet routing)                                     │
 │                                                                                             │
 └─────────────────────────────────────────────────────────────────────────────────────────────┘
```

### Security & Compliance Controls
* **IMDSv2 Enforced:** Node launch templates strictly require HTTP tokens (`http_tokens = "required"`, hop limit 1) to mitigate SSRF credential theft.
* **KMS Envelope Encryption:** EKS Kubernetes secrets encrypted using customer-managed AWS KMS keys.
* **IAM Roles for Service Accounts (IRSA):** Principle of least privilege; pods assume IAM roles dynamically via OIDC identity provider without hardcoded AWS credentials.
* **Zero Trust Network:** Worker nodes located in private subnets with egress routed via redundant NAT Gateways; security group chaining between control plane and worker nodes.

---

## 📁 Repository Structure

```text
├── .github/
│   └── workflows/
│       └── terraform-ci.yml      # CI: Formatting, tflint, Checkov SAST security scans
├── modules/
│   ├── vpc/                      # Multi-AZ VPC, NAT Gateways, Subnet tagging for ALB
│   ├── security/                 # KMS Keys, IAM Roles, Security Groups
│   └── eks/                      # EKS Cluster, OIDC Provider, Managed Node Groups
└── environments/
    ├── dev/                      # Dev environment sizing and variables
    └── prod/                     # Production environment with HA and multi-AZ nodes
```

---

## 🚀 Getting Started

### Prerequisites
* [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.5.0
* [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) v2 configured with proper IAM permissions
* [kubectl](https://kubernetes.io/docs/tasks/tools/) matching your target EKS version (v1.29+)

### Deployment Steps

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/aws-eks-production-terraform.git
   cd aws-eks-production-terraform/environments/prod
   ```

2. **Initialize Terraform & Remote Backend:**
   ```bash
   terraform init
   ```

3. **Inspect Plan:**
   ```bash
   terraform plan -var-file="terraform.tfvars" -out=tfplan
   ```

4. **Apply Infrastructure:**
   ```bash
   terraform apply tfplan
   ```

5. **Update Local Kubeconfig:**
   ```bash
   aws eks update-kubeconfig --region us-east-1 --name prod-core-eks
   kubectl get nodes -o wide
   ```

---

## 🛡️ Automated Code Quality & DevSecOps

Every Pull Request runs an automated GitHub Actions pipeline:
* `terraform fmt -check` (Format validation)
* `tflint` (Cloud provider best practice rules)
* `Checkov` / `tfsec` (Static security analysis against CIS benchmarks)

---

## 📄 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
