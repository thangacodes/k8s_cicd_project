# k8s_cicd_project:-
* This repository contains a Python script, an HTML file, a requirements.txt file, and a Dockerfile.
* This entire project will be implemented on Kubernetes clusters on AWS using Kops.

# The following uses cli to create a S3 bucket:-
* The instance on which you are executing kops commands needs to be associated with an admin role.
* Or we need to configure aws access_key and access_secret_key on the machine using 'aws configure'. To do so, we must install the AWScli tool on the machine.
# Because "aws configure" doesn't export these vars for kops to use, we export them now
* aws configure

* export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id)
  
* export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key)
  
* aws s3api create-bucket --bucket anvika-k8s-kops-store --region ap-south-1 --create-bucket-configuration LocationConstraint=ap-south-1
  
* aws s3 ls

* aws s3 ls cloudbird-k8s-kops-store
  
* aws s3api put-bucket-versioning --bucket anvika-kops-store --region ap-south-1 --versioning-configuration Status=Enabled
  
* export KOPS_STATE_STORE="s3://anvika-k8s-kops-store"
  
* export NAME="anvika.k8s.local"
  
* kops create cluster --name ${NAME} --zones ap-south-1a --master-size t2.large --node-size t2.large --kubernetes-version 1.27.0 --cloud aws
  
* kops get cluster
  
* kops edit cluster --name ${NAME}
  
* kops update cluster --name ${NAME} --yes
  
* kops validate cluster --name ${NAME}
