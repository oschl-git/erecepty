# eRecepty
**A theoretical government application for issuing digital prescriptions.** It allows several operations on a MySQL database, including adding new doctors, medical institutions and patients, and of course issuing the digital prescriptions themselves. It also allows JSON import of prescriptions and displaying issued prescriptions in a nice, printable format.

**For more detailed information, read the [documentation](docs/DOCUMENTATION.md).**

## How to run?
The application is written in JavaScript using **NodeJS v20.10.0**, so you need to have a NodeJS version which is compatible. It also requires a **MySQL 8.0.36** or compatible database. To run it, do the following:

1. Clone this GitHub repo to a folder on your machine.
2. Run `npm install` to install all packages that are needed as dependencies.
3. Create a MySQL database using the provided .sql scripts. Use [this one](database_export/mysql_schema.sql) to create an empty database, or [this one](database_export/mysql_schema_with_data.sql) to create a database with some testing data already in it.
4. Add an .env file to the project directory in the following format:
```
PORT=<server port>
SECRET_KEY=<secret key>

# Database connection
DB_HOST=<database host>
DB_USER=<database username>
DB_PASSWORD=<database password>
DB_NAME=<database name>
```
Make sure to include the correct database authentication details.

5. Start the application by running `npm run start` or `node .` in the project folder.
6. Congratulations! The app is now running on the port specified in your .env file (or 3000 by default). Have a celebratory chocolate cake.

## Why?
This app is a school project made during my fourth year at SPŠE Ječná. It isn't that bad of an assignment this time.

## Tools used
- JavaScript with NodeJS v20.10.0
- MySQL 8.0.36
- Visual Studio Code
#### Node packages:
- body-parser 1.20.2
- dotenv 16.4.1
- ejs 3.1.9
- express 4.18.2
- express-session 1.18.0
- multer 1.4.5-lts.1
- mysql2 3.9.1
- require-dir 1.2.0