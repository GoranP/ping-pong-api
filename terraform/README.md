# Build AWS VPC and Kubernetes cluster (EKS)


## Prerequisites 
- Setup [AWS account](https://docs.aws.amazon.com/SetUp/latest/UserGuide/setup-AWSsignup.html)
- On build machine install [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- Setup [access](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-quickstart.html) 
- Install latest [Terraform](https://developer.hashicorp.com/terraform/install)
- Install [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)  

Alternativley for Demo to speedup process you can temporary export two AWS variables that you obtain from AWS account 
``` 
export AWS_ACCESS_KEY_ID=AWS_ACCESS_KEY 
export AWS_SECRET_ACCESS_KEY=SECRET_ACCESS_KEY
```

## Terraform 

Terraform code in this repo vill create
- VPC in region eu-west-2
- private and public subnets in two availability zones
- NAT gateway
- Kubernetes cluster

In the root of the project run:
```
terraform init
terraform plan
terraform apply
```
 
 Assuming provided AWS key and secret have rights to create objects on AWS, and after several minutes - VPC and Kubernetes cluster should be created on AWS.
 
 ### Setup kubernetes config file to access the cluster
 
 ```
 aws sts get-caller-identity
 aws eks update-kubeconfig --region eu-west-2 --name ping-pong-cluster
```


Verify that kubctl is having access:
```
kubectl get nodes
```
Result should be similar to this:
```
NAME                                       STATUS   ROLES    AGE    VERSION
ip-10-0-1-10.eu-west-2.compute.internal    Ready    <none>   168m   v1.29.3-eks-ae9a62a
ip-10-0-2-145.eu-west-2.compute.internal   Ready    <none>   168m   v1.29.3-eks-ae9a62a
```

 ### Install NGINX ingress controller
 We need ingress controller for future deployments and to open services to the internet
 
 ```
 kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.10.1/deploy/static/provider/cloud/deploy.yaml
 ```
 