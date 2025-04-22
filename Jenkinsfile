pipeline {
    agent any

    environment {
        REPO_URL = 'https://github.com/laxmanalla/blood-donation'
        BRANCH = 'main' // change this if your branch is something else
        COMPOSE_PROJECT_NAME = 'blood-donation'
    }

    stages {
        stage('Clone Repository') {
            steps {
                echo "Cloning repository from ${REPO_URL}"
                sh "rm -rf blood-donation && git clone -b ${BRANCH} ${REPO_URL} blood-donation"
            }
        }

        stage('Build Docker Image') {
            steps {
                dir('blood-donation') {
                    echo 'Building Docker image...'
                    sh 'docker-compose build'
                }
            }
        }

        stage('Stop Previous Deployment') {
            steps {
                dir('blood-donation') {
                    echo 'Stopping and removing previous containers...'
                    sh 'docker-compose down'
                }
            }
        }

        stage('Deploy Application') {
            steps {
                dir('blood-donation') {
                    echo 'Deploying application...'
                    sh 'docker-compose up -d'
                }
            }
        }
    }

    post {
        success {
            echo '✅ Deployment successful!'
        }
        failure {
            echo '❌ Deployment failed.'
        }
    }
}
