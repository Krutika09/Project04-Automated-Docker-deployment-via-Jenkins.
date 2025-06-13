pipeline {
    agent any 

    stages {
        stage('Clone Code') {
            steps {
                git url: 'https://github.com/Krutika09/Flask-Docker-Jenkins-Deploy.git', branch: 'main'
            }
        }

        stage('Build Image & Push to Local Docker Registry') {
            steps {
                sh '''
                    docker build -t flask-app .
                    docker tag flask-app localhost:5050/flask-app:v1
                    docker push localhost:5050/flask-app:v1
                '''
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                    docker rm -f flask-container || true
                    docker pull localhost:5050/flask-app:v1
                    docker run -d -p 6000:6000 --name flask-container localhost:5050/flask-app:v1
                '''
            }
        }
    }
}

