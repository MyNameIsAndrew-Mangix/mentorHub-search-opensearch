#!/bin/sh
echo "##############################################"
VERSION=$(cat VERSION.txt)
echo "VERSION: $VERSION"
echo "##############################################"
echo "PROTOCOL: $PROTOCOL"
echo "HOST: $HOST"
echo "AUTH: $AUTH"
echo "PORT: $PORT"
echo "ELASTICSEARCH_INDEX: $ELASTICSEARCH_INDEX"
echo "LOAD_TEST: $LOAD_TEST"
node bundle.js
