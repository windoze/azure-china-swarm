#!/bin/sh

# Install docker engine
yum -y update
curl -sSL https://get.docker.com/ | sh
yum install -y docker-selinux

# Uses my proxy
mkdir -p /etc/systemd/system/docker.service.d
cat << EOF > /etc/systemd/system/docker.service.d/http-proxy.conf
[Service]
Environment="HTTP_PROXY=http://cxp.eastasia.cloudapp.azure.com:80/"
EOF
systemctl daemon-reload
systemctl restart docker

# Get Host IP
HOSTIP=`hostname --ip-address`
HOSTIP=${HOSTIP%$'\n'}
HOSTIP=${HOSTIP//[[:blank:]]/}

# Uses my proxy
mkdir -p /etc/systemd/system/docker.service.d
cat << EOF > /etc/systemd/system/docker.service.d/http-proxy.conf
[Service]
Environment="HTTP_PROXY=http://cxp.eastasia.cloudapp.azure.com:80/"
EOF
systemctl daemon-reload
systemctl restart docker

docker run -d swarm join --addr=${HOSTIP}:2375 etcd://10.0.0.4:2379/swarm