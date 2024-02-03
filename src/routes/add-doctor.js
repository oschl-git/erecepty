const express = require('express');
const doctors = require('../database/gateways/doctorGateway');
const medicalInstitutions = require('../database/gateways/medicalInstitutionGateway');

const router = express.Router();

router.get('/', async function (req, res) {
	const formErrors = req.session.formErrors ?? [];
	delete req.session.formErrors;

	const successMessage = req.session.successMessage ?? null;
	delete req.session.successMessage;

	res.render('add-doctor', {
		formErrors: formErrors,
		successMessage: successMessage,
		levelEnumValues: await doctors.getPossibleLevelEnumValues(),
		medicalInstitutionValues: await medicalInstitutions.getAllNamesAndIDs(),
	});
});

router.post('/', async function (req, res) {
	const data = req.body;
	const errors = await getInputErrors(data.name, data.surname, data.level, data.medical_institution, data.identifier);

	if (errors.length) {
		req.session.formErrors = errors;
	} else {
		try {
			doctors.addNewDoctor(data.name, data.surname, data.level, data.medical_institution, data.identifier);
			req.session.successMessage = 'Záznam byl úspěšně přidán.';
		} catch {
			req.session.formErrors = ['Vyskytla se chyba při zápisu do databáze.'];
		}
	}

	res.redirect('/add-doctor');
});

async function getInputErrors(name, surname, level, medical_institution, identifier) {
	let errors = [];

	if (await doctors.isIdentifierTaken(identifier)) errors.push('Doktor s tímto identifikačním číslem již existuje.');
	if (name.length > 255) errors.push('Jméno nesmí být delší než 255 znaků.');
	if (surname.length > 255) errors.push('Příjmení nesmí být delší než 255 znaků.');

	return errors;
}

module.exports = router; 