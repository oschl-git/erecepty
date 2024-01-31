const express = require('express');
const medicalInstitutions = require('../database/gateways/medicalInstitutionGateway');

var router = express.Router();

router.get('/', async function (req, res) {
	const formErrors = req.session.formErrors ?? [];
	delete req.session.formErrors;

	const successMessage = req.session.successMessage ?? null;
	delete req.session.successMessage;


	res.render('add-institution', {
		formErrors: formErrors,
		successMessage: successMessage,
	});
});

router.post('/', async function (req, res) {
	const data = req.body;
	const errors = getInputErrors(data.name, data.field);

	if (errors.length) {
		req.session.formErrors = errors;
	} else {
		try {
			medicalInstitutions.addNewInstitution(data.name, data.field);
			req.session.successMessage = 'Záznam byl úspěšně přidán.';
		} catch {
			req.session.formErrors = ['Vyskytla se chyba při zápisu do databáze.'];
		}
	}

	res.redirect('/add-institution');
});

function getInputErrors(name, field) {
	let errors = [];

	if (name.length > 255) errors.push('Jméno instituce nesmí být delší než 255 znaků.');
	if (field.length > 255) errors.push('Zaměření nesmí být delší než 255 znaků.');

	return errors;
}

module.exports = router; 