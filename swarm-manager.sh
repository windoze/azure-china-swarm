#!/bin/sh

USERNAME=$1

PROXY="cxp.eastasia.cloudapp.azure.com:80"

# Install docker engine
curl -x ${PROXY} -sSL https://get.docker.com/ | sh

# Uses my proxy
mkdir -p /etc/systemd/system/docker.service.d
cat << EOF > /etc/systemd/system/docker.service.d/http-proxy.conf
[Service]
Environment="HTTP_PROXY=http://${PROXY}/"
EOF

# Let docker daemon listen on TCP port
cat << EOF > /etc/systemd/system/docker.service.d/docker.conf
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock
EOF

usermod -aG docker "${USERNAME}"
systemctl daemon-reload
systemctl restart docker

# Get manager token
TOKEN="`curl -s 10.0.0.4:8080/manager`"

# Join swarm
docker swarm join --token "${TOKEN}" 10.0.0.4:2377
