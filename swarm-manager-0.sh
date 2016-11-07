#!/bin/sh

USERNAME=$1
PROXY="cxp.eastasia.cloudapp.azure.com:80"

# Install and configure docker engine
curl -sSL http://mmp-docker-showcase-hub.chinaeast.cloudapp.chinacloudapi.cn/install-docker-engine.sh | sh -

usermod -aG docker "${USERNAME}"
systemctl daemon-reload
systemctl restart docker

# Install docker-compose
curl -L "http://mmp-docker-showcase-hub.chinaeast.cloudapp.chinacloudapi.cn/docker-compose-$(uname -s)-$(uname -m)" > /usr/local/bin/docker-compose
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
