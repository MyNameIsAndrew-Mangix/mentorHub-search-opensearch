# mentorhub-search-opensearch

This is repository contains database configuration and test data used by the search system, Opensearch. The Dockerfile creates an opensearch database instance that exposes the REST API service port and runs a script to initialize the index and mapping scripts to load test data.

[Here](https://github.com/orgs/agile-learning-institute/repositories?q=mentorhub-&type=all&sort=name) are all of the repositories in the [mentorHub](https://github.com/agile-learning-institute/mentorhub/tree/main) system

## Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/)

### Optionally
- [NodeJS and NPM](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm) - to build and run the data ingestion script

## Build and Run the Ingest Script
```bash
cd ./src/ingest
npm install
node build/ingest.js
```
## Contributing

The typescript files found in `./src/ingest/` are used to grab test data from a local instance of the [mongodb container](https://github.com/agile-learning-institute/mentorHub-mongodb/tree/main?tab=readme-ov-file) and perform the necessary data transformations before indexing the test data. There is a CLI tool at```./src/opensearch/opensearch-test.sh``` that can be used to run various tests on your opensearch container. Feel free to add on to it if you'd like, just follow the conventions.

You should do all work in a feature branch, and when you are ready to have your code deployed to the cloud open a pull request against that feature branch. Do not open a pull request without first building and testing the containers locally.


## Build and test the container

Use the following command to build and run the container locally. See [here for details](https://github.com/agile-learning-institute/mentorhub/blob/main/docker-compose/README.md) on how to stop/start the database.

```bash
./src/docker/docker-build.sh
```

After that command completes successfully you can verify it worked successfully by entering the following command

```bash
 curl https://localhost:9200 -ku 'admin:admin'
```

If you don't get a response, you can follow [this guide](https://opensearch.org/docs/latest/install-and-configure/install-opensearch/docker/) to troubleshoot.
With a working container, you can make use of 
```bash
../src/opensearch/opensearchtest.sh
```

## Refactors and Enhancements

- [ ] To Be Documented
