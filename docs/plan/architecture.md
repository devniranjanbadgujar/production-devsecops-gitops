# GitOps repository architecture

This repository is the deployment source of truth for the application Helm chart. Jenkins updates the image values on successful `main`-branch publication; Argo CD observes Git and reconciles the chart into EKS.

![GitOps repository architecture](gitops-architecture.svg)

```mermaid
flowchart TB
  Jenkins[Jenkins CI in application repo] -->|commit updated ECR image refs| Values[values-ecr.yaml]
  Values --> GitHub[GitHub GitOps repository]
  App[Argo CD Application manifest] --> Argo[Argo CD in argocd namespace]
  GitHub -->|main / chart path| Argo
  Argo --> Helm[Helm render and reconcile]
  Helm --> NS[production-devsecops namespace]
  subgraph NS[Application namespace]
    FE[Frontend Deployment and Service]
    BE[Backend Deployment and Service]
    DB[MongoDB Deployment, Service, PVC]
    Redis[Redis Deployment, Service, PVC]
    Cfg[platform-config ConfigMap]
    Sec[Pre-created Kubernetes Secrets]
  end
  Ingress[ALB Ingress] --> FE
  ALB[AWS Load Balancer Controller] --> Ingress
  FE --> BE
  BE --> DB
  BE --> Redis
  Cfg -. environment configuration .-> BE
  Sec -. JWT / optional reporting credentials .-> BE
```

## Reconciliation policy

The Argo CD Application uses automated sync and self-heal, creates the destination namespace when needed, and sets `prune: false`. This means changes in Git are reconciled, but resources removed from Git are not automatically deleted by pruning.

## Runtime dependencies

The chart assumes the EKS cluster, ECR images, storage class/EBS CSI support, required Kubernetes secrets, and (if ingress is enabled) the AWS Load Balancer Controller already exist. Those dependencies are created outside this repository.
