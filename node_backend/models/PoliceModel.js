

import mongoose from "mongoose";

const policeschema = new mongoose.Schema(

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
            required: true,
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
export default mongoose.model('Police', policeschema);