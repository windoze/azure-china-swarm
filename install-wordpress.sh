#!/bin/sh

COUNT=$1
DBHOST=$2
DBUSER=$3
DBPASS=$4
DBNAME=$5

docker service create --name wordpress -e WORDPRESS_DB_HOST="${DBHOST}.mysqldb.chinacloudapi.cn" -e WORDPRESS_DB_USER="${DBUSER}" -e WORDPRESS_DB_PASSWORD="${DBPASS}" -e WORDPRESS_DB_NAME="${DBNAME}" --replicas "${COUNT}" -p 8080:80 mirror.azure.cn:5000/wordpress
