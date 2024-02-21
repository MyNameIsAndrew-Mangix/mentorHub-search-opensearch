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

mh up search-db