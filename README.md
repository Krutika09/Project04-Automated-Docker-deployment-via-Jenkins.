##  Step 1: Create AWS EC2 Instance

**Security Group: Allow below ports**

* **22** (SSH)
* **80** (HTTP)
* **443** (HTTPS)
* **8080** (Jenkins)
* **6000** (Flask App)

![image](https://github.com/user-attachments/assets/d9adf207-3535-4708-9469-2d0b8af69d67)

##  Step 2: Install Java (Required for Jenkins)

```bash
sudo apt update
sudo apt install fontconfig openjdk-21-jre -y
```


##  Step 3: Install Jenkins

```bash
# Add Jenkins GPG key
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

# Add Jenkins repository
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update & Install Jenkins
sudo apt-get update
sudo apt-get install jenkins -y
```

##  Step 4: Install Docker

```bash
sudo apt-get install docker.io -y

# Add current user and Jenkins to Docker group
sudo usermod -aG docker $USER && newgrp docker
sudo usermod -aG docker jenkins

# Restart Docker and Jenkins
sudo systemctl restart docker
sudo systemctl restart jenkins
```
> -aG docker appends (-a) the user to the Docker group (-G docker)
> $USER refers to the current user.

## Step 5: Create a Local Docker Registry

```bash
docker run -d -p 5050:5000 --restart=always --name registry registry:2

# Test registry
curl http://localhost:5050/v2/_catalog
```

Expected response:

```json
{"repositories":[]}
```
> To create a self-hosted Docker registry, you typically use the official `registry` image from Docker Hub.

## Step 6: Reboot to Apply Changes

```bash
sudo reboot
```

After reboot:

```bash
sudo systemctl restart docker
sudo systemctl restart jenkins
```


## Step 7: Jenkins Web UI Access.

* Open browser: `http://<EC2-PUBLIC-IP>:8080`
* Get the admin password:

  ```bash
  sudo cat /var/lib/jenkins/secrets/initialAdminPassword
  ```
* Install suggested plugins
* Create admin user

## Step 8: Create a Jenkins Pipeline

**1. Go to Jenkins Dashboard → New Item → Pipeline → Name: `Flask-Docker-AutoDeploy` → OK**

**2. Scroll down to Pipeline section → Choose "Pipeline script" → Paste the following:**

### 🧪 Sample Declarative Pipeline Script

```groovy
pipeline {
    agent any

    stages {
        stage('Clone Code') {
            steps {
                git url: 'https://github.com/Krutika09/Flask-Docker-Jenkins-Deploy.git' , branch: 'main'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t localhost:5050/flask-app:v1 .'
            }
        }

        stage('Push to Local Registry') {
            steps {
                sh 'docker push localhost:5050/flask-app:v1'
            }
        }

        stage('Deploy Container') {
            steps {
                sh '''
                docker stop flask-app || true
                docker rm flask-app || true
                docker run -d -p 6000:6000 --name flask-app localhost:5050/flask-app:v1
                '''
            }
        }
    }
}


```

### ⚠️ Docker Permission Denied Fix (For Jenkins)

If you see this error during a Jenkins pipeline run:
![image](https://github.com/user-attachments/assets/7d0b1697-c513-4927-a814-fa2a2a8b63c0)

Run the following commands **on your server** to fix the issue:

```bash
sudo usermod -aG docker jenkins
sudo systemctl restart docker
sudo systemctl restart jenkins
sudo reboot
```

After reboot, check if Jenkins is part of the Docker group:

```bash
groups jenkins
```

You should see output like:

```bash
jenkins : jenkins docker
```

Once done, rerun your pipeline — the Docker permission error should be resolved.


## Step 9: Test Flask App

Open your browser and visit:

```
http://<EC2-PUBLIC-IP>:6000
```
OR Do from your aws terminal:  
```
curl http://localhost:6000/
```

