

import mongoose from "mongoose";

const userSchema = new mongoose.Schema(

    {
        name: {
            type: String,
            required: true,
        },
        email: {
            type: String,
            required: true,
        },
        numberPlate: {
            type: String,
            default:"000"
        },
        phNo: {
            type: String,
            required: true,
        },
        password: {
            type: String,
            required: true,
        },
    }
)
export default mongoose.model('User', userSchema);