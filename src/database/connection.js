const mysql = require('mysql2');
const dotenv = require('dotenv');

dotenv.config();

const connection = mysql.createConnection({
	host: process.env.DB_HOST,
	user: process.env.DB_USER,
	password: process.env.DB_PASSWORD,
	database: process.env.DB_NAME,
});

async function query(sql, ...parameters) {
	let result = await connection.promise().query(sql, parameters);
	return result;
}

module.exports = {
	query
};