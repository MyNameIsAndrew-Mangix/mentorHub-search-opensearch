# mentorhub-search-elasticsearch

This repository manages the configuration and test data for the Elasticsearch search system used in the MentorHub project. It consists of two containers. The first container starts the elasticsearch container. The second container initializes the index and mapping scripts, ensuring a ready-to-use environment for data, optionally loading test data. This dual-container setup provides a comprehensive solution for managing the Elasticsearch database, making it easy to deploy, configure, and populate with test data. When deployed into a production environment, we can utilize the second container with a different backing service, i.e. live elasticsearch

[Here](https://github.com/orgs/agile-learning-institute/repositories?q=mentorhub-&type=all&sort=name) are all of the repositories in the [mentorHub](https://github.com/agile-learning-institute/mentorhub/tree/main) system

# DISCLAIMER
The Elasticsearch container is quite big, roughly 1.3 GB. This might present a problem for those on a metered connection looking to contribute.

## Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/)

### Optionally
- [MentorHub Developer Edition](https://github.com/agile-learning-institute/mentorHub/tree/main/mentorHub-developer-edition) - to easily run the containers locally
- [NodeJS and NPM](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm) - to build and run the data ingestion script locally

### Customize configuration

See [Tsconfig Reference](https://www.typescriptlang.org/tsconfig)

## Contributing

The typescript files found in `./src/searchinit/` are used to grab test data from a `test-data.json` and perform the necessary data transformations before indexing the test data. There is a CLI tool at```./src/searchinit/elasticsearch-test.sh``` that can be used to run various tests on your elasticsearch container.

You should do all work in a feature branch, and when you are ready to have your code deployed to the cloud open a pull request against that feature branch. Do not open a pull request without first building and testing the containers locally.

## Testing changes locally
Run this from the project root directory (`mentorhub-search-elasticsearch`). This command creates an elasticsearch container then builds, bundles, and tests migrate.ts This is what you will use to test changes locally.
```bash
./src/searchinit/localtest.sh
```

## Build and test the container

Use the following command to build and run the container locally. See [here for details](https://github.com/agile-learning-institute/mentorHub/tree/main/mentorHub-developer-edition) on how to stop/start mentorhub containers.

```bash
./src/docker/docker-build.sh
```

After that command completes successfully you can verify it worked successfully by entering the following command

```bash
 curl https://localhost:9200 -ku 'admin:admin'
```

If you don't get a response, you can follow [this guide](hhttps://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html) to troubleshoot.
With a working container, you can make use of these tools
```bash
./src/searchinit/localtest.sh
./src/searchinit/elasticsearchtest.sh
```