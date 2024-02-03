const express = require('express');
const prescriptions = require('../database/gateways/prescriptionGateway');

const router = express.Router();

router.get('/', async function (req, res) {
	res.render('prescription-summary', {
		report: await prescriptions.getPrescriptionReportObject(),
	});
});

module.exports = router; 