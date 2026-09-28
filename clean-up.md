1. Delete the node group:
aws eks delete-nodegroup \
  --cluster-name cicd-eks-cluster \
  --nodegroup-name ng-0f4b075e \
  --region ap-southeast-1 \
  --profile eks-admin

2. Wait until it is deleted:
aws eks wait nodegroup-deleted \
  --cluster-name cicd-eks-cluster \
  --nodegroup-name ng-0f4b075e \
  --region ap-southeast-1 \
  --profile eks-admin

3. Delete the cluster after the wait succeeds:
aws eks delete-cluster \
  --name cicd-eks-cluster \
  --region ap-southeast-1 \
  --profile eks-admin