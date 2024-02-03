-- eRecepty database export
-- made by Ondřej Schlaichert
-- MySQL 8.0.36

START TRANSACTION;

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


DROP TABLE IF EXISTS `medical_institutions`;
CREATE TABLE `medical_institutions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci NOT NULL,
  `field` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;


DROP TABLE IF EXISTS `medicine`;
CREATE TABLE `medicine` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci NOT NULL,
  `price` decimal(20,4) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;


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


DROP TABLE IF EXISTS `phone_numbers`;
CREATE TABLE `phone_numbers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `phone_number` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;


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


DROP VIEW IF EXISTS `v_medicine_prescriptions_relations`;
CREATE TABLE `v_medicine_prescriptions_relations` (`id_prescription` int, `name` varchar(255), `price` decimal(20,4));


DROP VIEW IF EXISTS `v_prescription_report`;
CREATE TABLE `v_prescription_report` (`id` int, `doctor_name` varchar(255), `doctor_surname` varchar(255), `patient_name` varchar(255), `patient_surname` varchar(255), `created` datetime, `expires` date, `fulfilled` tinyint(1));


DROP TABLE IF EXISTS `v_medicine_prescriptions_relations`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `v_medicine_prescriptions_relations` AS select `prescriptions_medicine_map`.`id_prescription` AS `id_prescription`,`medicine`.`name` AS `name`,`medicine`.`price` AS `price` from (`prescriptions_medicine_map` left join `medicine` on((`prescriptions_medicine_map`.`id_medicine` = `medicine`.`id`)));

DROP TABLE IF EXISTS `v_prescription_report`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `v_prescription_report` AS select `prescriptions`.`id` AS `id`,`doctors`.`name` AS `doctor_name`,`doctors`.`surname` AS `doctor_surname`,`patients`.`name` AS `patient_name`,`patients`.`surname` AS `patient_surname`,`prescriptions`.`created` AS `created`,`prescriptions`.`expires` AS `expires`,`prescriptions`.`fulfilled` AS `fulfilled` from ((`prescriptions` left join `doctors` on((`prescriptions`.`doctors_id` = `doctors`.`id`))) left join `patients` on((`prescriptions`.`patients_id` = `patients`.`id`)));

COMMIT;

-- 2024-02-02 20:12:08