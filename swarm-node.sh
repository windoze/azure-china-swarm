#!/bin/sh
export HOSTIP=`hostname --ip-address`

# Uses my proxy
mkdir -p /etc/systemd/system/docker.service.d
cat << EOF > /etc/systemd/system/docker.service.d/http-proxy.conf
[Service]
Environment="HTTP_PROXY=http://cxp.eastasia.cloudapp.azure.com:80/"
EOF
systemctl daemon-reload
systemctl restart docker

docker run -d swarm join --addr=${HOSTIP}:2375 etcd://10.0.0.4:2379/swarm