/**
 * Handles the add-patient route.
 */

const express = require('express');
const patients = require('../database/gateways/patientGateway');
const phoneNumbers = require('../database/gateways/phoneNumberGateway');

const router = express.Router();

router.get('/', async function (req, res) {
	const formErrors = req.session.formErrors ?? [];
	delete req.session.formErrors;

	const successMessage = req.session.successMessage ?? null;
	delete req.session.successMessage;


	res.render('add-patient', {
		formErrors: formErrors,
		successMessage: successMessage,
	});
});

router.post('/', async function (req, res) {
	const data = req.body;
	const errors = await getInputErrors(data.name, data.surname, data.phone_number, data.identity_number);

	if (errors.length) {
		req.session.formErrors = errors;
	} else {
		try {
			patients.addPatientTransaction(data.name, data.surname, data.phone_number, data.identity_number);
			req.session.successMessage = 'Záznam byl úspěšně přidán.';
		} catch {
			req.session.formErrors = ['Vyskytla se chyba při zápisu do databáze.'];
		}
	}

	res.redirect('/add-patient');
});

async function getInputErrors(name, surname, phone_number, identity_number) {
	let errors = [];

	if (name.length > 255) errors.push('Jméno instituce nesmí být delší než 255 znaků.');
	if (surname.length > 255) errors.push('Příjmení nesmí být delší než 255 znaků.');
	if (phone_number.length > 255) errors.push('Telefonní číslo nesmí být delší než 255 znaků.');
	if (identity_number.length > 255) errors.push('Rodné číslo nesmí být delší než 255 znaků.');
	if (await phoneNumbers.isPhoneNumberTaken(phone_number)) errors.push('Telefonní číslo je již zabrané.');

	return errors;
}

module.exports = router; 