pipeline {
    agent any

    environment {
        REPO_URL = 'https://github.com/laxmanalla/blood-donation'
        BRANCH = 'main' // change this if your branch is something else
        COMPOSE_PROJECT_NAME = 'blood-donation'
    }

    stages {
        stage('Check Environment') {
            steps {
                echo "Checking required tools..."
                sh '''
                    echo "Docker status:"
                    which docker || echo "Docker not found - install with: sudo apt update && sudo apt install -y docker.io"
                    
                    echo "Docker Compose status:"
                    which docker-compose || echo "Docker Compose not found - install with: sudo apt install -y docker-compose"
                    
                    # We'll check if we can use direct Docker commands as a fallback
                    docker --version || echo "Docker cannot be executed - fix permissions with: sudo usermod -aG docker jenkins"
                '''
            }
        }

        stage('Install Docker Compose') {
            steps {
                echo "Attempting to install Docker Compose if missing..."
                sh '''
                    if ! command -v docker-compose &> /dev/null; then
                        echo "Docker Compose not found, attempting to install..."
                        # Method 1: Try apt install first
                        sudo apt update && sudo apt install -y docker-compose || echo "Could not install via apt"
                        
                        # Method 2: If apt fails, try direct download
                        if ! command -v docker-compose &> /dev/null; then
                            echo "Attempting manual installation of Docker Compose..."
                            sudo curl -L "https://github.com/docker/compose/releases/download/v2.18.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
                            sudo chmod +x /usr/local/bin/docker-compose
                            docker-compose --version || echo "Manual installation failed"
                        fi
                    else
                        echo "Docker Compose is already installed"
                        docker-compose --version
                    fi
                '''
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
