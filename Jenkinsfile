pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    bat 'docker build -t blood-donation:latest .'
                }
            }
        }
        
        stage('Run Docker Container') {
            steps {                script {
                    bat 'docker stop blood-donation-container || true'
                    bat 'docker rm blood-donation-container || true'
                    bat 'docker run -d -p 8081:80 --name blood-donation-container blood-donation:latest'
                }
            }
        }
    }
    
    post {
        success {
            echo 'Blood Donation website deployed successfully!'
        }
        failure {
            echo 'Deployment failed!'
        }
    }
}
