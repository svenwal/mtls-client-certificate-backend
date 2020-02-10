#!/bin/sh

./createTlsCertificates.sh
./enableNginx.sh
echo "Enabling ssl server on port 443"
go run server.go