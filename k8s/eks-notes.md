>>> Creater EKS cluster and config assess management and update kubeconfig

eksctl create cluster \
  --name cicd-eks-cluster \
  --region ap-southeast-1 \
  --version 1.34 \
  --instance-types t3.medium \
  --nodes-min 2 \
  --profile eks-admin

aws eks update-kubeconfig \
  --region ap-southeast-1 \
  --name cicd-eks-cluster \
  --alias cicd-eks-cluster \
  --profile eks-admin

kubectl config get-contexts
kubectl config use-context arn:aws:eks:ap-southeast-1:691914216603:cluster/cicd-eks-cluster
kubectl get nodes

Check your EKS node groups:

aws eks list-nodegroups \
  --region us-east-1 \
  --cluster-name pipeline-project-cluster \
  --profile eks-admin

If it returns:
{
  "nodegroups": []
}

arn:aws:eks:us-east-1:691914216603:cluster/pipeline-project-cluster