# Personal Cloud Portfolio (Infrastructure as Code)

![Build Status](https://img.shields.io/badge/build-passing-brightgreen)
![Terraform](https://img.shields.io/badge/terraform-v1.5+-623CE4)
![AWS](https://img.shields.io/badge/AWS-S3%20%7C%20CloudFront-orange)

## 📖 Overview

This repository contains the source code and infrastructure automation for my personal professional portfolio.

The project demonstrates a **Serverless**, **Cloud-Native** approach to static site hosting. Instead of using manual uploads, this project treats the website as a full software lifecycle artifact—provisioned via **Terraform**, secured via **OIDC**, and deployed via **GitHub Actions**.

## 🏗️ Architecture

The infrastructure is designed for high availability, security, and low latency globally.

* **Compute/Storage:** AWS S3 (Static Website Hosting) blocked from public access.
* **CDN:** AWS CloudFront (Content Delivery Network) for edge caching and SSL termination.
* **Security:**
    * **OAC (Origin Access Control):** Restricts S3 access solely to the CloudFront distribution.
    * **Identity Federation:** No long-lived IAM users are created. Authentication allows GitHub Actions to assume roles directly.

## 🚀 CI/CD & Automation

Deployment is fully automated using **GitHub Actions**, adhering to GitOps principles.

### Secure Authentication Workflow:
Unlike traditional setups that store long-lived **Access Keys (AK)** and **Secret Keys (SK)** in GitHub Secrets, this pipeline uses **OpenID Connect (OIDC)**:

1.  **Trust Relationship:** AWS trusts the GitHub OIDC Provider for this specific repository.
2.  **Short-Lived Credentials:** During the pipeline run, GitHub requests a temporary token. AWS validates this against the OIDC provider and returns **short-lived credentials** valid only for the duration of the job.
3.  **Terraform Execution:** These temporary credentials are used to run `terraform plan` and `terraform apply`, ensuring that even if the runner is compromised, there are no permanent keys to steal.

### Pipeline Steps:
1.  **Checkout Code:** Pulls the latest commits from the `main` branch.
2.  **Authenticate via OIDC:** Assumes the specific AWS IAM Role for deployment.
3.  **Terraform Apply:** Provisions infrastructure changes.
4.  **Content Sync:** Syncs the `frontend/` directory to the S3 bucket.
5.  **Cache Invalidation:** Invalidates CloudFront cache for immediate updates.

## 🛡️ Security & Governance

This repository enforces strict governance rules to simulate a production-grade enterprise environment:

* **Zero Trust Storage:** * The S3 bucket has **Block Public Access** enabled (all 4 settings set to `true`). 
    * Access is granted *only* to the CloudFront Service Principal via a strict Bucket Policy.
* **Network Security:** * **WAF Enabled:** Traffic is inspected by AWS WAF before reaching the cache.
    * **HTTPS Only:** CloudFront enforces HTTP-to-HTTPS redirection.
* **Branch Protection:**
    * The `main` branch is **locked**. Direct pushes are blocked.
    * Pull Requests (PRs) require at least **1 peer review** approval.
    * **Status Checks:** Terraform Plan must pass successfully before merging.
* **Secret Management:**
    * State files (`.tfstate`) are stored in a remote backend (S3 + DynamoDB locking), never in Git.
    * Sensitive variable files (`.tfvars`) are strictly ignored via `.gitignore`.
    * GitHub Actions use **OIDC** for short-lived AWS credentials (no hardcoded keys).

## 🛠️ Local Development

### Prerequisites
* [Terraform](https://www.terraform.io/) v1.5+
* [AWS CLI](https://aws.amazon.com/cli/) configured with appropriate profile.

### Quick Start

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/franklinpashok/YOUR-REPO-NAME.git](https://github.com/franklinpashok/personal-website.git)
    cd YOUR-REPO-NAME
    ```

2.  **Initialize Terraform:**
    ```bash
    cd terraform
    terraform init
    ```

3.  **Plan & Apply:**
    ```bash
    terraform plan -out=tfplan
    terraform apply tfplan
    ```

## 📬 Contact

**Franklin Ashok Pulltikurthi**
* **Current Role:** Automation Lead @ TCS Madrid Spain
* **LinkedIn:** [linkedin.com/in/franklin-pulltikurthi-55158535](https://linkedin.com/in/franklin-pulltikurthi-55158535)