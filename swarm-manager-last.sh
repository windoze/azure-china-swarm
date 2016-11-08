#!/bin/sh

USERNAME=$1
POSTSCRIPT=$2
COUNT=$3
DBHOST=$4
DBUSER=$5
DBPASS=$6
DBNAME=$7

PROXY="cxp.eastasia.cloudapp.azure.com:80"

# Install and configure docker engine
curl -sSL http://mmp-docker-showcase-hub.chinaeast.cloudapp.chinacloudapi.cn/install-docker-engine.sh | sh -

usermod -aG docker "${USERNAME}"
systemctl daemon-reload
systemctl restart docker

# Install docker-compose
curl -L "http://mmp-docker-showcase-hub.chinaeast.cloudapp.chinacloudapi.cn/docker-compose-$(uname -s)-$(uname -m)" > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Get manager token
TOKEN="`curl -s 10.0.0.4:8080/manager`"

# Join swarm
docker swarm join --token "${TOKEN}" 10.0.0.4:2377

# Run post script
if [ "xx${POSTSCRIPT}" != "xx" ]; then
    curl -sSL "${POSTSCRIPT}" | bash -s -- "${COUNT}" "${DBHOST}" "${DBUSER}" "${DBPASS}" "${DBNAME}"
fi