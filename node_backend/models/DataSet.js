

import mongoose from "mongoose";

const datasetschema = new mongoose.Schema(
{
   "2w": {
        type: Number,
        required: true
    },
    "4w": {
        type: Number,
        required: true
    },
    city: {
        type: String,
        required: true
    },
    gps: {
        type: String, // You can also use an array of numbers if you prefer: [Number]
        required: true
    },
    place: {
        type: String,
        required: true
    },
    type: {
        type: String,
         // Assuming these are the only types. Adjust as necessary.
        required: true
    },
    occupied: {
        type: Number,
        default: 0
    },
}
)
export default mongoose.model('DataSet', datasetschema);