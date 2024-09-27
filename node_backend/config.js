// config.js
import mongoose from "mongoose";

const uri = "mongodb+srv://hsmedia2505:ERJzEdAOGkZ80vPD@cluster0.8tdaz.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0"

//AG9mZobYhnjzHIGe
//ERJzEdAOGkZ80vPD
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
