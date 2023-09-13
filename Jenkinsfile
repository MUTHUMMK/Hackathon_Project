pipeline {
    agent any 
    
    
    environment {
        AWS_ACCESS_KEY_ID =  credentials ('accesskey')
        AWS_SECRET_ACCESS_KEY  =  credentials ('secretkey')
        DOCKERHUBUSER = credentials ('dockerhubuser')
        DOCKERHUBPSW =  credentials ('dockerhubpsw')
    }

    stages {
        stage('Hello') {
            steps {
                echo "hello"
                git branch: 'main', url: 'https://github.com/MUTHUMMK/CAPSTONE-node.js.git'
            }
        }
        stage('build') {
            steps {
                script {
                    sh """
                    cd build
                    sh build.sh
                    """
                }
            }
        }
        stage('push') {
            steps {
                script {
                    sh """
                    cd push
                    sh push.sh
                    """
                }
            }
        }
        stage('create') {
            steps {
                script {
                    withCredentials([sshUserPrivateKey(credentialsId: 'SSHID', keyFileVariable: 'SSH_KEY', usernameVariable: 'ubuntu')]) {
                    sh """
                    cd create
                    sh create.sh
                    """
}

                    
                }
            }
        }
        stage('deploy') {
            steps {
                script {
                    withCredentials([sshUserPrivateKey(credentialsId: 'SSHID', keyFileVariable: 'SSH_KEY', usernameVariable: 'ubuntu')]) {
                    sh """
                    cd deploy
                    sh deploy.sh
                    """
}

                    
                }
            }
        }
        stage('monitor') {
            steps {
                script {
                    withCredentials([sshUserPrivateKey(credentialsId: 'SSHID', keyFileVariable: 'SSH_KEY', usernameVariable: 'ubuntu')]) {
                    sh """
                    cd monitor
                    sh monitor.sh
                    """
}

                    
                }
            }
        }

}
        post {
        success {
            mail bcc: '', body: 'All the stages in the pipeline has been completed, check in the jenkins master for the logs', cc: '', from: '', replyTo: '', subject: 'react app pipeline completed', to: 'mmkak7899@gmail.com'
        }


    }
}