if !([[ -d "./src/docker" ]] && [[ -d "./src/searchinit" ]]); then 
    echo "This script must be run from the repository root folder"
    exit 1
fi

mh down
# starts a new docker container named test-elasticsearch with the following environment variables
# --detach runs the container in the background
mh up elasticonly
mh up mongodb

#  sleep for 15 seconds; this is to ensure that the elasticsearch container is up and running before the script is executed, adjust as needed
sleep 10

rm -r node_modules
# export the following environment variables
export PROTOCOL=https
export HOST=localhost
export PORT=9200
export ELASTICSEARCH_INDEX=search-index
export LOAD_TEST=true
export DB_NAME=mentorHub

npm i
# build # run the following script
npm run build
npm run import

cp ./src/searchinit/entrypoint.sh ./dist/
cp ./src/searchinit/mapping.json ./dist/
cp ./src/searchinit/test-data.json ./dist/
cd dist
./entrypoint.sh