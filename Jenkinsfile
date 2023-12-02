pipeline {
    agent any
    options {
        skipDefaultCheckout(true)
    }

    environment {
        VM_USER_IP = 'ubuntu@34.245.75.79'   
    }
    stages {
        stage('Dockerizee') {
            }
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'registry', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh 'docker build -t aminehamdi2022/dockerapp:latest .'
                        sh 'echo $DOCKER_PASSWORD | docker login --username $DOCKER_USERNAME --password-stdin'
                        sh 'docker push aminehamdi2001/devopsworkshop:latest'
                    }
                }
            }
        }

        stage('Deploy to Vm') {
            steps {
                script {
                    withCredentials([sshUserPrivateKey(credentialsId: 'vmCredentials', keyFileVariable: 'SSH_KEY')]) {
                        sh 'chmod 400 $SSH_KEY'
                        sh """
                            ssh -o StrictHostKeyChecking=no -i ${SSH_KEY} ${VM_USER_IP} \
                            "sudo docker pull aminehamdi2001/dockerapp:latest && \
                            sudo docker run -p 3000:3000 -d aminehamdi2001/devopsworkshop:1"
                        """
                    }
                }
            }
        }
    }
}
//hreqsdqdfsd