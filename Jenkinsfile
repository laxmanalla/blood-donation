pipeline {
    agent any

    stages {
        stage('Build Docker Image') {

            steps {
                script {
                        echo 'Identifying Jenkins agent user...'
                        sh 'whoami' // This command prints the current username
                    }
                script {
                    echo 'Building the Docker image...'
                    // Use the docker build command directly or ensure Docker plugin is configured
                    // This example assumes docker commands are available in the Jenkins agent environment
                    sh 'docker build -t blood-donation:latest .'
                }
            }
        }
        stage('Deploy with Docker Compose') {
            steps {
                script {
                    echo 'Deploying the container using Docker Compose...'
                    // Ensure docker-compose is installed on the Jenkins agent
                    sh 'docker compose up -d'
                }
            }
        }
        // Optional: Add a cleanup stage
        // stage('Cleanup') {
        //     steps {
        //         script {
        //             echo 'Stopping and removing the container...'
        //             // Optional: Stop and remove containers after pipeline run or on failure
        //             sh 'docker-compose down'
        //         }
        //     }
        // }
    }
    post {
        always {
            echo 'Pipeline finished.'
            // Optional: Add cleanup steps that should always run
            // sh 'docker-compose down' // Uncomment if you want to stop containers after each run
        }
        failure {
            echo 'Pipeline failed. Performing cleanup...'
            // Optional: Add specific cleanup for failures
            // sh 'docker-compose down'
        }
    }
}
