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

# Get Host IP
#HOSTIP=`hostname --ip-address`
#HOSTIP=${HOSTIP%$'\n'}
#HOSTIP=${HOSTIP//[[:blank:]]/}
HOSTIP="10.0.0.4"

# Init swarm
docker swarm init --advertise-addr ${HOSTIP}

# Setup token server
mkdir -p /var/lib/swarm-tokens
docker swarm join-token -q worker > /var/lib/swarm-tokens/worker
docker swarm join-token -q manager > /var/lib/swarm-tokens/manager
docker run --name token-server -v /var/lib/swarm-tokens:/usr/share/nginx/html:ro -d -p 8080:80 nginx
