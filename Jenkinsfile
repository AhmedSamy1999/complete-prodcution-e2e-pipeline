pipeline{
    agent {
        label "jenkins-agent"
    }
    tools {
        jdk 'Java17'
        maven 'Maven3'
    }

    
    
    environment {

        APP_NAME = "complete-prodcution-e2e-pipeline"
        RELEASE = "0.0.1"
        DOCKER_USER = "samycloud"
        DOCKER_PASS = 'dockerhub'
        IMAGE_NAME = "${DOCKER_USER}" + "/" + "${APP_NAME}"
        IMAGE_TAG = "${RELEASE}-${BUILD_NUMBER}"
    } 




    stages {
        stage("Cleanup Workspace") {
            steps {
                script {
                    cleanWs()
                }
            }
        }

        stage("Checkout Code") {
            steps {
                script {
                    git branch: 'main', credentialsId: 'github', url: 'https://github.com/AhmedSamy1999/complete-prodcution-e2e-pipeline'
                }
            }        
        }

        stage("Build Application") {
            steps {
                script {
                    sh "mvn clean package"
                }
            }        
        }

        stage("Test Application") {
            steps {
                script {
                    sh "mvn test"
                }
            }        
        }

        stage("Static Code Analysis") {
            steps {
                script {
                    withSonarQubeEnv(credentialsId: 'jenkins-sonarqube-token') {
                        sh "mvn sonar:sonar"
                    }
                }
            }        
        }

        stage("Quality Gate") {
            steps {
                script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'jenkins-sonarqube-token'
                }
            }        
        }

        stage("Docker Build & Push") {
            steps {
                script {
                    // Docker Build
                    docker.withRegistry('',DOCKER_PASS) {
                    docker_image = docker.build "${IMAGE_NAME}"
                    }
                    // Docker Push
                    docker.withRegistry('',DOCKER_PASS) {
                    docker_image.push("$IMAGE_TAG")
                    docker_image.push('latest')
                    }
                }
            }        
        }

       
    }
}