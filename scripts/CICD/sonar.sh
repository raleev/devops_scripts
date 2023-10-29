#!/bin/bash

sudo apt-get update -y

sudo apt-get install openjdk-17-jre -y

sudo apt-get install wget apt-transport-https gnupg2 software-properties-common unzip -y

sudo apt-get update -y

sudo apt-get install postgresql postgresql-contrib -y

sudo systemctl enable postgresql

sudo systemctl start postgresql

sudo useradd -b /opt/sonarqube -s /bin/bash sonarqube

sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-10.1.0.73491.zip

sudo unzip sonarqube-10.1.0.73491.zip

sudo mv sonarqube-10.1.0.73491 /opt/sonarqube

sudo chown -R sonarqube:sonarqube /opt/sonarqube
