
import User from "../models/UserModel.js";
import connectDB from "../config.js";

import bcrypt from 'bcrypt';


async function getUserData(req,res) {
    try {
        res.status(200).json({message: 'Data fetched successfully'});
    } catch (error) {
      
        res.status(500).json({message: 'Server error'});
        
    }

}

async function setUserData(req,res) {

    try {
      
        await connectDB();
        console.log("reached")
        const {name, email, numberPlate, phNo, password } = req.body;

        const saltRounds = 10; // You can adjust this value
        const hashedPassword = await bcrypt.hash(password, saltRounds);
        console.log(name, email, numberPlate, phNo, password, hashedPassword);   
        const user = new User({name, email, numberPlate, phNo, password: hashedPassword});
        
        user.save();
        res.status(200).json({message: 'Data set successfully', data: user});
    } catch (error) {
        console.error('error:', error);
        res.status(500).json({message: 'Server error'});
        
    }

}


const getAbout = async(req, res) => {
    res.status(200).json({message: 'About page'});
}
export {
    getUserData,
    setUserData,
    getAbout
};