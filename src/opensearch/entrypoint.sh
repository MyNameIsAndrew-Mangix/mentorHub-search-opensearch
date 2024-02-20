#!/bin/bash
echo "PROTOCOL: $PROTOCOL"
echo "HOST: $HOST"
echo "AUTH: $AUTH"
echo "PORT: $PORT"
echo "OPENSEARCH_INDEX: $OPENSEARCH_INDEX"
node migrate.js
