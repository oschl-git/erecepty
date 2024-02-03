/**
 * Handles importing prescription data from JSON
 */

const prescriptions = require('../database/gateways/prescriptionGateway');

async function importPrescriptionsFromJSON(json) {
	errors = [];

	let data;
	try {
		data = JSON.parse(json);
	} catch {
		errors.push('JSON soubor není ve správném formátu a nemohl být importován.');
		return errors;
	}

	if (!Array.isArray(data)) {
		errors.push('JSON soubor musí obsahovat seznam receptů.');
		return errors;
	}

	errors = prescriptions.addPrescriptionsFromJsonArray(data);
	return errors;
}

module.exports = {
	importPrescriptionsFromJSON,
};