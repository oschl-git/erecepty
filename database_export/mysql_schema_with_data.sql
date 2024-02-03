-- MySQL 8.0.36

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

SET NAMES utf8mb4;

CREATE DATABASE `erecepty` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `erecepty`;

DROP TABLE IF EXISTS `doctors`;
CREATE TABLE `doctors` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci NOT NULL,
  `surname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci NOT NULL,
  `level` enum('stážista','sestřička','doktor','primář') CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci NOT NULL,
  `id_medical_institution` int DEFAULT NULL,
  `identifier` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `identifier` (`identifier`),
  KEY `id_medical_institution` (`id_medical_institution`),
  CONSTRAINT `doctors_ibfk_1` FOREIGN KEY (`id_medical_institution`) REFERENCES `medical_institutions` (`id`) ON DELETE SET NULL,
  CONSTRAINT `doctors_ibfk_2` FOREIGN KEY (`id_medical_institution`) REFERENCES `medical_institutions` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;

INSERT INTO `doctors` (`id`, `name`, `surname`, `level`, `id_medical_institution`, `identifier`) VALUES
(1,	'Jana',	'Dvořáková',	'doktor',	4,	11111),
(2,	'Pavel',	'Novotný',	'stážista',	6,	22222),
(3,	'Alena',	'Marešová',	'primář',	8,	33333),
(4,	'Michal',	'Kubát',	'sestřička',	5,	44444),
(5,	'Martina',	'Veselá',	'doktor',	3,	55555),
(6,	'Lukáš',	'Růžička',	'sestřička',	2,	66666),
(7,	'Kateřina',	'Kopecká',	'primář',	1,	77777),
(8,	'Tomáš',	'Holý',	'stážista',	7,	88888);

DROP TABLE IF EXISTS `medical_institutions`;
CREATE TABLE `medical_institutions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci NOT NULL,
  `field` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;

INSERT INTO `medical_institutions` (`id`, `name`, `field`) VALUES
(1,	'Městská nemocnice Plzeň',	'Vnitřní lékařství'),
(2,	'Fakultní nemocnice Olomouc',	'Chirurgie'),
(3,	'Všeobecná fakultní nemocnice v Praze',	'Neurologie'),
(4,	'Krajská nemocnice Liberec',	'Ortopedie'),
(5,	'Fakultní nemocnice Brno',	'Oftalmologie'),
(6,	'Karlovarská krajská nemocnice',	'Gynekologie'),
(7,	'Nemocnice Na Bulovce',	'Pediatrie'),
(8,	'Univerzitní nemocnice Hradec Králové',	'Kardiochirurgie');

DROP TABLE IF EXISTS `medicine`;
CREATE TABLE `medicine` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci NOT NULL,
  `price` decimal(20,4) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;

INSERT INTO `medicine` (`id`, `name`, `price`) VALUES
(1,	'Amoxicilin',	249.7500),
(2,	'Ranitidin',	162.2500),
(3,	'Diazepam',	306.2500),
(4,	'Vitamin C',	124.7500),
(5,	'Magnézium',	218.7500),
(6,	'Zinková mast',	87.5000),
(7,	'Paralen',	137.5000),
(8,	'Echinacea',	198.7500);

DROP TABLE IF EXISTS `patients`;
CREATE TABLE `patients` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci NOT NULL,
  `surname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci NOT NULL,
  `phone_number_id` int DEFAULT NULL,
  `identity_number` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `identity_number` (`identity_number`),
  KEY `phone_number_id` (`phone_number_id`),
  CONSTRAINT `patients_ibfk_1` FOREIGN KEY (`phone_number_id`) REFERENCES `phone_numbers` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;

INSERT INTO `patients` (`id`, `name`, `surname`, `phone_number_id`, `identity_number`) VALUES
(1,	'Adam',	'Černý',	4,	'890101/1234'),
(2,	'Eliška',	'Nová',	1,	'960202/5678'),
(3,	'Martin',	'Kovář',	5,	'880303/9101'),
(4,	'Nina',	'Pospíšilová',	2,	'750404/2345'),
(5,	'František',	'Svoboda',	6,	'700505/6789'),
(6,	'Veronika',	'Novotná',	3,	'810606/0123'),
(7,	'Ondřej',	'Procházka',	7,	'920707/3456'),
(8,	'Klára',	'Benešová',	8,	'800808/7890');

DROP TABLE IF EXISTS `phone_numbers`;
CREATE TABLE `phone_numbers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `phone_number` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;

