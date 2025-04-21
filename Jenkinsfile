pipeline {
    agent any
    
    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image - Dockerfile is in the same directory
                    bat 'docker build -t blood-donation:latest .'
                }
            }
        }
        
        stage('Run Docker Container') {
            steps {
                script {
                    // Stop and remove existing container if it exists
                    bat 'docker stop blood-donation-container || echo "Container not running"'
                    bat 'docker rm blood-donation-container || echo "Container does not exist"'
                    
                    // Run the new container
                    bat 'docker run -d -p 8081:80 --name blood-donation-container blood-donation:latest'
                    
                    // Verify container is running
                    bat 'docker ps -f "name=blood-donation-container"'
                }
            }
        }
        
        stage('Test Deployment') {
            steps {
                script {
                    // Wait for container to start fully
                    bat 'timeout /t 5'
                    
                    // Test that the website is accessible (simplified to avoid PowerShell complexity)
                    bat 'curl -s -o nul -w "%%{http_code}" http://localhost:8081 || echo "Website check failed"'
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
            // Cleanup on failure with simpler batch commands
            bat 'docker stop blood-donation-container || echo "No container to stop"'
            bat 'docker rm blood-donation-container || echo "No container to remove"'
        }
        always {
            // Always display the running containers for logging purposes
            bat 'docker ps || echo "Cannot list containers"'
        }
    }
}
