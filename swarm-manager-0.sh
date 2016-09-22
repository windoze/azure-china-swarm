#!/bin/sh

PROXY="cxp.eastasia.cloudapp.azure.com:80"

# Set yum proxy
echo "proxy=http://${PROXY}" >> /etc/yum.conf

# Install docker engine
yum -y update
curl -x ${PROXY} -sSL https://get.docker.com/ | sh
yum install -y docker-selinux

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

systemctl daemon-reload
systemctl restart docker

# Get Host IP
HOSTIP=`hostname --ip-address`
HOSTIP=${HOSTIP%$'\n'}
HOSTIP=${HOSTIP//[[:blank:]]/}

# Init swarm
docker swarm init --advertise-addr ${HOSTIP}

# Setup token server
mkdir -p /var/lib/swarm-tokens
docker swarm join-token -q worker > /var/lib/swarm-tokens/worker
docker swarm join-token -q manager > /var/lib/swarm-tokens/manager
docker run --name token-server -v /var/lib/swarm-tokens:/usr/share/nginx/html:ro -d -p 8080:80 nginx
