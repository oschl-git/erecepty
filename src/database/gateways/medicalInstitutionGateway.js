const { query } = require('../connection');

async function getAll() {
	return await query('select * from medical_institutions;');
}

async function addNewInstitution(name, field) {
	await query('insert into medical_institutions (name, field) values (?, ?);', name, field);
}

async function isNameTaken(name) {
	result = await query('select (id) from medical_institutions where name=?', name);
	return result.length > 0;
}

module.exports = {
	getAll,
	addNewInstitution,
	isNameTaken,
};