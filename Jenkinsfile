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
                branch 'kubernetesonly'
            }
            steps {
                input 'Deploy to Production?'
                milestone(1)
                kubernetesDeploy(
                    kubeconfigId: 'kubeconfig',
                    configs: 'n.yml',
                    enableConfigSubstitution: true
                )
            }
        }
    }
}
