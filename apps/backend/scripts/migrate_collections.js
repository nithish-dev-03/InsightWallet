import mongoose from 'mongoose';
import dotenv from 'dotenv';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Load env variables
dotenv.config({ path: path.join(__dirname, '../.env') });

const mongodbUri = process.env.MONGODB_URI;
const dbName = process.env.DATABASE_NAME || 'InsightWallet';

if (!mongodbUri) {
  console.error('Error: MONGODB_URI is not set in backend .env file');
  process.exit(1);
}

async function migrate() {
  try {
    console.log(`Connecting to MongoDB: ${mongodbUri} (DB: ${dbName})`);
    await mongoose.connect(mongodbUri, {
      dbName: dbName,
    });
    console.log('Connected to database.');

    const db = mongoose.connection.db;

    // Get list of collections
    const collections = await db.listCollections().toArray();
    const collectionNames = collections.map(col => col.name);
    console.log('Found collections:', collectionNames);

    if (!collectionNames.includes('users')) {
      console.log('No "users" collection found. Nothing to migrate.');
      await mongoose.disconnect();
      return;
    }

    // Read all users
    const usersCollection = db.collection('users');
    const authsCollection = db.collection('auths');

    const users = await usersCollection.find({}).toArray();
    console.log(`Found ${users.length} documents in "users" collection.`);

    let migratedAuthCount = 0;
    let updatedUserCount = 0;

    for (const user of users) {
      // Check if user document contains password (which indicates it's a combined document)
      if (user.password) {
        console.log(`Migrating auth data for user: ${user.email}`);

        // 1. Upsert into auths collection
        await authsCollection.updateOne(
          { email: user.email },
          {
            $set: {
              email: user.email,
              password: user.password,
              refreshToken: user.refreshToken || '',
              resetPasswordToken: user.resetPasswordToken || null,
              resetPasswordExpires: user.resetPasswordExpires || null,
              createdAt: user.createdAt || new Date(),
              updatedAt: user.updatedAt || new Date(),
            }
          },
          { upsert: true }
        );
        migratedAuthCount++;

        // 2. Remove password and authentication fields from users collection
        await usersCollection.updateOne(
          { _id: user._id },
          {
            $unset: {
              password: "",
              refreshToken: "",
              resetPasswordToken: "",
              resetPasswordExpires: "",
            }
          }
        );
        updatedUserCount++;
      } else {
        console.log(`User ${user.email} already has separate auth collection.`);
      }
    }

    console.log('--- Migration Summary ---');
    console.log(`Migrated auths records: ${migratedAuthCount}`);
    console.log(`Cleaned up user profiles: ${updatedUserCount}`);
    console.log('Migration completed successfully.');

  } catch (error) {
    console.error('Migration failed:', error);
  } finally {
    await mongoose.disconnect();
    console.log('Disconnected from database.');
  }
}

migrate();
