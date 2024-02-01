const { query, queryInsertReturnInsertedId } = require('../connection');

async function addNewPhoneNumberReturnInsertedId(phoneNumber) {
	return await queryInsertReturnInsertedId('insert into phone_numbers (phone_number) values (?);', phoneNumber);
}

async function isPhoneNumberTaken(phoneNumber) {
	result = await query('select (id) from phone_numbers where phone_number=?', phoneNumber);
	return result.length > 0;
}

module.exports = {
	addNewPhoneNumberReturnInsertedId,
	isPhoneNumberTaken,
};