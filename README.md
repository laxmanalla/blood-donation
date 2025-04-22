# Simple Static Website with Jenkins CI/CD

This project contains a simple static HTML website (Blood Donation theme) and a Jenkins-based CI/CD pipeline to automatically build a Docker image and deploy it using Docker Compose.

## Project Structure

- `*.html`: HTML files for the website.
- `*.css`: CSS files for styling.
- `Dockerfile`: Defines how to build the Docker image using Nginx to serve the static files.
- `docker-compose.yml`: Defines the Docker Compose service to run the container built from the `Dockerfile`.
- `Jenkinsfile`: Contains the Jenkins pipeline script for the CI/CD process.

## CI/CD Pipeline (Jenkins)

The `Jenkinsfile` defines a declarative pipeline with the following stages:

1.  **Build Docker Image:**
    - Checks out the source code.
    - Builds a Docker image tagged as `blood-donation:latest` using the `Dockerfile` in the project root.
    - Requires Docker to be installed and accessible on the Jenkins agent.

2.  **Deploy with Docker Compose:**
    - Uses `docker-compose up -d` to start the service defined in `docker-compose.yml` in detached mode.
    - This pulls the newly built `blood-donation:latest` image (if not already present locally after the build stage) and starts the container.
    - Requires Docker Compose V2 (the `docker compose` command) to be installed and accessible on the Jenkins agent.

## Prerequisites

1.  **Jenkins:** A running Jenkins instance.
2.  **Jenkins Agent:** A configured Jenkins agent (or the controller itself, if using `agent any`) where the pipeline will run.
3.  **Docker:** Docker must be installed on the Jenkins agent machine.
4.  **Docker Permissions:** The user running the Jenkins agent process must have permission to interact with the Docker daemon.
    - **Linux:** Add the Jenkins user to the `docker` group (`sudo usermod -aG docker <jenkins_user>`) and restart the agent or log the user out/in.
    - **Windows (Docker Desktop):** Add the Jenkins user to the `docker-users` or `Administrators` group (using `Add-LocalGroupMember` in PowerShell as Admin) and restart the agent service.
5.  **Docker Compose:** Docker Compose V2 (usually included with Docker Desktop or installed as a Docker plugin) must be available on the Jenkins agent machine.

## Running the Pipeline

1.  Configure a new Pipeline job in Jenkins.
2.  Set the "Definition" to "Pipeline script from SCM".
3.  Configure your SCM (e.g., Git) to point to the repository containing this project.
4.  Set the "Script Path" to `Jenkinsfile` (this is usually the default).
5.  Save the job configuration.
6.  Run the pipeline job manually ("Build Now") or configure triggers (e.g., SCM polling, webhooks).

## Accessing the Website
Once the pipeline successfully completes the 'Deploy' stage, the website will be accessible at `http://<jenkins_agent_ip>:8081` (as defined in the `docker-compose.yml` port mapping).
