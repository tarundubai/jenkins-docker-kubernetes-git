pipeline {
  environment {
    registry = "biswasttt/nginx"
    registryCredential = 'docker_hub_login'
    dockerImage = ''  
  }
  agent any
  stages {
    stage('Cloning Git') {
      steps {
        script {
        sh "git clone https://github.com/tarundubai/jenkins-docker-kubernetes-git"
        }
      }
    }
    stage('Building image') {
      steps{
        script {
          dockerImage = docker.build registry + ":$BUILD_NUMBER"
        }
      }
    }
    stage('Push Image') {
      steps{
        script {
          docker.withRegistry( '', registryCredential ) {
            dockerImage.push()
          }
        }
      }
    }
        stage('DeployToProduction') {
            when {
                branch 'main'
            }
            steps {
                input 'Deploy to Production?'
                milestone(1)
                withCredentials([usernamePassword(credentialsId: 'webserver_login', usernameVariable: 'USERNAME', passwordVariable: 'USERPASS')]) {
                    script {
                        sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$prod_id \"docker pull biswasttt/nginx:${env.BUILD_NUMBER}\""
                        try {
                            sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$prod_id \"docker stop nginx\""
                            sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$prod_id \"docker rm nginx\""
                        } catch (err) {
                            echo: 'caught error: $err'
                        }
                        sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$prod_id \"docker run --restart always --name nginx -p 8080:80 -d biswasttt/nginx:${env.BUILD_NUMBER}\""
                    }
                }
            }
        }
    }
}
