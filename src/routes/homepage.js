const express = require('express');
const medicalInstitutions = require('../database/gateways/medicalInstitutionGateway');

var router = express.Router();

router.get('/', async function (req, res) {
	let homepageContent = await medicalInstitutions.getAll();

	res.render('homepage', {
		homePageContent: homepageContent[0].name,
	});
});

module.exports = router; 