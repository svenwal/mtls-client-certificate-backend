#!/bin/sh
echo "Starting nginx"

cp /go/src/app/certs/client/client.crt /var/www/html/
cp /go/src/app/certs/client/client.key /var/www/html/
cp /go/src/app/webserver/index.html /var/www/html/

/etc/init.d/nginx start
