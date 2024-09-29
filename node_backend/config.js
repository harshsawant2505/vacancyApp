// config.js
import mongoose from "mongoose";
import {} from 'dotenv/config'
const uri = process.env.MONGO_URI;


const connectDB = async () => {
  
    try {
        await mongoose.connect(uri, {
          
        });
        console.log('Connected to MongoDB');
    } catch (error) {
        console.error('MongoDB connection error:', error);
        process.exit(1); // Exit process with failure
    }
};

export default connectDB;
