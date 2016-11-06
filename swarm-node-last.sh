#!/bin/sh

USERNAME=$1
POSTSCRIPT=$2

# Install and configure docker engine
curl -sSL https://raw.githubusercontent.com/windoze/azure-china-swarm/postscript/install-docker-engine.sh | sh -

usermod -aG docker "${USERNAME}"
systemctl daemon-reload
systemctl restart docker

# Get worker token
TOKEN="`curl -s 10.0.0.4:8080/worker`"

# Join swarm
docker swarm join --token "${TOKEN}" 10.0.0.4:2377

# Run postscript if provided
if [ "xx$POSTSCRIPT" != "xx" ]; then
    curl -sSL "${POSTSCRIPT}" | sh -
fi
