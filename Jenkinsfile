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
          dockerImage= `sh docker build -t biswasttt/nginx + ":$BUILD_NUMBER"`        
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
    stage('Remove Unused docker image') {
      steps{
        sh "docker rmi $registry:$BUILD_NUMBER"
      }
    }
  }
}
