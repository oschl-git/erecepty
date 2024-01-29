import express from 'express';
import * as medicalInstitutions from '../database/medicalInstitutionGateway';

const router = express.Router();

router.get('/', async function (req, res) {
    console.log(await medicalInstitutions.getAll());
    res.render('home',
        {
            medicalInstitutions: await medicalInstitutions.getAll(),
        },
    );
});

export default router;