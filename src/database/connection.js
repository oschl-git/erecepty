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
	return result[0];
}

async function queryInsertReturnInsertedId(sql, ...parameters) {
	result = await query(sql, ...parameters);
	return result.insertId;
}

function beginTransaction() {
	connection.beginTransaction();
}

function commit() {
	connection.commit();
}

function rollback() {
	connection.rollback();
}

module.exports = {
	query,
	queryInsertReturnInsertedId,
	beginTransaction,
	commit,
	rollback,
};