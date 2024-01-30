const { query } = require('../connection');

async function getAll() {
	const results = await query('select * from medical_institutions;');
	return results[0];
}

module.exports = {
	getAll
};