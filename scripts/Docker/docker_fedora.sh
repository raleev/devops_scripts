#!/bin/bash

# Update the repo
sudo dnf update -y

# Remove the old versions
sudo dnf remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine

sudo dnf -y install dnf-plugins-core

# Add the repo
sudo dnf -y config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

# Install docker and necessary tools
sudo dnf -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start
sudo systemctl start docker

# Enable
sudo systemctl enable docker.service
sudo systemctl enable containerd.service


# Create a group
sudo groupadd docker

# Add current user to docker group
sudo usermod -aG docker $USER


sudo chmod 666 /var/run/docker.sock


rm -rf docker.gpg*
rm -rf docker.key
