pipeline {
    agent {
    dockerfile {
        filename 'Dockerfile'
        dir 'build'
        label 'my-defined-label'
        registryUrl 'https://hub.docker.com/repositories'
        registryCredentialsId 'docker_hub_login'
    }
}
}
