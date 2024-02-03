/**
 * Allows access to the medicine database table
 */

const { query } = require('../connection');

async function addNewMedicine(name, price) {
	await query('insert into medicine(name, price) values (?, ?);', name, price);
}

async function isNameTaken(name) {
	result = await query('select (id) from medicine where name=?', name);
	return result.length > 0;
}

async function getAllNamesAndIDs() {
	return await query('select name, id from medicine;');
}

module.exports = {
	addNewMedicine,
	isNameTaken,
	getAllNamesAndIDs,
};