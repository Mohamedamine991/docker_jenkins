pipeline {
    agent any

    environment {
        SSH_CREDENTIALS = 'vmCredentials' // The ID of your SSH credentials stored in Jenkins
        SERVER_USER_IP = 'ubuntu@34.245.75.79' // The username and IP address of your VM
        PROJECT_DIR = '/tmp/react' // Directory path on the server where you want to copy your project
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

       stage('Copy Project to Server') {
    steps {
        script {
            withCredentials([sshUserPrivateKey(credentialsId: 'vmCredentials', keyFileVariable: 'SSH_KEY')]) {
                // Use the SSH_KEY variable directly without Groovy interpolation
                sh "scp -o StrictHostKeyChecking=no -i ${SSH_KEY} -r ./* ubuntu@34.245.75.79:${PROJECT_DIR}"
            }
        }
    }
}


        stage('Install and Start Application') {
            steps {
                script {
                    withCredentials([sshUserPrivateKey(credentialsId: 'vmCredentials', keyFileVariable: 'SSH_KEY')]) {
                        // Run npm install and npm start commands on the server
                        sh """
                            ssh -o StrictHostKeyChecking=no -i ${SSH_KEY} ${SERVER_USER_IP} '
                                cd ${PROJECT_DIR} &&
                                npm install &&
                                nohup npm run start &
                            '
                        """
                    }
                }
            }
        }
    }
}
