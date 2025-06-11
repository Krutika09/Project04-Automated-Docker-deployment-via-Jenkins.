pipeline {
    agent any

    environment {
        IMAGE_NAME = "flask-app"
        TAG = "v1"
        CONTAINER_NAME = "flask-container"
    }

    stages {
        stage('Clone Code') {
            steps {
                 git branch: 'main', url:  'https://github.com/Krutika09/Flask-Docker-Jenkins-Deploy.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${TAG} ."
            }
        }

        stage('Deploy Container') {
            steps {
        // Stop and remove existing container if it exists
        sh "docker rm -f flask-container || true"

        // Build the updated Docker image
        sh "docker build -t flask-app:v1 ."

        // Deploy the new container
        sh "docker run -d -p 5000:5000 --name flask-container flask-app:v1"
            }
        }
   }
    
}
