pipeline {
    agent any
    options {
        skipDefaultCheckout(true)
    }
    environment {
        VM_USER_IP = 'ubuntu@34.245.75.79'
        BUILD_INSTANCE_IP = 'ubuntu@52.215.236.247' 
    }
    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
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
                    \" cd /tmp/project && \\
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

                sh "scp -o StrictHostKeyChecking=no -i ${SSH_KEY} docker-compose.yml ${VM_USER_IP}:/tmp/docker-compose.yml"

                sh """
                    ssh -o StrictHostKeyChecking=no -i ${SSH_KEY} ${VM_USER_IP} \\
                    \"echo ${DOCKER_PASSWORD} | docker login --username ${DOCKER_USERNAME} --password-stdin && \\
                        docker pull aminehamdi2022/dockerapp:latest && \\
                        docker-compose -f /tmp/docker-compose.yml up -d\"
                """
            }
        }
    }
}

    }
}
