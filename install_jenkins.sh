#!/bin/bash
# Update and install Java (required for Jenkins)
yum update -y
amazon-linux-extras enable java-openjdk11
yum install -y java-11-openjdk

# Add Jenkins repo and import the key
wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# Install Jenkins
yum install -y jenkins

# Enable and start Jenkins
systemctl enable jenkins
systemctl start jenkins
