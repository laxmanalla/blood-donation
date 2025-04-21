pipeline {
    agent any
    
    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image - Dockerfile is in the same directory
                    sh 'docker build -t blood-donation:latest .'
                }
            }
        }
        
        stage('Run Docker Container') {
            steps {
                script {
                    // Stop and remove existing container if it exists
                    sh 'docker stop blood-donation-container || echo "Container not running"'
                    sh 'docker rm blood-donation-container || echo "Container does not exist"'
                      // Run the new container
                    sh 'docker run -d -p 8081:80 --name blood-donation-container blood-donation:latest'
                    
                    // Verify container is running
                    sh 'docker ps -f "name=blood-donation-container"'
                }
            }
        }
        
        stage('Test Deployment') {
            steps {
                script {
                    // Wait for container to start fully
                    sh 'sleep 5'
                    
                    // Test that the website is accessible
                    sh 'curl -s -o /dev/null -w "%{http_code}" http://localhost:8081 || echo "Website check failed"'
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
            // Cleanup on failure with shell commands
            sh 'docker stop blood-donation-container || echo "No container to stop"'
            sh 'docker rm blood-donation-container || echo "No container to remove"'
        }
        always {
            // Always display the running containers for logging purposes
            sh 'docker ps || echo "Cannot list containers"'
        }
    }
}
