This is project phase-2 frame work.

             GitHub → ECR → Amazon EKS

Developer
    │
    │ git push
    ▼
┌─────────────────────────┐
│        GitHub           │
└────────────┬────────────┘
             │
             ▼
┌─────────────────────────┐
│     GitHub Actions      │
│                         │
│  1. Checkout            │
│  2. Install packages    │
│  3. pytest              │
│  4. Docker build        │
└────────────┬────────────┘
             │
             │ OIDC
             ▼
┌─────────────────────────┐
│        AWS STS          │
│    Temporary creds      │
└────────────┬────────────┘
             │
             ▼
┌─────────────────────────┐
│       Amazon ECR        │
│                         │
│ cicd-python-app         │
│ :<github-sha>           │
└────────────┬────────────┘
             │
             │ pull image
             ▼
┌─────────────────────────┐
│       Amazon EKS        │
│                         │
│   Kubernetes Cluster    │
│                         │
│   ┌─────────────────┐   │
│   │   Deployment    │   │
│   │                 │   │
│   │ Pod      Pod    │   │
│   └─────────────────┘   │
│           │             │
│       Service           │
└───────────┬─────────────┘
            │
            ▼
          User

>>> Step - 1 : Modify code to get the below result

If we call GET /, return: Hello from Zin Moe CI/CD Project!

If we call GET /health, return: {
  "status": "healthy"
}

Create k8s folder and create deployment.yaml and service.yaml.

Deploy deployment.yaml manually and verify.

kubectl get deployments
kubectl get replicasets
kubectl get pods
