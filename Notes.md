# API Service Creation

## Overview

The API service is structured as a two-component system:

- **Frontend**: React/Next.js application containerized in Docker (`panjek266/apps-fe`).
- **Backend**: Python FastAPI service containerized in Docker (`panjek266/python-be`).

Both are deployed using Helm charts within Kubernetes.

## Configuration

- **Frontend** connects to the backend through nginx-frontend.conf:
  - `backendHost`: tripla-apps-backend-svc
  - `backendPort`: 8080

- **Frontend Service type**: LoadBalancer (external access)
- **Backend Service type**: ClusterIP (internal access)

## Testing

Build locally or in CI/CD:

```bash
docker build -t <image> .
docker push <registry>/<image>:tag
```

Deploy with Helm:

```bash
helm install tripla-apps ./charts -f values-dev.yaml
```

Verify connectivity:

```bash
curl http://<frontend-ip>/
```

## Best Practices

- Use separate `values.yaml` per environment.
- Keep backend host and port dynamic via Helm templating.
- Apply readiness and liveness probes for both services.
- Manage version tags clearly (v0.0.x).

# Terraform Fixes

## Issues in Initial Setup

- Environment variables were hardcoded.
- Used older EKS module syntax (node_groups).
- Lacked multi-environment structure.
- No backend configuration for remote state.
- S3 bucket naming conflicts between environments.

## Fix Summary

| Area               | Fix                        | Description                                           |
|--------------------|----------------------------|-------------------------------------------------------|
| EKS Module         | Upgraded to 20.1.0         | Supports eks_managed_node_groups                      |
| Environment Handling | Used terraform.workspace  | Enables environment isolation                         |
| Variables          | Changed to map type        | Allows per-env overrides                              |
| Remote State       | Added backend.tf           | Stores tfstate in S3 with DynamoDB locking            |
| Provider           | Pinned aws version ~> 6.0  | Ensures compatibility                                 |
| S3 Bucket          | Added ACL and workspace prefix | Avoids naming conflict and ensures isolation       |

## Example Changes

```hcl
locals {
  env = terraform.workspace == "prod" ? "prod" : "non-production"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.1.0"

  cluster_name    = "${terraform.workspace}-${lookup(var.cluster_name, terraform.workspace)}"
  vpc_id          = lookup(var.vpc_id, terraform.workspace)
  subnet_ids      = lookup(var.subnet_ids, terraform.workspace)

  eks_managed_node_groups = {
    default = {
      desired_size   = 2
      min_size       = 1
      max_size       = 3
      instance_types = ["t3.medium"]
    }
  }

  tags = { Environment = local.env }
}
```

# Helm Fixes & Multi-Environment Approach

## Helm Improvements

- Created `values-{env}.yaml` files to separate environment configs.
- Used dynamic values for backend host and ports.
- Added environment labels and annotations:

```yaml
labels:
  environment: {{ .Values.environment }}
```

## Deployment Strategy

Each environment has:

- Separate namespace.
- Distinct values file.
- Independent CI/CD deployment pipeline.

Terraform manages infrastructure (EKS, S3, IAM).

Helm manages application deployment per environment.

## Example Deployment

```bash
helm upgrade --install tripla-apps ./charts -f values-prod.yaml --namespace prod
```

# AI Usage Summary

AI assistance (ChatGPT) was used for:

- Refactoring Terraform code to support multiple environments.
- Updating EKS module to latest best practices.
- Drafting Helm templating and environment separation.
- Generating structured documentation and explanations.
- Ensuring naming consistency, tagging, and maintainable structure.

AI output was verified manually before applying to production infrastructure.
