pipeline {
    agent any 
    
    
    environment {
        AWS_ACCESS_KEY_ID =  credentials ('accesskey')
        AWS_SECRET_ACCESS_KEY  =  credentials ('secretkey')
        DOCKERHUBUSER = credentials ('dockerhubuser')
        DOCKERHUBPSW =  credentials ('dockerhubpsw')
        SERVERKEY = credentials ('server')
    }

    stages {
        stage('git_checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/MUTHUMMK/demo_tf.git'
            }
        }
        stage('build') {
            steps {
                script {
                    sh """
                    cd shoestop
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
                    sh """
                    cd create_infra
                    sh config_infra.sh
                    """
                }
            }
        }
        
        stage('deployment') {
            steps {
                script {
                    sh """
                    cd ansible
                    sh ansible.sh
                    ansible-playbook -i inventory.txt --private-key=$SERVERKEY playbook.yml
                    """
                    /*sh """ 
                    cd ansible
                    sh ansible.sh
                    ansiblePlaybook credentialsId: 'server_key', disableHostKeyChecking: true, installation: 'ansible2', inventory: 'ansible/inventory.txt', playbook: 'ansible/playbook.yml'
                    """
                    */
                }
            }
        }
        

    }
}
