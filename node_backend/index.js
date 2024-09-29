import {} from 'dotenv/config'
import express from 'express';
import session from "express-session";
import cors from "cors";
var app = express();
import {getAbout, getLocationDetails, getUserData, register, login, setDataSet, getParkingDetails, getParkingAllDetails,getCorrespondingData} from './controllers/UserController.js';


app.use(cors());
app.use(express.json());

const sessionKey =  process.env.SESSIONKEY;
console.log(sessionKey);

app.use(session({
  secret: sessionKey, // Change this to a random string
  resave: false,
  saveUninitialized: true,
  cookie: { secure: false } // Set to true if using HTTPS
}));

app.post('/getCorrespondingData', getCorrespondingData);

app.get('/setdataset', setDataSet);

app.get('/profile', getUserData);

app.post('/register', register);

app.post('/login', login)

app.get('/about', getAbout);

app.post('/getlocation', getLocationDetails);

app.post('/parkingdetails', getParkingDetails);

app.get('/allparkingdetails', getParkingAllDetails);

const PORT = process.env.PORT || 3001;

app.listen(PORT, function () {
  console.log(`Example app listening on port ${PORT}`);
});