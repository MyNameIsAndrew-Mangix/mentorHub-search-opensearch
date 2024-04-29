#!/bin/bash

DATA_FILE=""
INDEX_NAME=${1:-'search-index'}

while getopts ":p:gd:a:lmh" opt; do
  case $opt in
    p)
      # Testing POST
      if [ -z "$OPTARG" ]; then
        echo "Error: The -p option requires an argument for the data file."
        exit 1
      fi

      DATA_FILE="$OPTARG"
      if [ ! -f "$DATA_FILE" ]; then
        echo "Error: Data file '$DATA_FILE' not found."
        exit 1
      fi

      echo "-=-=-=-=-=TESTING POST-=-=-=-=-="
      echo ""
      curl -u elastic:o0=eLmmQbsrdEW89a-Id -k -XPOST "https://localhost:9200/_bulk" -H "Content-Type: application/json" --data-binary "@$DATA_FILE"
      echo ""
      ;;
    g)
      # Testing GET
      INDEX_NAME="$OPTARG"
      echo ""
      curl -u elastic:o0=eLmmQbsrdEW89a-Id -k -XGET "https://localhost:9200/$INDEX_NAME/_search" -H "Content-Type: application/json" -d '{
          "query": {
              "match_all": {}
          }
      }'
      echo ""
      ;;
    d)
      # Removing duplicates
      echo "-=-=-=-=-=REMOVING DUPLICATES-=-=-=-=-="
      echo ""
      curl -u elastic:o0=eLmmQbsrdEW89a-Id -k -XPOST "https://localhost:9200/${OPTARG}/_delete_by_query" -H "Content-Type: application/json" -d '{
          "query": {
              "match_all": {}
          }
      }'
      echo ""
      ;;
    a)
      # Deleting all entries (with confirmation)
      if [ -z "$OPTARG" ]; then
        echo "Error: The -a option requires an argument for the index to delete."
        exit 1
      fi

      read -p "Are you sure you want to delete all entries in the database with the index of '$OPTARG'? (y/n): " confirm
      if [ "$confirm" == "y" ]; then
        echo "-=-=-=-=-=DELETING ALL ENTRIES-=-=-=-=-="
        echo ""
        curl -u elastic:o0=eLmmQbsrdEW89a-Id -k -XDELETE "https://localhost:9200/${OPTARG}" -H "Content-Type: application/json"
        echo ""
      else
        echo "Deletion canceled."
      fi
      ;;
    l)
      # Listing all available indices
      echo "-=-=-=-=-=LISTING AVAILABLE INDICES-=-=-=-=-="
      echo ""
      curl -u elastic:o0=eLmmQbsrdEW89a-Id -k -XGET "https://localhost:9200/_cat/indices?v" -H "Content-Type: application/json"
      echo ""
      ;;
    m)
      # Retrieving mappings
      if [ -z "$OPTARG" ]; then
        INDEX_NAME="_all"
      else
        INDEX_NAME="$OPTARG"
      fi
      echo "-=-=-=-=-=RETRIEVING MAPPINGS-=-=-=-=-="
      echo ""
      curl -u elastic:o0=eLmmQbsrdEW89a-Id -k -XGET "https://localhost:9200/$INDEX_NAME/_mapping" -H "Content-Type: application/json"
      echo ""
      ;;
    h)
      # Print manual
      echo "Usage: $0 [-ptdahl]"
      echo "Options:"
      echo "  -p       Testing POST to _bulk endpoint. Requires [data_file] argument for JSON data file"
      echo "  -g       Testing GET from _search endpoint. Use optional [index] to specify an index (e.g., -g my_index)"
      echo "  -d       Removing duplicates. Requires [index] argument (e.g., -d my_index)"
      echo "  -a       Deleting all entries in the specified index (with confirmation). Requires [index] argument (e.g., -a my_index)"
      echo "  -l       List all available indices"
      echo "  -m       Retrieve mappings. Use optional [index] to specify an index (e.g., -m my_index)"
      echo "  -h       Display this help message"
      exit 0
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done

# If no option is provided, call the manual
if [ $OPTIND -eq 1 ]; then
  echo "No option provided. Displaying manual:"
  echo ""
  $0 -h
fi
