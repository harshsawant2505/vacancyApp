
import User from "../models/UserModel.js";
import connectDB from "../config.js";
import axios from "axios";
import bcrypt from 'bcrypt';
import DataSet from "../models/DataSet.js";



async function getUserData(req,res) {
    try {
        await connectDB();

        if(req.session.user) {
            console.log('Session data:', req.session.user);
            const user = User.findOne({email: req.session.user.email});
            console.log('User data:', user);
            req.status(200).json({message: 'Data fetched successfully', user: user});
        }
        res.status(200).json({message: 'Data fetched successfully'});
    } catch (error) {
      
        res.status(500).json({message: 'Server error'});
        
    }

}

async function register(req,res) {

    try {
      
        await connectDB();
        console.log("reached")
        const {name, email, numberPlate, phNo, password } = req.body;

        const saltRounds = 10; // You can adjust this value
        const hashedPassword = await bcrypt.hash(password, saltRounds);
        console.log(name, email, numberPlate, phNo,  hashedPassword); 
        
        req.session.user = {name, email, numberPlate, phNo, password: hashedPassword};

        const preExisitingUser = await User.findOne({email: email})

        if(preExisitingUser){
            console.log('User already exists Login Instead');
            return res.json({message: 'User already exists'});
        }
       
        const user = new User({name, email, numberPlate, phNo, password: hashedPassword});
        
        user.save();
        res.status(200).json({message: 'Data set successfully', data: user});
    } catch (error) {
        console.error('error:', error);
        res.status(500).json({message: 'Server error'});
        
    }

}
const login = async(req, res) => {

    try {
        await connectDB();
        const {email, password} = req.body;
        if(!email || !password) {
            return res.status(400).json({message: 'Please enter all fields'});
        }
        const user = await User.findOne({ email: email });
        if(!user) {
            return res.status(400).json({message: 'User not found'});
        }
       bcrypt.compare(password, user.password, (err, result) => {
            if(result){
                req.session.user = user;
                return res.json({message: 'Login successful', user: user});
            }else{
                return res.status(400).json({message: 'Password incorrect'});
            }
       });

       

        
    }catch(error) {
        console.error('error:', error);
        return res.status(500).json({message: 'Server error'});
    }


}

const setDataSet = async(req, res) => {

    try {
            await connectDB();
       
        const data = await DataSet.findOneAndUpdate({gps: '15.588398 73.947827'},{occupied: 1} ,{new: true});
        console.log('Data:', data);
            res.status(200).json({data});
        
    } catch (error) {
        console.log('Error:', error);
    }
}


const getAbout = async(req, res) => {
    try {
        const response = await axios.get(`https://nominatim.openstreetmap.org/reverse`, {
            params: {
                lat: 15.587195,
                lon: 73.948034,
                format: 'json',
            },
        });

        if (response.data) {
            console.log('Location Data:', response.data);
        } else {
            console.log('No data found for the given coordinates.');
        }
    } catch (error) {
        console.error('Error fetching location:', error.message);
    }
    
}

const getLocationDetails = async(req, res) => {

    const {lat, lon} = await req.body;
    console.log(lat, lon);
    try {
        const response = await axios.get(`https://nominatim.openstreetmap.org/reverse`, {
            params: {
                lat: lat,
                lon: lon,
                format: 'json',
            },
        });

        if (response.data) {
            console.log('Location Data:', response.data);
            
        } else {
            console.log('No data found for the given coordinates.');
        }
        res.status(200).json({message: 'Data fetched successfully', data: response.data});
    } catch (error) {
        console.error('Error fetching location:', error.message);
        res.status(500).json({message: 'Server error'});
    }
}

const getParkingDetails = async(req, res) => {

    
    try {
        await connectDB();
    const {city} = await req.body;
    console.log(city);
    const data = await DataSet.find({city: city});
    console.log(data);
    res.status(200).send(data);

    } catch (error) {
        console.log(error);
    }

}

const getParkingAllDetails = async(req, res) => {

    
    try {
        await connectDB();

    const data = await DataSet.find({});
    console.log(data);
    res.status(200).send(data);

    } catch (error) {
        console.log(error);
    }

}

const getCorrespondingData = async(req, res) => {
    try {
        await connectDB();
        const {lat, lon} = await req.body;
        console.log(lat, lon);
        const data = await DataSet.findOne({gps: `${lat} ${lon}`});
        console.log(data);
        res.status(200).send(data);
    } catch (error) {
        console.log(error);
    }
}


export {
    getUserData,
    register,
    getAbout,
    getLocationDetails,
    login,
    setDataSet,
    getParkingDetails,
    getParkingAllDetails,
    getCorrespondingData
};