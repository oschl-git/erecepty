import express, { Express } from "express";
import dotenv from "dotenv";
import path from 'path';

import homeRoute from './routes/home';


dotenv.config();

const app: Express = express();
const port = process.env.PORT || 3000;

app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'templates'));

app.use('/', homeRoute);

app.listen(port, () => {
	console.log(`[OK] Successfully started server at port ${port}. (http://localhost:${port})`);
});