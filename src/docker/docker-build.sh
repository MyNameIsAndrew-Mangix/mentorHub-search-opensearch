#!/bin/bash

# Build Docker Image
docker build --file src/docker/Dockerfile --tag ghcr.io/agile-learning-institute/mentorhub-search-opensearch:latest .
if [ $? -ne 0 ]; then
    echo "Docker build failed"
    exit 1
fi

# Run the containers
# curl https://raw.githubusercontent.com/agile-learning-institute/mentorhub/main/docker-compose/<<run-local-TODO:.sh | /bin/bash
docker run -e discovery.type=single-node -e cluster.name=mentorHub -e plugins.security.disabled=true -p 9200:9200 --name test-opensearch --detach opensearchproject/opensearch:latest
