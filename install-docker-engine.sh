#!/bin/sh

PROXY="cxp.eastasia.cloudapp.azure.com:80"

cat << EOF > /etc/apt/sources.list
deb http://azure.archive.ubuntu.com/ubuntu/ xenial main restricted universe multiverse
deb http://azure.archive.ubuntu.com/ubuntu/ xenial-security main restricted universe multiverse
deb http://azure.archive.ubuntu.com/ubuntu/ xenial-updates main restricted universe multiverse
deb http://azure.archive.ubuntu.com/ubuntu/ xenial-proposed main restricted universe multiverse
deb http://azure.archive.ubuntu.com/ubuntu/ xenial-backports main restricted universe multiverse
deb-src http://azure.archive.ubuntu.com/ubuntu/ xenial main restricted universe multiverse
deb-src http://azure.archive.ubuntu.com/ubuntu/ xenial-security main restricted universe multiverse
deb-src http://azure.archive.ubuntu.com/ubuntu/ xenial-updates main restricted universe multiverse
deb-src http://azure.archive.ubuntu.com/ubuntu/ xenial-proposed main restricted universe multiverse
deb-src http://azure.archive.ubuntu.com/ubuntu/ xenial-backports main restricted universe multiverse
EOF

# Install docker engine
curl -sSL https://mirror.azure.cn/repo/install-docker-engine.sh | sh -

# Uses my proxy
mkdir -p /etc/systemd/system/docker.service.d
cat << EOF > /etc/systemd/system/docker.service.d/http-proxy.conf
[Service]
Environment="HTTP_PROXY=http://${PROXY}/" "NO_PROXY=localhost,127.0.0.1,mirror.azure.cn:5000"
EOF

# Let docker daemon listen on TCP port
cat << EOF > /etc/systemd/system/docker.service.d/docker.conf
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock
EOF
