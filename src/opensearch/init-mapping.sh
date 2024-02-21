#!/bin/bash

# Define OpenSearch details
OPENSEARCH_HOST="localhost"
OPENSEARCH_PORT="9200"
INDEX_NAME="search-index"
OPENSEARCH_USERNAME="admin"
OPENSEARCH_PASSWORD="admin"

# Path to external mapping file
MAPPING_FILE="mapping.json"
# Read mapping content from the file
MAPPING=$(cat "$MAPPING_FILE")


# Set up the index with the defined mapping
curl -X PUT "http://${OPENSEARCH_HOST}:${OPENSEARCH_PORT}/${INDEX_NAME}" -u "${OPENSEARCH_USERNAME}:${OPENSEARCH_PASSWORD}" -H 'Content-Type: application/json' -d "${MAPPING}"
