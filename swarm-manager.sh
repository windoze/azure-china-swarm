#!/bin/sh

USERNAME=$1

# Install and configure docker engine
curl -sSL https://raw.githubusercontent.com/windoze/azure-china-swarm/ubuntu/install-docker-engine.sh | sh -

usermod -aG docker "${USERNAME}"
systemctl daemon-reload
systemctl restart docker

# Install docker-compose
curl -x "${PROXY}" -L "https://github.com/docker/compose/releases/download/1.8.1/docker-compose-$(uname -s)-$(uname -m)" > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Get manager token
TOKEN="`curl -s 10.0.0.4:8080/manager`"

# Join swarm
docker swarm join --token "${TOKEN}" 10.0.0.4:2377
