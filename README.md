Setting Up Jenkins pipeline for Kubernetes deployment:

```bash
Step 1: Create Ubuntu EC2 & Install the Jenkins Server
AMI ID: Ubuntu 24.04 (ami-0f58b397bc5c1f2e8)
Instance Spec: t2.medium
Ingress_rule: Allowed all TCP ports

## Update all software packages on Ubuntu server
$ sudo su - root     // Switch user to root
$ apt-get update    // Downloads the index files
$ apt-get upgrade  // Upgrade downloads the latest versions packages of the installed packages.

## Install Java on Ubuntu server:
$ sudo apt-get install default-jdk 
$ java -version

## Jenkins Installation
Install Jenkins on Ubuntu server using given Link below,
$ https://www.jenkins.io/doc/book/installing/linux/#debianubuntu 
# Access Jenkins Url with Public ip on port 8080
$ sudo cat /var/lib/jenkins/secrets/initialAdminPassword 

Install the Suggested Plugins 
Setup UserName and Password

## Step 2: Get to know about Python Code and Create GitHub Repo
## Developer Actions:

## Create a Empty Github Repository 
$ sudo su - root      // Switch to root user
$ mkdir Code         // Create directory name called Code
$ cd Code           // Navigate to the directory Code and create the files
$ touch main.py pod.yaml requirements.txt Dockerfile aws.html
## Push to files to Github
$ git init 
$ git add . 
$ git commit -m "First commit" 
$ git remote add origin https://github.com/thangacodes/k8s_cicd_project.git 
$ git push origin master 
Generate a access Classic token from the GitHub Repo Settings

## Step 3: Create a Jenkins Pipeline Job And clone the Repo
Create a Pipeline Job >> Job Name called "cicd"
Install Stageview plugin from manageJenkins -> Plugins -> Available plugins

pipeline { 
    agent any 
    stages { 
        stage('Pull Code From GitHub') { 
            steps { git 'https://github.com/thangacodes/k8s_cicd_project.git' } 
        }
    } 
}

## Step 4: Containerize the Python app and publish to DockerHub
Docker Installation
$ sudo apt install docker.io 
Open DockerHub account 
$ https://login.docker.com/
$ docker login
Give Jenkins Permission to run sudo commands
$ vi /etc/sudoers 
$ jenkins ALL=(ALL) NOPASSWD: ALL 
$ exit 
$ sudo su - root           //Switch user to root

# Run the three stages in Jenkinsfile
pipeline { agent any

stages {
    stage('Code Clone') {
        steps {
            git 'https://github.com/thangacodes/k8s_cicd_project.git'
        }
    }
    stage('Build the Docker image') {
        steps {
            sh 'sudo docker build -t staticimage /var/lib/jenkins/workspace/cicd'
            sh 'sudo docker tag staticimage durai5050/staticimage:latest'
            sh 'sudo docker tag weekendimage durai5050/staticimage:${BUILD_NUMBER}'
        }
    }
    stage('Push the Docker image') {
        steps {
            sh 'sudo docker image push durai5050/staticimage:latest'
            sh 'sudo docker image push durai5050/staticimage:${BUILD_NUMBER}'
        }
    }
}
}

# Step 5: Create Kubernetes Cluster

# Install Kops
$ curl -Lo kops https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
$ chmod +x kops
$ sudo mv kops /usr/local/bin/kops

# Install kubectl
$ curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl 
$ chmod +x ./kubectl 
$ sudo mv ./kubectl /usr/local/bin/kubectl

# AWS CLI Installation

$ curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" 
$ sudo apt install unzip 
$ unzip awscliv2.zip 
$ sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update 

Create IAM user with Admin access policy and generate IAM access & Secret Key aws configure aws s3 ls
# Generate Keys
$ ssh-keygen

# Set Env Variables for Kops
export AWS_ACCESS_KEY_ID= ""
export AWS_SECRET_ACCESS_KEY= "" 
export NAME=anvi.k8s.local 
export KOPS_STATE_STORE=s3://kops22042022

# Create Kubernetes Cluster
kops create cluster --zones ap-south-1a ${NAME} kops update cluster --name ${NAME} --yes --admin

# Step 6: Deploy to kubernetes
Add a new stage in Jenkins file

pipeline { 
agent any
stages {
    stage('Code Clone') {
        steps {
            git 'https://github.com/thangacodes/k8s_cicd_project.git'
        }
    }
    stage('Build DockerImage') {
        steps {
            sh 'sudo docker build -t staticimage /var/lib/jenkins/workspace/cicd'
            sh 'sudo docker tag staticimage durai5050/staticimage:latest'
            sh 'sudo docker tag weekendimage durai5050/staticimage:${BUILD_NUMBER}'
        }
    }
    stage('Push DockerImage') {
        steps {
            sh 'sudo docker image push durai5050/staticimage:latest'
            sh 'sudo docker image push durai5050/staticimage:${BUILD_NUMBER}'
        }
    }
    stage('Deploy On K8Cluster') {
        steps {
            sh 'sudo kubectl apply -f /var/lib/jenkins/workspace/cicd/pod.yaml'
            sh 'sudo kubectl rollout restart deployment loadbalancer-pod'
        }
    }
}
}

# Configure Webhook in github & Jenkins
Github Repo Setting -> Webhooks -> http://x.y.z.a:8080/github-webhook/ 
Jenkins Job -> Build Triggers -> GitHub hook trigger for GITSCM polling

# Make a Commit & Run the Deployment
make changes in the pod.yaml for correct image name 

$ git -am commit "Test Run" 
$ git push origin master 

# Check Deployment in Kubernetes cluster
$ kubectl get pods --all-namespaces 
