#!/bin/sh

# Prepare CA file structure
rm -rf ./demoCA
mkdir -p ./demoCA/private ./demoCA/newcerts
echo 01 >./demoCA/serial
touch ./demoCA/index.txt

# CA: private key, self-signed certificate
openssl req -x509 -newkey rsa:1024 \
  -keyout ./demoCA/private/cakey.pem \
  -out ./demoCA/cacert.pem \
  -subj /CN=ca/C=JP/ST=Osaka/O=vagrant-examples \
  -passout pass:ca-pass

# Server: Diffie Hellman parameters
openssl dhparam -out ./dh1024.pem 1024

# Server: private key, certificate request
openssl req -newkey rsa:1024 \
  -keyout ./server-key.pem \
  -out ./server-req.pem \
  -subj /CN=a1/C=JP/ST=Osaka/O=vagrant-examples \
  -passout pass:a1-pass

# Server: certificate
openssl ca -batch \
  -in ./server-req.pem \
  -out ./server-cert.pem \
  -passin pass:ca-pass

# Client: private key, certificate request
openssl req -newkey rsa:1024 \
  -keyout ./client-key.pem \
  -out ./client-req.pem \
  -subj /CN=b1/C=JP/ST=Osaka/O=vagrant-examples \
  -passout pass:b1-pass

# Client: certificate
openssl ca -batch \
  -in ./client-req.pem \
  -out ./client-cert.pem \
  -passin pass:ca-pass