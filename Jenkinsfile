pipeline {
    agent any
    options {
        skipDefaultCheckout(true)
    }
    environment {
        VM_USER_IP = 'ubuntu@34.245.75.79'
    }
    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }
        stage('Dockerize') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'registy', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        //sh 'docker rmi -f aminehamdi2022/dockerapp:latest || true'
                        sh 'docker build -t aminehamdi2022/dockerapp:latest .'

                        sh 'echo $DOCKER_PASSWORD | docker login --username $DOCKER_USERNAME --password-stdin'

                        // Push the new Docker image
                        sh 'docker push aminehamdi2022/dockerapp:latest'
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
                            ssh -o StrictHostKeyChecking=no -i ${SSH_KEY}  ${VM_USER_IP}
                            "docker stop $(docker ps -q --filter ancestor=aminehamdi2022/dockerapp:latest) || true && \
                             docker rm $(docker ps -a -q --filter ancestor=aminehamdi2022/dockerapp:latest) || true && \
                             echo $DOCKER_PASSWORD | docker login --username $DOCKER_USERNAME --password-stdin && \
                             docker pull aminehamdi2022/dockerapp:latest && \
                             docker run -p 3000:3000 -d aminehamdi2022/dockerapp:latest"
                        """
                    }
                }
            }
        }
    }
}
