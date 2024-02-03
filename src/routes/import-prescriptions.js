const express = require('express');
const multer = require('multer');
const importer = require('../import/jsonPrescriptionImporter');

const router = express.Router();
const upload = multer({ storage: multer.memoryStorage() });


router.get('/', async function (req, res) {
	const formErrors = req.session.formErrors ?? [];
	delete req.session.formErrors;

	const successMessage = req.session.successMessage ?? null;
	delete req.session.successMessage;


	res.render('import-prescriptions', {
		formErrors: formErrors,
		successMessage: successMessage,
	});
});

router.post('/', upload.single('file'), async function (req, res) {
	let fileContents = req.file.buffer.toString();

	let errors = await importer.importPrescriptionsFromJSON(fileContents);

	if (errors.length) {
		req.session.formErrors = errors;
	} else {
		req.session.successMessage = 'Recepty byly úspěšně importovány.';
	}

	res.redirect('/import-prescriptions');
});


module.exports = router; 