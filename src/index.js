const express = require('express');
const dotenv = require('dotenv');
const path = require('path');
const loader = require('require-dir');
const session = require('express-session');
const bodyParser = require('body-parser');

dotenv.config();

const app = express();
const port = process.env.PORT || 3000;

app.use(express.static(path.join(__dirname, 'public')));

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.use(session({
	secret: process.env.SECRET_KEY,
	resave: false,
	saveUninitialized: true,
}));

app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

const routes = loader('./routes');
for (const route in routes) {
	const path = route != 'homepage' ? route : '';
	app.use('/' + path, routes[route]);
}

app.listen(port, () => {
	console.log(`[OK] Successfully started server at port ${port}. (http://localhost:${port})`);
});