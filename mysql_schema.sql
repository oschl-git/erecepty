SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

SET NAMES utf8mb4;

DROP TABLE IF EXISTS `medical_institutions`;
CREATE TABLE `medical_institutions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci NOT NULL,
  `field` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;


DROP TABLE IF EXISTS `medicine`;
CREATE TABLE `medicine` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_czech_ci NOT NULL,
  `price` decimal(20,4) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;


DROP TABLE IF EXISTS `patients`;
CREATE TABLE `patients` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_czech_ci NOT NULL,
  `surname` varchar(255) COLLATE utf8mb4_czech_ci NOT NULL,
  `phone_number_id` int DEFAULT NULL,
  `identity_number` varchar(255) COLLATE utf8mb4_czech_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `phone_number_id` (`phone_number_id`),
  CONSTRAINT `patients_ibfk_1` FOREIGN KEY (`phone_number_id`) REFERENCES `phone_numbers` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;


DROP TABLE IF EXISTS `phone_numbers`;
CREATE TABLE `phone_numbers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `phone_number` varchar(255) COLLATE utf8mb4_czech_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;


DROP TABLE IF EXISTS `prescriptions`;
CREATE TABLE `prescriptions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `users_id` int NOT NULL,
  `patients_id` int NOT NULL,
  `created` datetime NOT NULL,
  `expires` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `users_id` (`users_id`),
  KEY `patients_id` (`patients_id`),
  CONSTRAINT `prescriptions_ibfk_1` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
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


DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_czech_ci NOT NULL,
  `surname` varchar(255) COLLATE utf8mb4_czech_ci NOT NULL,
  `username` varchar(255) COLLATE utf8mb4_czech_ci NOT NULL,
  `role` enum('doctor, admin') COLLATE utf8mb4_czech_ci NOT NULL,
  `id_medical_institution` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_medical_institution` (`id_medical_institution`),
  CONSTRAINT `users_ibfk_1` FOREIGN KEY (`id_medical_institution`) REFERENCES `medical_institutions` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;