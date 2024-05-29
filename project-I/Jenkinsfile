pipeline {
    agent any

    stages {
        stage('Code Cloning') {
            steps {
                echo 'Code cloning will be happen shortly'
                git branch: 'main', url: 'https://github.com/thangacodes/k8s_cicd_project.git'
            }
        }
        stage('Build Docker Image'){
            steps{
                sh 'docker build -t durai5050/pythonapp1:latest /var/lib/jenkins/workspace/k8scicd'
                sh 'docker tag durai5050/pythonapp1:latest durai5050/pythonapp1:${BUILD_NUMBER}'
                sh 'docker images'
            }
        }
        stage('Push Docker Image to DockerHub'){
            steps{
                withCredentials([usernamePassword(credentialsId: 'docker_cred', passwordVariable: 'docker_credPassword', usernameVariable: 'docker_credUsername')]){
                    sh "docker login -u ${env.docker_credUsername} -p ${env.docker_credPassword}"
                    sh 'docker image push durai5050/pythonapp1:latest'
                    sh 'docker image push durai5050/pythonapp1:${BUILD_NUMBER}'
                }
            }
        }
        stage('Deploy on Kubernetes'){
            steps{
                sh 'kubectl apply -f /var/lib/jenkins/workspace/k8scicd/pod.yml'
                sh 'kubectl rollout restart deployment loadbalancer-pod'
            }
        }
        stage('CleanWorkspace'){
            steps{
                cleanWs()
            }
        }
    }
}
