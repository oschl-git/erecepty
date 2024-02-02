const express = require('express');
const prescriptions = require('../database/gateways/prescriptionGateway');
const medicine = require('../database/gateways/medicineGateway');
const doctors = require('../database/gateways/doctorGateway');
const patients = require('../database/gateways/patientGateway');

var router = express.Router();

router.get('/', async function (req, res) {
	const formErrors = req.session.formErrors ?? [];
	delete req.session.formErrors;

	const successMessage = req.session.successMessage ?? null;
	delete req.session.successMessage;

	res.render('add-prescription', {
		formErrors: formErrors,
		successMessage: successMessage,
		medicineValues: await medicine.getAllNamesAndIDs(),
		doctorValues: await doctors.getAllNamesAndIDs(),
		patientValues: await patients.getAllNamesAndIDs(),
	});
});

router.post('/', async function (req, res) {
	const data = req.body;

	try {
		await prescriptions.addPrescriptionTransaction(data.doctor, data.patient, data.expires, false, data.medicine);
		req.session.successMessage = 'Záznam byl úspěšně přidán.';
	} catch {
		req.session.formErrors = ['Vyskytla se chyba při zápisu do databáze.'];
	}

	res.redirect('/add-prescription');
});

module.exports = router; 