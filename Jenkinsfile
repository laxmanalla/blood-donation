pipeline {
    agent any
    
    stages {
        stage('Check Environment') {
            steps {
                script {
                    // Check if Docker is installed and available
                    sh 'echo "Checking for Docker installation..."'
                    sh 'which docker || echo "ERROR: Docker is not installed or not in PATH"'
                    sh 'echo "Current working directory: $(pwd)"'
                    sh 'echo "System information: $(uname -a)"'
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    // Try to build the Docker image
                    sh '''
                        if command -v docker &> /dev/null; then
                            echo "Building Docker image..."
                            docker build -t blood-donation:latest .
                        else
                            echo "ERROR: Docker command not found. Please install Docker on the Jenkins agent."
                            exit 1
                        fi
                    '''
                }
            }
        }
          stage('Run Docker Container') {
            steps {
                script {
                    sh '''
                        if command -v docker &> /dev/null; then
                            echo "Managing Docker container..."
                            docker stop blood-donation-container || echo "Container not running"
                            docker rm blood-donation-container || echo "Container does not exist"
                            docker run -d -p 8081:80 --name blood-donation-container blood-donation:latest
                            docker ps -f "name=blood-donation-container"
                        else
                            echo "ERROR: Docker command not found. Cannot run container."
                            exit 1
                        fi
                    '''
                }
            }
        }
        
        stage('Test Deployment') {
            steps {
                script {
                    sh '''
                        echo "Waiting for container to start..."
                        sleep 5
                        
                        if command -v curl &> /dev/null; then
                            echo "Testing website accessibility..."
                            curl -s -o /dev/null -w "%{http_code}" http://localhost:8081 || echo "Website check failed"
                        else
                            echo "WARNING: curl command not found. Skipping website test."
                        fi
                    '''
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
            script {
                sh '''
                    if command -v docker &> /dev/null; then
                        echo "Cleaning up containers..."
                        docker stop blood-donation-container || echo "No container to stop"
                        docker rm blood-donation-container || echo "No container to remove"
                    else
                        echo "WARNING: Docker command not found. Cannot clean up containers."
                    fi
                '''
            }
        }
        always {
            script {
                sh '''
                    if command -v docker &> /dev/null; then
                        echo "Listing running containers..."
                        docker ps || echo "Cannot list containers"
                    else
                        echo "WARNING: Docker command not found. Cannot list containers."
                    fi
                '''
            }
        }
    }
}
