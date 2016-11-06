#!/bin/sh

USERNAME=$1
PROXY="cxp.eastasia.cloudapp.azure.com:80"

# Install and configure docker engine
curl -sSL http://0d0a.com/install-docker-engine.sh | sh -

usermod -aG docker "${USERNAME}"
systemctl daemon-reload
systemctl restart docker

# Install docker-compose
curl -L "http://0d0a.com/docker-compose-$(uname -s)-$(uname -m)" > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Get manager token
TOKEN="`curl -s 10.0.0.4:8080/manager`"

# Join swarm
docker swarm join --token "${TOKEN}" 10.0.0.4:2377
