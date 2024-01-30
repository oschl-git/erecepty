const connection = require('../connection');

async function getAll() {
	const sql = 'select * from medical_institutions;';
	const results = await connection.promise().query(sql);
	return results[0];
}

module.exports = {
	getAll
};