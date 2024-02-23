if !([[ -d "./src/docker" ]] && [[ -d "./src/searchinit" ]]); then 
    echo "This script must be run from the repository root folder"
    exit 1
fi

mh down
# starts a new docker container named test-opensearch with the following environment variables
# --detach runs the container in the background
#plugs.security.disabled=true allows us to test using http
docker run -e discovery.type=single-node -e cluster.name=mentorHub -e plugins.security.disabled=true -e OPENSEARCH_INITIAL_ADMIN_PASSWORD="55CKoK;9|'g{8i<4|Gny6pUX" -p 9200:9200 --name test-opensearch --detach opensearchproject/opensearch:2.12.0



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