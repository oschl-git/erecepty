/**
 * Handles the add-doctor route.
 */

const express = require('express');

const router = express.Router();

router.get('/', async function (req, res) {
	res.render('homepage');
});

module.exports = router; 