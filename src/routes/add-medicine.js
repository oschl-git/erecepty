const express = require('express');
const medicine = require('../database/gateways/medicineGateway');

var router = express.Router();

router.get('/', async function (req, res) {
	const formErrors = req.session.formErrors ?? [];
	delete req.session.formErrors;

	const successMessage = req.session.successMessage ?? null;
	delete req.session.successMessage;


	res.render('add-medicine', {
		formErrors: formErrors,
		successMessage: successMessage,
	});
});

router.post('/', async function (req, res) {
	const data = req.body;
	const errors = await getInputErrors(data.name, data.price);

	if (errors.length) {
		req.session.formErrors = errors;
	} else {
		try {
			medicine.addNewMedicine(data.name, data.price);
			req.session.successMessage = 'Záznam byl úspěšně přidán.';
		} catch {
			req.session.formErrors = ['Vyskytla se chyba při zápisu do databáze.'];
		}
	}

	res.redirect('/add-medicine');
});

async function getInputErrors(name, price) {
	let errors = [];

	if (await medicine.isNameTaken(name)) errors.push('Lék již existuje.');
	if (name.length > 255) errors.push('Název léku nesmí být delší než 255 znaků.');
	if (price < 0) errors.push('Cena nesmí být záporná.');

	return errors;
}

module.exports = router; 