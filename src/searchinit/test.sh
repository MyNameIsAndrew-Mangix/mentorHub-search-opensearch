if !([[ -d "./src/docker" ]] && [[ -d "./src/searchinit" ]]); then 
    echo "This script must be run from the repository root folder"
    exit 1
fi

mh down
# starts a new docker container named test-opensearch with the following environment variables
# --detach runs the container in the background
#plugs.security.disabled=true allows us to test using http
docker run -p 9200:9200 --name test-elasticsearch -it -m 1GB --detach docker.elastic.co/elasticsearch/elasticsearch:8.13.2


#  sleep for 15 seconds; this is to ensure that the opensearch container is up and running before the script is executed, adjust as needed
sleep 15

rm -r node_modules
npm i
# build # run the following script
npm run build
# export the following environment variables
export PROTOCOL=http
export HOST=localhost
export AUTH=admin:admin
export PORT=9200
export OPENSEARCH_INDEX=search-index
export LOAD_TEST=true
cp ./src/searchinit/entrypoint.sh ./dist/
cp ./src/searchinit/mapping.json ./dist/
cp ./src/searchinit/test-data.json ./dist/
cd dist
./entrypoint.sh