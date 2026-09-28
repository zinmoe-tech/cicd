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
  --region us-east-1 \
  --profile eks-admin

Associate an EKS access policy:
aws eks associate-access-policy \
  --cluster-name cicd-eks-cluster \
  --principal-arn arn:aws:iam::691914216603:role/for-github-role \
  --policy-arn arn:aws:eks::aws:cluster-access-policy/AmazonEKSEditPolicy \
  --access-scope type=namespace,namespaces=default \
  --region us-east-1 \
  --profile eks-admin

Verify:
aws eks list-access-entries \
  --cluster-name cicd-eks-cluster \
  --region us-east-1 \
  --profile eks-admin

## Troubleshoot "You must be logged in to the server"

The workflow connects to `cicd-eks-cluster` in `us-east-1`. Access entries
must exist on that cluster. Entries in `ap-southeast-1` do not apply.
`eks:DescribeCluster` permits kubeconfig creation but does not grant Kubernetes access.

Before running the access commands above:

1. Confirm the principal ARN exactly matches the repository variable
   `AWS_ROLE_ARN`. Replace the example `for-github-role` ARN if needed. Use the
   IAM role ARN, not the STS assumed-role session ARN shown in the identity log.
2. Check the cluster authentication mode using the administrator profile:

   ```bash
   aws eks describe-cluster \
     --name cicd-eks-cluster --region us-east-1 --profile eks-admin \
     --query 'cluster.accessConfig.authenticationMode'
   ```

3. Only if the mode is `CONFIG_MAP`, enable access entries while preserving
   existing mappings. Enabling access entries cannot be reversed:

   ```bash
   aws eks update-cluster-config \
     --name cicd-eks-cluster --region us-east-1 --profile eks-admin \
     --access-config authenticationMode=API_AND_CONFIG_MAP
   aws eks wait cluster-active \
     --name cicd-eks-cluster --region us-east-1 --profile eks-admin
   ```

4. Run `list-access-entries` above first. Create the entry only if the role is
   missing, then associate `AmazonEKSEditPolicy` with the `default` namespace.
   Run these setup commands as `eks-admin` outside the deployment workflow.
5. Allow a short time for access changes to propagate, then rerun the workflow.
   Its connection check lists deployments in `default`. Namespace access does
   not permit listing nodes or deployments across all namespaces.

AWS documentation: https://docs.aws.amazon.com/eks/latest/userguide/access-entries.html
