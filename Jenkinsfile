pipeline {
    agent any
    environment {
        DOCKER_IMAGE_NAME = "kv1995/train-schedule"
    }
    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    app = docker.build(DOCKER_IMAGE_NAME)
                    app.inside {
                        sh 'echo Hello, World!'
                    }
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'docker_hub_login') {
                        app.push("${env.BUILD_NUMBER}")
                        app.push("latest")
                       }
                }
            }
        }
        stage('DeployToProduction') {
            steps {
                input 'Deploy to Development Environment?'
                milestone(1)
                kubernetesDeploy(
                    credentialsType: 'KubeConfig',
                    kubeConfig: [path: '/var/lib/jenkins/workspace/.kube/config'],
                    configs: 'train-schedule-kube.yml',
                    enableConfigSubstitution: true
                )
            }
        }
    }
}
