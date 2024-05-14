import { MongoClient, Db, ObjectId } from 'mongodb';
import { Config } from '../config/config';
import * as fs from "fs";
const config = new Config();
async function main()
{

    const mongoClient = new MongoClient(config.getConnectionString());
    try {
        await mongoClient.connect();
        const db = mongoClient.db(config.getDbName());
        console.info("Database", config.getDbName(), "Connected");

        const targetCollections = ['encounters', 'partners', 'paths', 'people', 'plans', 'resources', 'reviews', 'skills', 'topics'];

        const collections = await db.listCollections().toArray();

        const results: { _id: ObjectId; collection: string; }[] = [];

        for (const collectionInfo of collections) {
            const collectionName = collectionInfo.name;
            if (targetCollections.includes(collectionName)) {
                const collection = db.collection(collectionName);
                const documents = await collection.find({}).toArray();
                documents.forEach(doc =>
                {
                    results.push({
                        collection: collectionName,
                        ...doc
                    });
                });
            }
        }
        const jsonOutputPath = './src/searchinit/test-data.json';
        fs.writeFileSync(jsonOutputPath, JSON.stringify(results, null, 2));
        return results;
    } catch (error) {
        console.error(error);
    }
    finally {
        await mongoClient.close();
        console.info("Retrieved test data from mongoDB");
    }
}
main();