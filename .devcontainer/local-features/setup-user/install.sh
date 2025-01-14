#!/usr/bin/env bash

set -eux

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

export DEBIAN_FRONTEND=noninteractive

usermod --shell /usr/bin/zsh root     

ln -s /usr/local/aws-cli/v2/current/bin/aws /usr/bin/aws 
ln -s /usr/local/aws-cli/v2/current/dist/aws_completer /usr/bin/aws_completer 
ln -s /usr/bin/python3 /usr/bin/python 

ln -s /localhost/.aws /root/.aws 
ln -s /localhost/.kube /root/.kube 
ln -s /localhost/.continue /root/.continue
ln -s /localhost/.ollama /root/.ollma
ln -s /localhost/.ssh /root/.ssh
ln -s /localhost/.wakatime.cfg/root/.wakatime.cfg

echo "Done!"
