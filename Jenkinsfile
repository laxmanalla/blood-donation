pipeline {
    agent any
    
    stages {
        stage('Validate Environment') {
            steps {
                // Display the workspace directory and list files to validate structure
                powershell 'Write-Host "Workspace: $env:WORKSPACE"'
                powershell 'Get-ChildItem -Path . | Format-Table Name, Length'
                
                // Verify Docker is available
                powershell 'docker version'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image - Dockerfile is in the same directory
                    powershell 'docker build -t blood-donation:latest .'
                }
            }
        }
        
        stage('Run Docker Container') {
            steps {
                script {
                    // Stop and remove existing container if it exists
                    powershell 'docker stop blood-donation-container -ErrorAction SilentlyContinue'
                    powershell 'docker rm blood-donation-container -ErrorAction SilentlyContinue'
                    
                    // Run the new container
                    powershell 'docker run -d -p 8081:80 --name blood-donation-container blood-donation:latest'
                    
                    // Verify container is running
                    powershell 'docker ps -f "name=blood-donation-container"'
                }
            }
        }
        
        stage('Test Deployment') {
            steps {
                script {
                    // Wait for container to start fully
                    powershell 'Start-Sleep -Seconds 5'
                    
                    // Test that the website is accessible
                    powershell 'try { Invoke-WebRequest -Uri "http://localhost:8081" -UseBasicParsing; Write-Host "Website is accessible" } catch { Write-Host "Error accessing website: $_"; exit 1 }'
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
            powershell 'docker stop blood-donation-container -ErrorAction SilentlyContinue'
            powershell 'docker rm blood-donation-container -ErrorAction SilentlyContinue'
        }
        always {
            // Always display the running containers for logging purposes
            powershell 'docker ps'
        }
    }
}
