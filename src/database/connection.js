/**
 * Handles database connection, exports functions for running queries
 */

const mysql = require('mysql2');
const dotenv = require('dotenv');

dotenv.config();

const connection = mysql.createConnection({
	host: process.env.DB_HOST,
	user: process.env.DB_USER,
	password: process.env.DB_PASSWORD,
	database: process.env.DB_NAME,
});

/**
 * Executes a query and returns its result.
 * @param {string} sql - The SQL query to run
 * @param  {...any} parameters - Parameters
 * @returns the result of the query
 */
async function query(sql, ...parameters) {
	let result = await connection.promise().query(sql, parameters);
	return result[0];
}

/**
 * Executes an insert query and returns the ID of the inserted column.
 * @param {string} sql - The SQL query to run
 * @param  {...any} parameters - Parameters
 * @returns {Number} the ID of the inserted column
 */
async function queryInsertReturnInsertedId(sql, ...parameters) {
	result = await query(sql, ...parameters);
	return result.insertId;
}

/**
 * Starts a transaction.
 */
function beginTransaction() {
	connection.beginTransaction();
}

/**
 * Commits a transaction.
 */
function commit() {
	connection.commit();
}

/**
 * Rolls back a transaction.
 */
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