#!/bin/bash

# https://github.com/gruntwork-io/terragrunt/releases

wget https://github.com/gruntwork-io/terragrunt/releases/download/v0.53.2/terragrunt_linux_amd64

sudo mv terragrunt_linux_amd64 terragrunt

chmod u+x terragrunt

sudo mv terragrunt /usr/local/bin/terragrunt

# Add the the path

#export PATH=$PATH:/usr/local/bin/
