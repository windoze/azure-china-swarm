#!/bin/sh

PROXY=cxp.eastasia.cloudapp.azure.com:80

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
systemctl daemon-reload
systemctl restart docker

# Get Host IP
HOSTIP=`hostname --ip-address`
HOSTIP=${HOSTIP%$'\n'}
HOSTIP=${HOSTIP//[[:blank:]]/}

# Start etcd
docker run -d -v /etc/ssl/certs:/etc/ssl/certs -p 4001:4001 -p 2380:2380 -p 2379:2379 \
 --name etcd ystyle/etcd \
 -name etcd0 \
 -advertise-client-urls http://${HOSTIP}:2379,http://${HOSTIP}:4001 \
 -listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001 \
 -initial-advertise-peer-urls http://${HOSTIP}:2380 \
 -listen-peer-urls http://0.0.0.0:2380 \
 -initial-cluster-token etcd-cluster-1 \
 -initial-cluster etcd0=http://${HOSTIP}:2380 \
 -initial-cluster-state new

sleep 10

# Start swarm manager
docker run --rm -d -p 3376:3376 -t swarm manage -H 0.0.0.0:3376 etcd://${HOSTIP}:2379/swarm
