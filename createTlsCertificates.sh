#!/bin/sh
echo "mTLS certificates creation"
echo "127.0.0.1  mtls.apim.eu" >> /etc/hosts
INIT_DIR=$PWD
APP_FOLDER=/go/src/app
cd certs
CERT_FOLDER=$APP_FOLDER/certs
ROOT_CA_FOLDER=$CERT_FOLDER/ca
CLIENT_CERT_FOLDER=$CERT_FOLDER/client

cd $ROOT_CA_FOLDER
openssl genrsa -aes256 -out private/ca.key.pem -passout pass:KongRul3z 4096
# openssl rsa -in private/ca.key.pem -out private/ca.key.decryted.pem -passin 'pass:KongRul3z'
chmod 400 private/ca.key.pem
openssl rsa -in private/ca.key.pem -out private/ca.key.unencrypted.pem -passin pass:KongRul3z
chmod 400 private/ca.key.unencrypted.pem
openssl req -config $CERT_FOLDER/openssl.cnf -key private/ca.key.pem -new -x509 -days 7300 -sha256 -extensions v3_ca -passin 'pass:KongRul3z' -subj "/C=WD/ST=Earth/L=Global/O=Kong Inc./CN=Kong CA" -out certs/ca.cert.pem
openssl rsa -in private/ca.key.pem -out private/ca.key.unencrypted.pem -passin pass:KongRul3z
chmod 444 certs/ca.cert.pem

echo "Creating the client certificate"
cd $CLIENT_CERT_FOLDER/
openssl genrsa -out client.key 2028
openssl req -new -subj "/emailAddress=demo@apim.eu/CN=apim.eu/O=Kong Inc./OU=Solution Engineering/C=WD/ST=Earth/L=Global" -key client.key -out client.csr
openssl ca -batch -config $CERT_FOLDER/openssl.cnf -extensions usr_cert -cert ../ca/certs/ca.cert.pem -keyfile ../ca/private/ca.key.pem  -passin 'pass:KongRul3z' -in client.csr -out client.crt


# getting back to initial folder where this script has been invoked from
cd "$INIT_DIR"
