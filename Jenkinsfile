pipeline {
    agent any
    
    environment {
        IMAGE_NAME = "flask-app"
        TAG = "v1"
        CONTAINER_NAME = "flask-cont"
    }
    
    stages {
        stage('Clone Code') {
            steps {
                git url: "https://github.com/Krutika09/Flask-Docker-Jenkins-Deploy.git", branch: "main"
                echo "Code Clone Successfully.."
            }
        }
        
        stage("Build Code") {
            steps {
                echo "This is building stage"
                sh "docker build -t ${IMAGE_NAME} ."
            }
        }
        
        stage("Deploy Code") {
            steps {
                echo "This is deploying stage"
                sh "docker rm -f ${CONTAINER_NAME} || true"
                sh "docker build -t ${IMAGE_NAME}:${TAG}  . "
                sh "docker run -d -p 5000:5000 --name ${CONTAINER_NAME} ${IMAGE_NAME} "
            }
        }
       
    }
}
