#!/bin/bash

set -e  # Exit immediately if any command fails

echo "Updating system..."
sudo apt update

echo "Installing Java (OpenJDK 21)..."
sudo apt install -y fontconfig openjdk-21-jre

echo "Adding Jenkins repo key..."
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

echo "Adding Jenkins repo..."
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | \
    sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

echo "Updating package list again..."
sudo apt-get update

echo "Installing Jenkins..."
sudo apt-get install -y jenkins

echo "Installing Docker..."
sudo apt-get install -y docker.io

echo "Adding current user to docker group..."
sudo usermod -aG docker $USER

echo "Adding Jenkins user to docker group..."
sudo usermod -aG docker jenkins

echo "Restarting Docker and Jenkins services..."
sudo systemctl restart docker
sudo systemctl restart jenkins

echo "✅ All Done! Please logout and log back in (or reboot) for group changes to take effect."
