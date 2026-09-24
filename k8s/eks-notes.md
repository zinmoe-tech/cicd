>>> Creater EKS cluster and config assess management and update kubeconfig

aws eks update-kubeconfig \
  --region us-east-1 \
  --name pipeline-project-cluster \
  --alias pipeline-project-cluster \
  --profile eks-admin

kubectl config get-contexts
kubectl config use-context pipeline-project-cluster
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