const express = require('express');

var router = express.Router();

router.get('/', async function (req, res) {
	res.render('homepage');
});

module.exports = router; 