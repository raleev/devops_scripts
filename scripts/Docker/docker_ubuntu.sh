#!/bin/bash

sudo apt-get update -y

wget -O - https://download.docker.com/linux/ubuntu/gpg > ./docker.key

gpg --no-default-keyring --keyring ./docker.gpg --import ./docker.key

gpg --no-default-keyring --keyring ./docker.gpg --export > ./docker-archive-keyring.gpg

sudo mv ./docker-archive-keyring.gpg /etc/apt/trusted.gpg.d/

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" -y

sudo apt-get update - y

sudo apt-get install docker-ce -y

sudo usermod -aG docker $USER

sudo chmod 666 /var/run/docker.sock

sudo rm -rf docker.gpg*

sudo rm -rf docker.key