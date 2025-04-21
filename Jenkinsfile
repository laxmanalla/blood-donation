pipeline {
    agent {
        label 'windows'  // Specify that this should run on a windows agent
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    powershell 'docker build -t blood-donation:latest .'
                }
            }
        }
        
        stage('Run Docker Container') {
            steps {
                script {
                    powershell 'docker stop blood-donation-container -ErrorAction SilentlyContinue'
                    powershell 'docker rm blood-donation-container -ErrorAction SilentlyContinue'
                    powershell 'docker run -d -p 8081:80 --name blood-donation-container blood-donation:latest'
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
