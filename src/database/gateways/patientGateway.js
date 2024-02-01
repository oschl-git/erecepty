const { query, beginTransaction, commit, rollback } = require('../connection');
const phoneNumbers = require('./phoneNumberGateway');

async function addPatientTransaction(name, surname, phoneNumber, identityNumber) {
	beginTransaction();

	try {
		let phoneNumberId = await phoneNumbers.addNewPhoneNumberReturnInsertedId(phoneNumber);
		await addNewPatient(name, surname, phoneNumberId, identityNumber);
	} catch (e) {
		rollback();
		throw new Error('Error occurred during the add patient transaction: ' + e);
	}

	commit();
}

async function addNewPatient(name, surname, phoneNumberId, identityNumber) {
	await query(
		'insert into patients (name, surname, phone_number_id, identity_number) ' +
		'values (?, ?, ?, ?);',
		name, surname, phoneNumberId, identityNumber
	);
};

module.exports = {
	addPatientTransaction,
	addNewPatient,
};