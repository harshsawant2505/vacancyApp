import "dotenv"
import express from 'express';
import session from "express-session";
var app = express();
import {getAbout, getLocationDetails, getUserData, register, login} from './controllers/UserController.js';

app.use(express.json());

const sessionKey =  !process.env.SESSIONKEY;
console.log(sessionKey);

app.use(session({
  secret: "sfsdfksdkfjsdjf", // Change this to a random string
  resave: false,
  saveUninitialized: true,
  cookie: { secure: false } // Set to true if using HTTPS
}));



app.get('/profile', getUserData);

app.post('/register', register);

app.post('/login', login)

app.get('/about', getAbout);

app.post('/getlocation', getLocationDetails);

const PORT = process.env.PORT || 3001;

app.listen(PORT, function () {
  console.log(`Example app listening on port ${PORT}`);
});