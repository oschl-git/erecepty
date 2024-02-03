/**
 * Allows access to the doctors database table
 */

const { query } = require('../connection');

async function addNewDoctor(name, surname, level, id_medical_institution, identifier) {
	await query(
		'insert into doctors (name, surname, level, id_medical_institution, identifier) ' +
		'values (?, ?, ?, ?, ?);',
		name, surname, level, id_medical_institution, identifier
	);
}

async function getPossibleLevelEnumValues() {
	result = await query('show columns from doctors like ?;', 'level');
	const enumValues = result[0].Type.match(/enum\((.*?)\)/)[1].split(',');
	return enumValues.map(value => value.replace(/'/g, '').trim());
}

async function isIdentifierTaken(identifier) {
	result = await query('select (id) from doctors where identifier=?;', identifier);
	return result.length > 0;
}

async function getAllNamesAndIDs() {
	return await query('select name, surname, identifier, id from doctors;');
}

module.exports = {
	addNewDoctor,
	getPossibleLevelEnumValues,
	isIdentifierTaken,
	getAllNamesAndIDs,
};