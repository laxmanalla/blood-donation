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
        
        stage('Verify Deployment') {
            steps {
                script {
                    // Wait for container to start
                    powershell 'Start-Sleep -Seconds 5'
                    
                    // Check if container is running
                    powershell 'docker ps -f "name=blood-donation-container"'
                    
                    // Test HTTP connection to the deployed site
                    powershell 'Invoke-WebRequest -Uri "http://localhost:8081" -UseBasicParsing'
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
            
            // Cleanup on failure
            script {
                powershell 'docker stop blood-donation-container -ErrorAction SilentlyContinue'
                powershell 'docker rm blood-donation-container -ErrorAction SilentlyContinue'
            }
        }
        always {
            // Record deployment artifacts if needed
            echo 'Pipeline completed'
        }
    }
}
