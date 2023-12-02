pipeline {
    agent any

    environment {
        // Assuming you have already stored the SSH credentials in Jenkins
        SSH_CREDENTIALS = 'vmCredentials'
        SERVER_USER = 'ubuntu' // Your server's SSH username
        SERVER_IP = '34.245.75.79' // Your server's IP address
        PROJECT_DIR = '/tmp/react/' // Directory path on the server
    }

    stages {
        

        stage('Copy Project to Server') {
            steps {
                script {
                    withCredentials([sshUserPrivateKey(credentialsId: 'vmCredentials', keyFileVariable: 'SSH_KEY')]) {
                        // Rsync project to server, excluding node_modules
                        sh "rsync -avz -e 'ssh -o StrictHostKeyChecking=no -i ${SSH_KEY}' --exclude='node_modules/' ./ ${SERVER_USER}@${SERVER_IP}:${PROJECT_DIR}"
                    }
                }
            }
        }

        stage('Install and Start Application') {
            steps {
                script {
                    withCredentials([sshUserPrivateKey(credentialsId: SSH_CREDENTIALS, keyFileVariable: 'SSH_KEY')]) {
                        // Run npm install and npm start commands on the server
                        sh """
                            ssh -o StrictHostKeyChecking=no -i ${SSH_KEY} ${SERVER_USER}@${SERVER_IP} << EOF
                                cd ${PROJECT_DIR}
                                npm install
                                npm run start
                            EOF
                        """
                    }
                }
            }
        }
    }
}
