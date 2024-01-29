import connection from './connection';

export function getAllUsers() {
	connection.query('select * from users;', (error, results, fields) => {
		if (error) throw error;
		console.log(results);
	});
}