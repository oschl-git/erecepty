const { query, queryInsertReturnInsertedId, beginTransaction, commit, rollback } = require('../connection');

async function addPrescriptionTransaction(doctorId, patientId, expires, fulfilled, medicine) {
	beginTransaction();

	try {
		let prescriptionId = await addNewPerscription(doctorId, patientId, expires, fulfilled);
		for (const med of medicine) await addNewPrescriptionMedicineRelation(prescriptionId, med);
	} catch (e) {
		rollback();
		throw new Error('Error occurred during the add prescription transaction: ' + e);
	}

	commit();
}

async function addNewPerscription(doctorId, patientId, expires, fulfilled) {
	return await queryInsertReturnInsertedId(
		'insert into prescriptions (doctors_id, patients_id, created, expires, fulfilled) values (?, ?, now(), ?, ?);',
		doctorId, patientId, expires, fulfilled
	);
}

async function addNewPrescriptionMedicineRelation(prescriptionId, medicineId) {
	await query(
		'insert into prescriptions_medicine_map (id_prescription, id_medicine) values (?, ?);',
		prescriptionId, medicineId
	);
}

async function getPrescriptionReportObject() {
	let report = {};

	let prescriptions = await getPrescriptionReportView();
	for (const prescription of prescriptions) {
		report[prescription.id] = {
			doctorName: prescription.doctor_name,
			doctorSurname: prescription.doctor_surname,
			patientName: prescription.patient_name,
			patientSurname: prescription.patient_surname,
			createdAt: prescription.created,
			expiresAt: prescription.expires,
			fulfilled: prescription.fulfilled,
			medicine: [],
		};
	}

	let medicine = await getMedicinePrescriptionsRelationsView();
	for (const med of medicine) {
		report[med.id_prescription].medicine.push({
			name: med.name,
			price: med.price,
		});
	}

	return report;
}

async function getPrescriptionReportView() {
	return await query('select * from v_prescription_report;');
}

async function getMedicinePrescriptionsRelationsView() {
	return await query('select * from v_medicine_prescriptions_relations;');
}

async function addPrescriptionsFromJsonArray(data) {
	let errors = [];

	beginTransaction();

	for (const prescription of data) {
		try {
			let prescriptionId = await addNewPerscription(prescription.doctorId, prescription.patientId, prescription.expires, false);
			for (const med of prescription.medicine) await addNewPrescriptionMedicineRelation(prescriptionId, med);
		} catch (e) {
			errors.push('Chyba zapisování do databáze při importu: ' + e.message);
		}
	}

	if (errors.length) rollback();
	else commit();

	return errors;
}

module.exports = {
	addPrescriptionTransaction,
	addNewPerscription,
	addNewPrescriptionMedicineRelation,
	getPrescriptionReportObject,
	getPrescriptionReportView,
	getMedicinePrescriptionsRelationsView,
	addPrescriptionsFromJsonArray,
};