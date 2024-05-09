import { Client } from "@elastic/elasticsearch";
const fs = require("fs");

const host: string = process.env.HOST!;
const protocol: string = process.env.PROTOCOL!;
const port: string = process.env.PORT!;
const auth: string = process.env.AUTH!;
const indexName: string = process.env.ELASTICSEARCH_INDEX!;
const loadTest: string = process.env.LOAD_TEST!;

async function main()
{
    console.log("HOST: " + host + ", PROTOCOL: " + protocol + ", PORT: " + port + ", AUTH: " + auth + ", INDEXNAME: " + indexName + ", LOADTESTDATA: ", loadTest);
    console.log("Creating Elasticsearch Client with Node:", protocol + "://" + host + ":" + port);
    const elasticSearchClient: Client = new Client({
        node: protocol + "://" + host + ":" + port,
        auth: {
            username: "elastic", // Default Elasticsearch username
            password: "o0=eLmmQbsrdEW89a-Id" // Elasticsearch password
        },
        tls: {
            ca: "",
            rejectUnauthorized: false
        }
    });

    const mappingPath: string = 'mapping.json';
    const testDataPath: string = 'test-data.json';

    try {
        await testConnection();

        await verifyAndCreateIndex();

        await createOrUpdateIndexMapping();
        if (loadTest === "true") {
            await indexTestData();
        }
        else {
            console.log("Loading testing data disabled");
        }

    }
    catch (error) {
        console.log(error);
    }
    finally {
        console.log("All done!");
        elasticSearchClient.close();
    }


    async function indexTestData()
    {

        const testData = JSON.parse(fs.readFileSync(testDataPath, 'utf8'));
        // Do necessary transformations on test data
        const transformedTestData = transformData(testData);

        // Index the data
        console.log("Attemping to index test data...");
        const response = await elasticSearchClient.bulk({
            index: indexName,
            body: transformedTestData.flatMap((doc: any) => [
                { index: { _index: indexName } },
                doc,
            ])
        });
        console.log(response);

        if (!response.errors) {
            console.log("Successfully indexed test data!");
        }
        else {
            // Bulk sends a 200 if it reaches the server. 
            // Each document has their own status code, so we need to cycle through if there are errors in the body
            console.error("Errors occured during indexing");
            response.items.forEach((item: any, index: any) =>
            {
                console.error(`Item ${index + 1} details:`, item);
                console.error("Caused By:", item.index.error.caused_by);
            });
        }
    }

    function transformData(testData: any): any
    {
        console.log("Transforming test data before indexing...");
        return testData.map((doc: any) =>
        {
            //Elasticsearch doesn't like the source having an _id field, so we rename it. Eventually it will be along the lines of collectionNameId
            const { _id, ...transformedDoc } = doc;
            return { ...transformedDoc, 'ID': _id };
        });
    }

    async function createOrUpdateIndexMapping()
    {
        console.log("Trying to create/update mapping...");

        const mapping = JSON.parse(fs.readFileSync(mappingPath, 'utf8'));
        // Create/update if there's mapping for the data
        const response = await elasticSearchClient.indices.putMapping({
            index: indexName,
            body: mapping
        });
        if (response && response.acknowledged === false) {
            // It's likely that it'll be a type error, i.e. trying to change the type of an existing mapping from string to keyword
            throw new Error("Failed to create/update mapping.");
        }
        else {
            console.log("Mapping has been created/updated!");
        }
    }

    async function verifyAndCreateIndex()
    {
        if (typeof indexName === "string") {
            // Check if index exists
            console.log("Verifying if index exists or needs to be created...");
            const indexExists = await elasticSearchClient.indices.exists({
                index: indexName
            });
            // The indices exists returns a boolean.
            // So we can check if indexExists === false, with no edge cases
            if (indexExists === false) {
                console.log(`Index of ${indexName} doesn't exist, creating index`);
                await elasticSearchClient.indices.create({
                    index: indexName
                });
            }
            else {
                console.log(`Index ${indexName} exists!`);
            }
        }

    }

    async function testConnection()
    {
        if (await elasticSearchClient.ping()) {
            console.log('Elasticsearch server is reachable');
        }
        else {
            throw new Error('Did not recieve response from elasticsearch server');
        }
    }
}

main();