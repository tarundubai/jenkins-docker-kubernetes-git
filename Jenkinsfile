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
          dockerImage = docker.build registry + "_$BUILD_NUMBER"
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
        sh "docker rmi $registry:_$BUILD_NUMBER"
      }
    }
  }
}
