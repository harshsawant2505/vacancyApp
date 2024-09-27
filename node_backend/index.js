import express from 'express';
var app = express();

import {getAbout, getUserData, setUserData} from './controllers/UserController.js';

app.use(express.json());

app.get('/', getUserData);

app.post('/', setUserData);

app.get('/about', getAbout);

app.listen(3001, function () {
  console.log('Example app listening on port 3001');
});