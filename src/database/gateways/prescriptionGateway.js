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

module.exports = {
	addPrescriptionTransaction,
	addNewPerscription,
	addNewPrescriptionMedicineRelation,
};