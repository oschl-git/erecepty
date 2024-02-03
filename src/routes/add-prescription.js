const express = require('express');
const prescriptions = require('../database/gateways/prescriptionGateway');
const medicine = require('../database/gateways/medicineGateway');
const doctors = require('../database/gateways/doctorGateway');
const patients = require('../database/gateways/patientGateway');

const router = express.Router();

router.get('/', async function (req, res) {
	const formErrors = req.session.formErrors ?? [];
	delete req.session.formErrors;

	const successMessage = req.session.successMessage ?? null;
	delete req.session.successMessage;

	let medicineValues = await medicine.getAllNamesAndIDs();
	let doctorValues = await doctors.getAllNamesAndIDs();
	let patientValues = await patients.getAllNamesAndIDs();

	let unsatisfiedPrerequisites = getUnsatisfiedPrerequisites(medicineValues, doctorValues, patientValues);

	res.render('add-prescription', {
		formErrors: formErrors,
		successMessage: successMessage,
		medicineValues: medicineValues,
		doctorValues: doctorValues,
		patientValues: patientValues,
		unsatisfiedPrerequisites: unsatisfiedPrerequisites,
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

function getUnsatisfiedPrerequisites(medicineValues, doctorValues, patientValues) {
	let problems = [];

	if (!medicineValues.length) problems.push('Pro vystavení ereceptu musí existovat alespoň jeden lék.');
	if (!doctorValues.length) problems.push('Pro vystavení ereceptu musí existovat alespoň jeden lékař.');
	if (!patientValues.length) problems.push('Pro vystavení ereceptu musí existovat alespoň jeden pacient.');

	return problems;
}

module.exports = router; 