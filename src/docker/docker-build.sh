#!/bin/bash

echo "Ensure we are running in the proper folder"
if !([[ -d "./src/docker" ]] && [[ -d "./src/opensearch" ]]); then 
    echo "This script must be run from the repository root folder"
    exit 1
fi

echo "Building Docker Image"
docker build --file src/docker/Dockerfile --tag ghcr.io/agile-learning-institute/mentorhub-search-opensearch:latest .
if [ $? -ne 0 ]; then
    echo "Docker build failed"
    exit 1
fi

# Run the containers
# curl https://raw.githubusercontent.com/agile-learning-institute/mentorhub/main/docker-compose/<<run-local-TODO:.sh | /bin/bash
docker run -e discovery.type=single-node -e cluster.name=mentorHub -e plugins.security.disabled=true -p 9200:9200 --name mentorhub-opensearch-1 --detach opensearchproject/opensearch:latest
sleep 15 # Ensure the opensearch container is open
docker run --name mentorhub-opensearch-indexer-1 ghcr.io/agile-learning-institute/mentorhub-search-opensearch:latest 