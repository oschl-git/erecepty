/**
 * Allows access to the medical_institutions database table
 */

const { query } = require('../connection');

async function addNewInstitution(name, field) {
	await query('insert into medical_institutions (name, field) values (?, ?);', name, field);
}

async function isNameTaken(name) {
	result = await query('select (id) from medical_institutions where name=?', name);
	return result.length > 0;
}

async function getAllNamesAndIDs() {
	return await query('select name, id from medical_institutions;');
}

module.exports = {
	addNewInstitution,
	isNameTaken,
	getAllNamesAndIDs,
};