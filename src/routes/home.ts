import express from 'express';
import { getAllUsers } from '../database/userGateway';

const router = express.Router();

router.get('/', (req, res) => {
    getAllUsers();
    res.render('home',
        {
            pageTitle: 'Balls',
        },
    );
});

export default router;