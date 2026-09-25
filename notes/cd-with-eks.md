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

According curret policy, GitHub Actions can push images to ECR, but it does not yet have the AWS-side permission needed to talk to EKS.

We need to use the below policy.


{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:CompleteLayerUpload",
        "ecr:InitiateLayerUpload",
        "ecr:PutImage",
        "ecr:UploadLayerPart"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "eks:DescribeCluster",
        "eks:ListClusters"
      ],
      "Resource": "*"
    }
  ]
}

Now we are planning to implement to deploy yaml to EKS when we change code and push. In this case, we require to grant eks cluster to apply deployment and service access to "for-github-role".
Create access entry in EKs:

aws eks create-access-entry \
  --cluster-name cicd-eks-cluster \
  --principal-arn arn:aws:iam::691914216603:role/for-github-role \
  --type STANDARD \
  --region ap-southeast-1 \
  --profile eks-admin

Associate an EKS access policy:
aws eks associate-access-policy \
  --cluster-name cicd-eks-cluster \
  --principal-arn arn:aws:iam::691914216603:role/for-github-role \
  --policy-arn arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy \
  --access-scope type=cluster \
  --region ap-southeast-1 \
  --profile eks-admin

Verify:
aws eks list-access-entries \
  --cluster-name cicd-eks-cluster \
  --region ap-southeast-1 \
  --profile eks-admin