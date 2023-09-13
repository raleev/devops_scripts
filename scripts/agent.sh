#!/bin/bash

sudo apt-get update -y

sudo apt-get install default-jre -y

sudo apt-get install openssh-server -y

sudo useradd -d /var/lib/jenkins jenkins

sudo mkdir -p /var/lib/jenkins/.ssh

cd /var/lib/jenikns/.ssh

sudo ssh-keygen -t rsa -C "agent key" -f "agent_rsa"

cat agent_rsa.pub | sudo tee authorized_keys

sudo chown -R jenkins:jenkins /var/lib/jenkins/ 