INSERT INTO `phone_numbers` (`id`, `phone_number`) VALUES
(1,	'+420111111111'),
(2,	'+420222222222'),
(3,	'+420333333333'),
(4,	'+420444444444'),
(5,	'+420555555555'),
(6,	'+420666666666'),
(7,	'+420777777777'),
(8,	'+420888888888');

DROP TABLE IF EXISTS `prescriptions`;
CREATE TABLE `prescriptions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `doctors_id` int NOT NULL,
  `patients_id` int NOT NULL,
  `created` datetime NOT NULL,
  `expires` date NOT NULL,
  `fulfilled` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `doctors_id` (`doctors_id`),
  KEY `patients_id` (`patients_id`),
  CONSTRAINT `prescriptions_ibfk_1` FOREIGN KEY (`doctors_id`) REFERENCES `doctors` (`id`) ON DELETE CASCADE,
  CONSTRAINT `prescriptions_ibfk_2` FOREIGN KEY (`patients_id`) REFERENCES `patients` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;

INSERT INTO `prescriptions` (`id`, `doctors_id`, `patients_id`, `created`, `expires`, `fulfilled`) VALUES
(1,	3,	4,	'2024-02-10 14:00:00',	'2024-03-10',	0),
(2,	2,	6,	'2024-02-15 09:30:00',	'2024-04-15',	1),
(3,	7,	8,	'2024-02-20 11:45:00',	'2024-05-20',	0),
(4,	1,	2,	'2024-02-25 08:15:00',	'2024-04-25',	1),
(5,	5,	1,	'2024-03-02 16:30:00',	'2024-05-02',	0),
(6,	4,	5,	'2024-03-05 13:00:00',	'2024-06-05',	1),
(7,	6,	7,	'2024-03-10 10:45:00',	'2024-06-10',	0),
(8,	8,	3,	'2024-03-15 12:30:00',	'2024-07-15',	1);

DROP TABLE IF EXISTS `prescriptions_medicine_map`;
CREATE TABLE `prescriptions_medicine_map` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_prescription` int NOT NULL,
  `id_medicine` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_prescription` (`id_prescription`),
  KEY `id_medicine` (`id_medicine`),
  CONSTRAINT `prescriptions_medicine_map_ibfk_1` FOREIGN KEY (`id_prescription`) REFERENCES `prescriptions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `prescriptions_medicine_map_ibfk_2` FOREIGN KEY (`id_medicine`) REFERENCES `medicine` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;

INSERT INTO `prescriptions_medicine_map` (`id`, `id_prescription`, `id_medicine`) VALUES
(1,	1,	4),
(2,	1,	7),
(3,	2,	3),
(4,	2,	6),
(5,	3,	1),
(6,	3,	8),
(7,	4,	5),
(8,	4,	2),
(9,	5,	4),
(10,	5,	3),
(11,	6,	2),
(12,	6,	1),
(13,	7,	8),
(14,	7,	5),
(15,	8,	6),
(16,	8,	7);

DROP VIEW IF EXISTS `v_medicine_prescriptions_relations`;
CREATE TABLE `v_medicine_prescriptions_relations` (`id_prescription` int, `name` varchar(255), `price` decimal(20,4));


DROP VIEW IF EXISTS `v_prescription_report`;
CREATE TABLE `v_prescription_report` (`id` int, `doctor_name` varchar(255), `doctor_surname` varchar(255), `patient_name` varchar(255), `patient_surname` varchar(255), `created` datetime, `expires` date, `fulfilled` tinyint(1));


DROP TABLE IF EXISTS `v_medicine_prescriptions_relations`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `v_medicine_prescriptions_relations` AS select `prescriptions_medicine_map`.`id_prescription` AS `id_prescription`,`medicine`.`name` AS `name`,`medicine`.`price` AS `price` from (`prescriptions_medicine_map` left join `medicine` on((`prescriptions_medicine_map`.`id_medicine` = `medicine`.`id`)));

DROP TABLE IF EXISTS `v_prescription_report`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `v_prescription_report` AS select `prescriptions`.`id` AS `id`,`doctors`.`name` AS `doctor_name`,`doctors`.`surname` AS `doctor_surname`,`patients`.`name` AS `patient_name`,`patients`.`surname` AS `patient_surname`,`prescriptions`.`created` AS `created`,`prescriptions`.`expires` AS `expires`,`prescriptions`.`fulfilled` AS `fulfilled` from ((`prescriptions` left join `doctors` on((`prescriptions`.`doctors_id` = `doctors`.`id`))) left join `patients` on((`prescriptions`.`patients_id` = `patients`.`id`)));

-- 2024-02-02 20:36:02