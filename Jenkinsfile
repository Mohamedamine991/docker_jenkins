pipeline {
    agent any
    options {
        skipDefaultCheckout(true)
    }
    environment {
        VM_USER_IP = 'ubuntu@34.255.208.2'
        BUILD_INSTANCE_IP = 'ubuntu@34.255.208.62' 
        Dashboard_IP = 'ubuntu@54.217.48.68'
    }
    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }
        stage('Get Commit ID') {
            when {
        expression { env.CHANGE_ID != null }
    }
    steps {
        script {
            env.GIT_COMMIT = sh(script: 'git rev-parse HEAD', returnStdout: true).trim()
        }
    }
}
        stage('Dockerize') {
    when {
        expression { env.CHANGE_ID != null }
    }
    steps {
        script {
            withCredentials([sshUserPrivateKey(credentialsId: 'build_instance', keyFileVariable: 'SSH_KEY_BUILD'), 
                             usernamePassword(credentialsId: 'registy', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD'),
                             usernamePassword(credentialsId: 'github_token', usernameVariable: 'DUMMY_USER', passwordVariable: 'GITHUB_TOKEN'),]) {
                sh 'chmod 400 $SSH_KEY_BUILD'
                sh """
                    ssh -o StrictHostKeyChecking=no -i $SSH_KEY_BUILD $BUILD_INSTANCE_IP \\
                    \" cd /home/ubuntu/dashboard_test/ && \\
                       git pull origin devbranch && \\
                       echo ${DOCKER_PASSWORD} | docker login --username ${DOCKER_USERNAME} --password-stdin && \\
                       docker build -t aminehamdi2022/dockerapp:latest . && \\
                       docker push aminehamdi2022/dockerapp:latest
                    \"
                """
            }
        }
    }
}


        stage('Deploy to Vm') {
    when {
        expression { env.CHANGE_ID != null }
    }
    steps {
        script {
            withCredentials([sshUserPrivateKey(credentialsId: 'vmCredentials', keyFileVariable: 'SSH_KEY'), usernamePassword(credentialsId: 'registy', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                sh 'chmod 400 $SSH_KEY'


                sh """
                    ssh -o StrictHostKeyChecking=no -i ${SSH_KEY} ${VM_USER_IP} \\
                   \"  echo ${DOCKER_PASSWORD} | docker login --username ${DOCKER_USERNAME} --password-stdin && \\
                       docker pull aminehamdi2022/dockerapp:${env.GIT_COMMIT} && \\
                       docker compose -f /tmp/docker-compose.yml up -d --build\"
"""

            }
        }
    }
}
stage('Update VM File') {
            steps {
                
                    script {
                        withCredentials([sshUserPrivateKey(credentialsId: 'dashboard', keyFileVariable: 'SSH_KEY')]){
                        sh "ssh -o StrictHostKeyChecking=no -i ${SSH_KEY} ${Dashboard_IP} 'echo http://34.255.208.62:8080 >> /home/ubuntu/express_server/express-commit/file.txt'"
                    }}
                
            }
        }
    }
}