import { Client } from "@opensearch-project/opensearch";
const fs = require("fs");

const host: string | undefined = process.env.HOST;
const protocol: string | undefined = process.env.PROTOCOL;
const port: string | undefined = process.env.PORT;
const auth: string | undefined = process.env.AUTH;
const indexName: string | undefined = process.env.OPENSEARCH_INDEX;


async function main()
{
    if (indexName === undefined) {
        throw new Error("indexName is undefined");
    }
    const opensearchClient: Client = new Client({
        node: protocol + "://" + auth + "@" + host + ":" + port
    });

    const mappingPath: string = 'mapping.json';
    const testDataPath: string = 'test-data.json';

    try {
        await testConnection();

        await verifyAndCreateIndex();

        await createOrUpdateIndexMapping();

        await indexTestData();

    }
    catch (error) {
        console.log(error);
    }
    finally {
        opensearchClient.close();
    }


    async function indexTestData()
    {

        const testData = JSON.parse(fs.readFileSync(testDataPath, 'utf8'));
        //do necessary transformations on test data
        const transformedTestData = transformData(testData);

        //index the data
        console.log("Attemping to index test data...");
        const response = await opensearchClient.bulk({
            index: indexName,
            body: transformedTestData.flatMap((doc: any) => [
                { index: { _index: indexName, _id: doc._id } },
                doc,
            ])
        });
        if (response.statusCode === 200) {
            console.log("Successfully indexed test data!");
        }
    }

    function transformData(testData: any): any
    {
        console.log("Transforming test data before indexing...");
        return testData.map((doc: any) =>
        {
            Object.keys(doc).forEach((key) =>
            {
                if (typeof doc[key] === 'object' && doc[key].$oid) {
                    doc[key] = doc[key].$oid;
                }
            });
            return doc;
        });
    }

    async function createOrUpdateIndexMapping()
    {
        console.log("Trying to create/update mapping...");

        const mapping = JSON.parse(fs.readFileSync(mappingPath, 'utf8'));
        // Create/update if there's mapping for the data
        const response = await opensearchClient.indices.putMapping({
            index: indexName,
            body: mapping
        });
        if (response.statusCode === 400) {
            // It's likely that it'll be a type error, i.e. trying to change the type of an existing mapping from string to keyword
            throw new Error("Failed to create/update mapping: " + response.body + "\n Consider making a new container.");
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
            const indexExists = await opensearchClient.indices.exists({
                index: indexName
            });
            // The index exists API operation returns only one of two possible response codes: 200 – the index exists, and 404 – the index does not exist.
            // So we can check if statusCode === 404 with no edge cases
            if (indexExists.statusCode === 404) {
                console.log(`Index of ${indexName} doesn't exist, creating index`);
                await opensearchClient.indices.create({
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
        if (await opensearchClient.ping()) {
            console.log('Opensearch server is reachable');
        }
        else {
            throw new Error('Did not recieve response from opensearch server');
        }
    }
}

main();