pipeline {
    agent any
    options {
        skipDefaultCheckout(true)
    }
//zdfzfddd
    environment {
        VM_USER_IP = 'ubuntu@34.245.75.79'   
    }
        stages {
        stage('Checkout Code') {
            steps {
                // Check out from a Git repositorysds
                checkout scm
                
            }
        }
        stage('Dockerize') {
    steps {
        script {
            withCredentials([usernamePassword(credentialsId: 'registy', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                sh ' docker build -t aminehamdi2022/dockerapp:latest .'
                sh ' echo $DOCKER_PASSWORD |docker login --username $DOCKER_USERNAME --password-stdin'
                sh ' docker push aminehamdi2022/dockerapp:latest'
            }
        }
    }
}
        stage('Deploy to Vm') {
            
            steps {
                script {
                    withCredentials([sshUserPrivateKey(credentialsId: 'vmCredentials', keyFileVariable: 'SSH_KEY'), usernamePassword(credentialsId: 'registy', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh 'chmod 400 $SSH_KEY'
                        sh """
                            ssh -o StrictHostKeyChecking=no -i ${SSH_KEY} ${VM_USER_IP} \
                            "echo $DOCKER_PASSWORD |docker login --username $DOCKER_USERNAME --password-stdin && \
                             docker pull aminehamdi2022/dockerapp:latest && \
                             docker run -p 3000:3000 -d aminehamdi2022/dockerapp:latest "
                        """
                    }
                }
                
            }
        }
    }
}
