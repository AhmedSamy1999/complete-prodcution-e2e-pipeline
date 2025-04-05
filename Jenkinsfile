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
        APP_NAME = "complete-production-e2e-pipeline"
        JENKINS_API_TOKEN= credentials("JENKINS_API_TOKENS")
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
            // Docker Build with network=host
            sh "docker build --network=host -t ${IMAGE_NAME}:${IMAGE_TAG} ."

            // Login to DockerHub and push
            docker.withRegistry('', DOCKER_PASS) {
                def docker_image = docker.image("${IMAGE_NAME}:${IMAGE_TAG}")
                docker_image.push()
                docker_image.push("latest")
            }
            }
            }        
        }



        stage("Quality Gate") {
            steps {
                script {
                    sh "curl -v -k --user admin:${JENKINS_API_TOKEN} -X POST -H 'cache-control: no-cache' -H 'content-type: application/x-www-form-urlencoded' --data 'IMAGE_TAG=${IMAGE_TAG}' 'https://jenkins.zyhosttest.online/job/gitops-complete-pipeline/buildWithParameters?token=gitops-token'"
                }
            }        
        }


        stage("Trigger CD Pipeline") {
            steps {
                script {
                    sh "curl -v -k --user admin:${JENKINS_API_TOKEN} -X POST -H 'cache-control: no-cache' -H 'content-type: application/x-www-form-urlencoded' --data 'IMAGE_TAG=${IMAGE_TAG}' 'https://github.dev/AhmedSamy1999/ArgoCD-GitOps-Kubernetes/buildWithParameters?token=gitops-token'"
                }
            }

        }














       
    }
}