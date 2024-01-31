const { query } = require('../connection');

async function getAll() {
	return await query('select * from medical_institutions;');
}

async function addNewInstitution(name, field) {
	await query('insert into medical_institutions (name, field) values (?, ?);', name, field);
}

module.exports = {
	getAll,
	addNewInstitution,
};