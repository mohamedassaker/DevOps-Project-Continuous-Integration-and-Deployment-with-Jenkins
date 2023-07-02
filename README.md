# DevOps Project - Continuous Integration and Deployment with Jenkins

This project demonstrates a Continuous Integration (CI) and Continuous Deployment (CD) pipeline using Jenkins, Docker, and Maven. The pipeline automates the build, containerize, test, and deployment processes for a Java Maven application.

## Project Structure

The project includes the following files:

- `Jenkinsfile`: This file defines the Jenkins pipeline, which consists of several stages to build, test, and deploy the application.
- `Dockerfile`: This file contains the instructions to build a Docker image for the Java application.
- `docker-compose.yaml`: This file defines the Docker Compose configuration to run the Java application and a PostgreSQL database.
- `pom.xml`: This file is the Maven configuration for the Java application, specifying application version, dependencies and build plugins.
- `server-cmd.sh`: This shell script is executed on the deployment server to start the Docker containers.
- `Application.java`: This file contains the main class of the Java application.

## Jenkins Pipeline Overview

The Jenkins pipeline consists of the following stages:

1. **Increment Version**: This stage increments the application version by parsing the `pom.xml` file, updating the version, and committing the changes to a Git repository. The version is set as `<majorVersion>.<minorVersion>.<nextIncrementalVersion>-<BUILD_NUMBER>`.
2. **Build App**: This stage builds the Java application using Maven. It runs the `mvn clean package` command to compile the code and package it into an executable JAR file.
3. **Build Image**: This stage builds a Docker image for the application. It uses the Dockerfile and the built JAR file to create an image tagged with the version.
4. **Deploy**: This stage deploys the Docker image to an EC2 instance. It copies the necessary files (`server-cmd.sh` and `docker-compose.yaml`) to the EC2 instance and executes the `server-cmd.sh` script to start the application.
5. **Commit Version Update**: This stage commits the version update to the Git repository. It configures the Git user, adds the changes, commits them with a message, and pushes the changes to a specific branch.

## Usage

To use this project, follow these steps:

1. Set up a Jenkins server and create a new pipeline project.
2. Configure the necessary credentials in Jenkins:
   - `docker-hub-repo`: Docker Hub credentials for pushing the Docker image.
   - `ec2-server-key`: SSH private key for connecting to the EC2 instance.
   - `github-credentials`: GitHub credentials for pushing the version update to the repository.
3. Configure the pipeline in Jenkins to use the `Jenkinsfile` in this project.
4. Replace the placeholders in the `Jenkinsfile` with your specific values:
   - Replace `m8122000/demo-app` with your Docker Hub repository name.
   - Replace `ec2-user` with the username of the EC2 instance.
   - Replace `ec2-ip-address` with the IP address of the EC2 instance.
5. Make sure you have an EC2 instance with Docker and Docker Compose installed.
6. Ensure the necessary files (`Dockerfile`, `docker-compose.yaml`, and `server-cmd.sh`) are present on the EC2 instance.
7. Make sure to ignore 'jenkins' user commits from triggering the pipeline as this will cause an infinite loop.
8. Run the Jenkins pipeline and observe the build, test, and deployment processes.

## Benefits of this Project

- **Automated Builds**: The pipeline automates the build process using Maven, ensuring consistent and reliable builds.
- **Dockerized Deployment**: The application is deployed as a Docker container, allowing for easy deployment and scalability.
- **Version Management**: The pipeline automatically increments the application version and commits the changes, making it easier to track and manage
