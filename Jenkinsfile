pipeline {
    agent any

    stages {
        stage('Clone') {
            steps {
                echo 'Code cloning will be happen shortly'
                git branch: 'main', url: 'https://github.com/thangacodes/k8s_cicd_project.git'
            }
        }
        stage('Image Build'){
            steps{
                sh 'docker build -t durai5050/kubeproject5:latest /var/lib/jenkins/workspace/k8scicd'
                sh 'docker tag durai5050/kubeproject5:latest durai5050/kubeproject5:${BUILD_NUMBER}'
                sh 'docker images'
            }
        }
        stage('Push Image to DockerHub'){
            steps{
                withCredentials([usernamePassword(credentialsId: 'docker_cred', passwordVariable: 'docker_credPassword', usernameVariable: 'docker_credUsername')]){
                    sh "docker login -u ${env.docker_credUsername} -p ${env.docker_credPassword}"
                    sh 'docker image push durai5050/kubeproject5:latest'
                    sh 'docker image push durai5050/kubeproject5:${BUILD_NUMBER}'
                }
            }
        }
        stage('CleanWorkspace'){
            steps{
                cleanWs()
            }
        }
    }
}
