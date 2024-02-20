mh down
# starts a new docker container named test-opensearch with the following environment variables
# --detach runs the container in the background
#plugs.security.disabled=true allows us to test using http
docker run -e discovery.type=single-node -e cluster.name=mentorHub -e plugins.security.disabled=true -p 9200:9200 --name test-opensearch --detach opensearchproject/opensearch:latest



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
cp ./src/opensearch/entrypoint.sh ./dist/
cp ./src/opensearch/mapping.json ./dist/
cp ./src/opensearch/test-data.json ./dist/
cd dist
./entrypoint.sh