#!/usr/bin/env bash

# Go-EC2 Deploy Script
# A simple script to build and deploy Go source code to AWS EC2
#
# Dependencies:
# Gox (https://github.com/mitchellh/gox)
# Daemonize (https://github.com/bmc/daemonize)

set -e

OS=linux
ARCH=386
PKG_NAME=build
KEY=secret.pem
HOST=user@ip
FOLDER=myapp

echo "-> Running tests"
go test

echo "-> Building package"
gox -os="$OS" -arch="$ARCH" -output="$PKG_NAME"

echo "-> Deploying package"
ssh -i $KEY $HOST "pkill $PKG_NAME"
scp -i $KEY $PKG_NAME $HOST:$FOLDER
ssh -i $KEY $HOST "daemonize -c ~/$FOLDER ~/$FOLDER/$PKG_NAME"

echo "-> OK: Package deployed!"
