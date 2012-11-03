#!/bin/bash

export S3_BUCKET="heroku-buildpack"

export LIBMCRYPT_VERSION="2.5.8"
export PHP_VERSION="5.4.7"
export APC_VERSION="3.1.10"
export PHPREDIS_VERSION="2.2.1"
export LIBMEMCACHED_VERSION="1.0.7"
export MEMCACHED_VERSION="2.0.1"
export NGINX_VERSION="1.2.4"

export EC2_PRIVATE_KEY=~/.ec2/pk-62JWQ4X5SZ37IZMECGBPJOMK2EXFQOHO.pem
export EC2_CERT=~/.ec2/cert-62JWQ4X5SZ37IZMECGBPJOMK2EXFQOHO.pem
export EC2_URL=https://ec2.us-east-1.amazonaws.com