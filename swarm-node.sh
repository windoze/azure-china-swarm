#!/bin/sh

USERNAME=$1

# Install and configure docker engine
curl -sSL http://0d0a.com/install-docker-engine.sh | sh -

usermod -aG docker "${USERNAME}"
systemctl daemon-reload
systemctl restart docker

# Get worker token
TOKEN="`curl -s 10.0.0.4:8080/worker`"

# Join swarm
docker swarm join --token "${TOKEN}" 10.0.0.4:2377
