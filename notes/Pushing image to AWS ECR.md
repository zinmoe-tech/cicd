# Push docker image to AWS ECR

Developer
   ↓
GitHub
   ↓
GitHub Actions
   ↓
pytest
   ↓
docker build
   ↓
Authenticate to AWS
   ↓
Amazon ECR
   ↓
Push Docker image

This is important because right now your image exists only inside the temporary GitHub runner. When the job finishes, that runner disappears.

ECR gives us a permanent registry where the image can be stored and later pulled by EKS.

We need to know the below steps.

Amazon ECR repository
AWS authentication from GitHub Actions
IAM permissions
GitHub OIDC
docker login
docker tag
docker push

In this case, we will use GitHub OIDC to AWS production-style way of authenticating CI pipelines, not long-lived AWS access keys.

>>> Step 1 — Create an ECR repository
In AWS Console:
AWS Console
→ ECR
→ Private registry
→ Repositories
→ Create repository

Repository name: cicd-python-app
After creation, we should have URL based on region.

691914216603.dkr.ecr.us-east-1.amazonaws.com/cicd-python-app

>>> Step 2 — Create GitHub OIDC provider in AWS
AWS Console
→ IAM
→ Identity providers
→ Add provider

Choose: Provider type> OpenID Connect
        Provider URL:> https://token.actions.githubusercontent.com
Audience: sts.amazonaws.com

The above config said GitHub Actions is allowed to request temporary AWS credentials.

>>> Step 3 — Create IAM role for GitHub Actions
IAM
→ Roles
→ Create role

Choose: Web identity
Select: token.actions.githubusercontent.com
Audience: sts.amazonaws.com

For GitHub organization/repository restrictions, we want the trust policy to allow only our repository. 

For Role: 

Identity provider: token.actions.githubusercontent.com
Audience: sts.amazonaws.com
GitHub organization: zinmoe-tech
GitHub repository: cicd
GitHub branch: main

GitHub owner:
zinmoe-tech

Owner ID:
210xxxxxx

Repository:
cicd

Repository ID:
138xxxxxx

Branch:
main

Create inline policy : 

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
    }
  ]
}

This is trust relationship:

{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::691914216603:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com",
          "token.actions.githubusercontent.com:sub": "repo:zinmoe-tech@210xxxxxx/cicd@138xxxxxxx:ref:refs/heads/main"
        }
      }
    }
  ]
}

>>> Step 5 — Copy the IAM role ARN and Add repository variables to GitHub

In GitHub:
Repository
→ Settings
→ Secrets and variables
→ Actions

Under Variables, add:
AWS_REGION : us-east-1
ECR_REPOSITORY: cicd-python-app
AWS_ROLE_ARN

>>> Step 6 — Update your workflow permissions

GitHub Actions needs permission to request an OIDC token.
Add permission between "on" and "job" in ci.yaml:
permissions:
  id-token: write
  contents: read

Allows GitHub Actions to request an OIDC token for AWS login.
Allows the workflow to read your repository code, needed by actions/checkout.

>>> Step 7 — Understand each AWS step does

uses: aws-actions/configure-aws-credentials@v4
It uses GitHub's OIDC token to request temporary AWS credentials.
Concept : 
GitHub Actions
   ↓
OIDC token
   ↓
AWS STS
   ↓
Assume IAM role
   ↓
Temporary credentials

AWS STS means: AWS Security Token Service and  those credentials are temporary.
This is much safer than storing AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY in GitHub.

>>> Step 8 — ECR login

logs Docker into your ECR registry.
uses: aws-actions/amazon-ecr-login@v2

Flows:
AWS authenticated
   ↓
Get ECR authorization
   ↓
docker login
   ↓
Runner can push images

>>> Step 9 — Image tagging
IMAGE_TAG: ${{ github.sha }}

>>> Step 10 — Commit and push
git add .github/workflows/ci.yml
git commit -m "Push Docker image to Amazon ECR using OIDC"
git push

There are two different “tokens” in this GitHub → AWS OIDC flow, so it helps to separate them:

GitHub OIDC JWT — issued by GitHub to the workflow.
AWS STS session token — returned by AWS after AssumeRoleWithWebIdentity succeeds, together with a temporary access key ID and secret access key. AWS documents that exchange explicitly.