pipeline {
    agent any
    options {
        skipDefaultCheckout(true)
    }

    environment {
        VM_USER_IP = 'ubuntu@34.245.75.79'   
    }
    
    
        stages {

            when {
        allOf {
            changeRequest()
            expression { env.CHANGE_TARGET == 'main' }
        }
    }
        stage('Checkout Code') {
            steps {
                // Check out from a Git repositorysds
                checkout scm
            }
        }
        stage('Dockerize') {
    steps {
        script {
            // Optionally add a step to print the current directory and contents
            sh 'pwd'
            sh 'ls -la'

            withCredentials([usernamePassword(credentialsId: 'registy', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                // Ensure you're in the right directory where Dockerfile is located
                //sh ' docker build -t aminehamdi2022/dockerapp:latest .'
                sh ' echo $DOCKER_PASSWORD |docker login --username $DOCKER_USERNAME --password-stdin'
                //sh ' docker push aminehamdi2022/dockerapp:latest'
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
