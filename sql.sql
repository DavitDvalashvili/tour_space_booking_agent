-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               8.0.39 - MySQL Community Server - GPL
-- Server OS:                    Win64
-- HeidiSQL Version:             12.6.0.6765
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for tour_space
CREATE DATABASE IF NOT EXISTS `tour_space_test` /*!40100 DEFAULT CHARACTER SET armscii8 COLLATE armscii8_bin */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `tour_space_test`;

-- Dumping structure for table tour_space.banks
CREATE TABLE IF NOT EXISTS `banks` (
  `bank_id` int NOT NULL AUTO_INCREMENT,
  `swift_code` varchar(11) COLLATE armscii8_bin DEFAULT NULL,
  `bank_name` varchar(50) COLLATE armscii8_bin DEFAULT NULL,
  PRIMARY KEY (`bank_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.banks: ~2 rows (approximately)
INSERT INTO `banks` (`bank_id`, `swift_code`, `bank_name`) VALUES
	(1, 'TBCCGE22', 'TBC BANK'),
	(2, '22CBGE23', 'BANK OF GEORGIA');

-- Dumping structure for table tour_space.bank_accounts
CREATE TABLE IF NOT EXISTS `bank_accounts` (
  `bank_account_id` int NOT NULL AUTO_INCREMENT,
  `bank_id` int DEFAULT NULL,
  `iban` varchar(30) COLLATE armscii8_bin DEFAULT NULL,
  `company_id` int DEFAULT NULL,
  PRIMARY KEY (`bank_account_id`),
  KEY `FK_bank_accounts_bank` (`bank_id`),
  KEY `FK_bank_accounts_companies` (`company_id`),
  CONSTRAINT `FK_bank_accounts_bank` FOREIGN KEY (`bank_id`) REFERENCES `banks` (`bank_id`),
  CONSTRAINT `FK_bank_accounts_companies` FOREIGN KEY (`company_id`) REFERENCES `companies` (`company_id`)
) ENGINE=InnoDB AUTO_INCREMENT=96 DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.bank_accounts: ~2 rows (approximately)
INSERT INTO `bank_accounts` (`bank_account_id`, `bank_id`, `iban`, `company_id`) VALUES
	(94, 2, '25656555555555', 30),
	(95, 1, '666669856478513', 30);

-- Dumping structure for table tour_space.bank_account_translations
CREATE TABLE IF NOT EXISTS `bank_account_translations` (
  `bank_account_translation_id` int NOT NULL AUTO_INCREMENT,
  `bank_account_holder` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `language_id` int DEFAULT NULL,
  `bank_account_id` int DEFAULT NULL,
  PRIMARY KEY (`bank_account_translation_id`),
  KEY `FK_bank_account_translations_bank_accounts` (`bank_account_id`),
  KEY `FK_bank_account_translations_languages` (`language_id`),
  CONSTRAINT `FK_bank_account_translations_bank_accounts` FOREIGN KEY (`bank_account_id`) REFERENCES `bank_accounts` (`bank_account_id`) ON DELETE CASCADE,
  CONSTRAINT `FK_bank_account_translations_languages` FOREIGN KEY (`language_id`) REFERENCES `languages` (`language_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=157 DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.bank_account_translations: ~6 rows (approximately)
INSERT INTO `bank_account_translations` (`bank_account_translation_id`, `bank_account_holder`, `language_id`, `bank_account_id`) VALUES
	(151, 'Giorgi Dvalashvili', 1, 94),
	(152, 'Giorgi Dvalashvili', 1, 95),
	(153, 'გიორგი დვალაშვილი', 2, 94),
	(154, 'გიორგი დვალაშვილი', 2, 95),
	(155, 'Георги Двалашвили', 3, 94),
	(156, 'Георги Двалашвили', 3, 95);

-- Dumping structure for table tour_space.bookings
CREATE TABLE IF NOT EXISTS `bookings` (
  `booking_id` int NOT NULL AUTO_INCREMENT,
  `event_id` int DEFAULT NULL,
  `waiting` int DEFAULT '0',
  `total_price` int DEFAULT NULL,
  `client_count` int DEFAULT NULL,
  `payment_status_id` int DEFAULT NULL,
  `submit_status` int DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `is_deleted` int DEFAULT '0',
  PRIMARY KEY (`booking_id`),
  KEY `FK_bookings_events` (`event_id`),
  KEY `FK_bookings_payment_status` (`payment_status_id`),
  CONSTRAINT `FK_bookings_events` FOREIGN KEY (`event_id`) REFERENCES `events` (`event_id`) ON DELETE CASCADE,
  CONSTRAINT `FK_bookings_payment_status` FOREIGN KEY (`payment_status_id`) REFERENCES `payment_status` (`payment_status_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1274 DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.bookings: ~8 rows (approximately)
INSERT INTO `bookings` (`booking_id`, `event_id`, `waiting`, `total_price`, `client_count`, `payment_status_id`, `submit_status`, `created_at`, `is_deleted`) VALUES
	(1264, 198, 0, 140, 2, 3, 1, '2026-03-26 16:14:40', 0),
	(1265, 198, 0, 70, 1, 2, 1, '2026-03-26 16:15:25', 0),
	(1266, 198, 0, 1190, 17, 1, 1, '2026-03-26 16:16:13', 0),
	(1267, 198, 1, 140, 2, NULL, 1, '2026-03-26 16:17:16', 0),
	(1269, 201, 0, 140, 2, 1, 1, '2026-03-29 00:50:03', 0),
	(1270, 202, 0, 100, 2, 3, 1, '2026-03-29 02:11:08', 0),
	(1271, 202, 0, 900, 18, 4, 1, '2026-03-29 02:24:24', 0),
	(1272, 202, 1, 100, 1, NULL, 1, '2026-03-29 02:24:44', 0);

-- Dumping structure for table tour_space.categories
CREATE TABLE IF NOT EXISTS `categories` (
  `category_id` int NOT NULL AUTO_INCREMENT,
  `category` varchar(50) CHARACTER SET armscii8 COLLATE armscii8_bin DEFAULT NULL,
  PRIMARY KEY (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.categories: ~8 rows (approximately)
INSERT INTO `categories` (`category_id`, `category`) VALUES
	(1, 'adventure'),
	(2, 'hiking'),
	(3, 'historical'),
	(4, 'gastronomy'),
	(5, 'eco'),
	(6, 'city_tour'),
	(7, 'nature'),
	(8, 'cultural');

-- Dumping structure for table tour_space.category_translations
CREATE TABLE IF NOT EXISTS `category_translations` (
  `translation_id` int NOT NULL AUTO_INCREMENT,
  `category_id` int DEFAULT NULL,
  `category_name` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `language_id` int DEFAULT NULL,
  PRIMARY KEY (`translation_id`),
  KEY `FK_category_translations_languages` (`language_id`),
  KEY `FK_category_translations_categories` (`category_id`),
  CONSTRAINT `FK_category_translations_categories` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`),
  CONSTRAINT `FK_category_translations_languages` FOREIGN KEY (`language_id`) REFERENCES `languages` (`language_id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.category_translations: ~24 rows (approximately)
INSERT INTO `category_translations` (`translation_id`, `category_id`, `category_name`, `language_id`) VALUES
	(1, 1, 'Adventure', 1),
	(2, 1, 'თავგადასავალი', 2),
	(3, 1, 'Приключения', 3),
	(4, 2, 'Hiking', 1),
	(5, 2, 'ჰაიქინგი', 2),
	(6, 2, 'Пешие походы', 3),
	(7, 3, 'Historical', 1),
	(8, 3, 'ისტორიული', 2),
	(9, 3, 'Исторический', 3),
	(10, 4, 'Gastronomy', 1),
	(11, 4, 'გასტრონომიული', 2),
	(12, 4, 'Гастрономия', 3),
	(13, 5, 'Eco', 1),
	(14, 5, 'ეკო', 2),
	(15, 5, 'Эко', 3),
	(16, 6, 'City Tour', 1),
	(17, 6, 'ქალაქის ტური', 2),
	(18, 6, 'Городской тур', 3),
	(19, 7, 'Nature', 1),
	(20, 7, 'ბუნება', 2),
	(21, 7, 'Природа', 3),
	(22, 8, 'Cultural', 1),
	(23, 8, 'კულტურული', 2),
	(24, 8, 'Культурный', 3);

-- Dumping structure for table tour_space.clients
CREATE TABLE IF NOT EXISTS `clients` (
  `client_id` int NOT NULL AUTO_INCREMENT,
  `booking_id` int DEFAULT NULL,
  `email` varchar(50) CHARACTER SET armscii8 COLLATE armscii8_bin DEFAULT NULL,
  `phone` varchar(50) CHARACTER SET armscii8 COLLATE armscii8_bin DEFAULT NULL,
  `contact_person` int DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `is_deleted` int DEFAULT '0',
  PRIMARY KEY (`client_id`),
  KEY `FK_clients_bookings` (`booking_id`),
  CONSTRAINT `FK_clients_bookings` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=585 DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.clients: ~8 rows (approximately)
INSERT INTO `clients` (`client_id`, `booking_id`, `email`, `phone`, `contact_person`, `created_at`, `is_deleted`) VALUES
	(575, 1264, 'davitdvalashvili@gmail.com', '598332135', 1, '2026-03-26 16:14:40', 0),
	(576, 1265, 'tourspace.g2e@gmail.com', '555392135', 1, '2026-03-26 16:15:25', 0),
	(577, 1266, 'levangamba2026@gmai.com', '598332135', 1, '2026-03-26 16:16:13', 0),
	(578, 1267, 'davittsuladze@gmail.com', '598332134', 1, '2026-03-26 16:17:16', 0),
	(580, 1269, 'davitdvalashvili@gmail.com', '598332135', 1, '2026-03-29 00:50:03', 0),
	(581, 1270, 'davitdvalashvili@gmail.com', '598332135', 1, '2026-03-29 02:11:08', 0),
	(582, 1271, 'davitdvalashvili@gmail.com', '598332135', 1, '2026-03-29 02:24:24', 0),
	(583, 1272, 'davitdvalashvili@gmail.com', '598332135', 1, '2026-03-29 02:24:44', 0);

-- Dumping structure for table tour_space.client_translations
CREATE TABLE IF NOT EXISTS `client_translations` (
  `client_translation_id` int NOT NULL AUTO_INCREMENT,
  `client_id` int DEFAULT NULL,
  `language_id` int DEFAULT NULL,
  `first_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `last_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`client_translation_id`),
  KEY `FK_client_translations_languages` (`language_id`),
  KEY `FK_client_translations_clients` (`client_id`),
  CONSTRAINT `FK_client_translations_clients` FOREIGN KEY (`client_id`) REFERENCES `clients` (`client_id`) ON DELETE CASCADE,
  CONSTRAINT `FK_client_translations_languages` FOREIGN KEY (`language_id`) REFERENCES `languages` (`language_id`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.client_translations: ~21 rows (approximately)
INSERT INTO `client_translations` (`client_translation_id`, `client_id`, `language_id`, `first_name`, `last_name`) VALUES
	(19, 575, 1, 'გიორგი', 'ლომაძე'),
	(20, 575, 2, 'გიორგი', 'ლომაძე'),
	(21, 575, 3, 'გიორგი', 'ლომაძე'),
	(22, 576, 1, 'ვახო', 'დადიანი'),
	(23, 576, 2, 'ვახო', 'დადიანი'),
	(24, 576, 3, 'ვახო', 'დადიანი'),
	(25, 577, 1, 'ლევან', 'ღამბაშიძე'),
	(26, 577, 2, 'ლევან', 'ღამბაშიძე'),
	(27, 577, 3, 'ლევან', 'ღამბაშიძე'),
	(28, 578, 1, 'დავით', 'წულაძე'),
	(29, 578, 2, 'დავით', 'წულაძე'),
	(30, 578, 3, 'დავით', 'წულაძე'),
	(34, 580, 1, 'Davit', 'Dvalashvili'),
	(35, 580, 2, 'Davit', 'Dvalashvili'),
	(36, 580, 3, 'Davit', 'Dvalashvili'),
	(37, 581, 1, 'Davit', 'Dvalashvili'),
	(38, 581, 2, 'Davit', 'Dvalashvili'),
	(39, 581, 3, 'Davit', 'Dvalashvili'),
	(40, 582, 1, 'Davit', 'Dvalashvili'),
	(41, 582, 2, 'Davit', 'Dvalashvili'),
	(42, 582, 3, 'Davit', 'Dvalashvili'),
	(43, 583, 1, 'Davit', 'Dvalashvili'),
	(44, 583, 2, 'Davit', 'Dvalashvili'),
	(45, 583, 3, 'Davit', 'Dvalashvili');

-- Dumping structure for table tour_space.companies
CREATE TABLE IF NOT EXISTS `companies` (
  `company_id` int NOT NULL AUTO_INCREMENT,
  `company_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `email` varchar(100) CHARACTER SET armscii8 COLLATE armscii8_bin DEFAULT NULL,
  `password_hash` text CHARACTER SET armscii8 COLLATE armscii8_bin,
  `phone` varchar(30) CHARACTER SET armscii8 COLLATE armscii8_bin DEFAULT NULL,
  `role_id` int DEFAULT NULL,
  `preferred_language_id` int DEFAULT NULL,
  `create_at` datetime DEFAULT NULL,
  `image` varchar(250) CHARACTER SET armscii8 COLLATE armscii8_bin DEFAULT NULL,
  `identification_number` varchar(50) COLLATE armscii8_bin DEFAULT NULL,
  `county_id` int DEFAULT NULL,
  `subscription_id` int DEFAULT '0',
  `payment_percentage` int DEFAULT NULL,
  `advanced_payment` int DEFAULT NULL,
  `full_payment_days_before` int DEFAULT '0',
  `recovery_code_hash` text COLLATE armscii8_bin,
  `recovery_code_expire` datetime DEFAULT NULL,
  PRIMARY KEY (`company_id`) USING BTREE,
  UNIQUE KEY `email` (`email`),
  KEY `FK_tour_operators_roles` (`role_id`),
  KEY `FK_tour_operators_languages` (`preferred_language_id`),
  KEY `FK_tour_operators_countries` (`county_id`),
  KEY `FK_tour_operators_status` (`subscription_id`) USING BTREE,
  CONSTRAINT `FK_tour_operators_countries` FOREIGN KEY (`county_id`) REFERENCES `countries` (`country_id`),
  CONSTRAINT `FK_tour_operators_languages` FOREIGN KEY (`preferred_language_id`) REFERENCES `languages` (`language_id`),
  CONSTRAINT `FK_tour_operators_roles` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`),
  CONSTRAINT `FK_tour_operators_status` FOREIGN KEY (`subscription_id`) REFERENCES `subscriptions` (`subscription_id`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.companies: ~15 rows (approximately)
INSERT INTO `companies` (`company_id`, `company_name`, `email`, `password_hash`, `phone`, `role_id`, `preferred_language_id`, `create_at`, `image`, `identification_number`, `county_id`, `subscription_id`, `payment_percentage`, `advanced_payment`, `full_payment_days_before`, `recovery_code_hash`, `recovery_code_expire`) VALUES
	(26, 'Travel Me', 'DvalaTravel6@gmail.com', '$2b$10$4Y38QF/D20iMcVk/cFXWfOIaFPFgBAYvZOmf2qGWsyinPzXZcbRY6', '555336984', 2, NULL, '2025-12-10 00:00:00', '2.png', NULL, NULL, 0, NULL, NULL, 3, NULL, NULL),
	(27, 'Traveling Dream Destinations', 'DvalaTravel5@gmail.com', '$2b$10$TSAxfBUPV0n2DzbDF92DeOKdwzbzcL/hulGedlqMUtFzv1aNM5Hn.', '588996347', 2, NULL, '2025-12-10 00:00:00', '5.png', NULL, NULL, 0, NULL, NULL, 3, NULL, NULL),
	(28, 'Zehndi Travel', 'DvalaTravel4@gmail.com', '$2b$10$2Ah7O1hwkvW3dNFEdSv8DeKVfKgi6cPvTqVtJpbyIhrlVsMi6SUGm', '555336874', 2, NULL, '2025-12-10 00:00:00', '3.png', NULL, NULL, 0, NULL, NULL, 3, NULL, NULL),
	(29, 'Trivago', 'DvalaTravel3@gmail.com', '$2b$10$uyOmJZJ8/tGyQ3glgtWOBe/AI2OaIt7u0zrk9a17Y9RgAcFgv/k7G', '598715628', 2, NULL, '2025-12-10 00:00:00', '1.png', NULL, NULL, 0, NULL, NULL, 3, NULL, NULL),
	(30, 'Travel Me', 'giorgi.mikeladze17@gmail.com', '$2b$10$Aa7T7OqDW98SjBOajXOp6e9M2HiwH3/muCS1emmoazp5lMZIuA2XG', '598996633', 2, NULL, '2025-12-10 00:00:00', 'companies/30/profile.webp', '26536596', NULL, 1, 20, 1, 0, '$2b$10$TPh08BZf1KQzfvmymTu.le7ldurNa9wslpJlGcpC/edrHEDTV826S', '2026-03-30 21:36:16'),
	(32, 'DvalaTravel', 'Travelfy22025@gmail.com', '$2b$10$NuE4AxlFdgWN.t3GxngHPeQZ4KfO31CDyn2EX7PA16lcHd2lvFJ3m', '598337135', 2, NULL, '2025-12-19 00:00:00', NULL, '26536598', NULL, 0, NULL, NULL, 3, '$2b$10$l93QMxudjkUo/u.C1P8cmOn.2wf2PVtX2gOGeicManvUHdBN0f0ky', '2026-01-10 04:13:00'),
	(33, 'ragaca kompania', 'Travelfy2025@gmail.com', '$2b$10$LPpN1.px59MwLrbwPP76TunGpySALWXmKCwdlf.iPR74Rtnsph6gW', '598336655', 2, NULL, '2026-01-08 00:00:00', NULL, NULL, NULL, 0, NULL, NULL, 3, NULL, NULL),
	(34, 'TOURSPACE', 'tourspac2e.ge@gmail.com', '$2b$10$g7.rUAkRbdjx3WwJdWMUsu/njdxZtsm9ntP1ZUakvcuQVVwSZh4wC', '598332137', 2, NULL, '2026-01-08 00:00:00', NULL, NULL, NULL, 0, NULL, NULL, 3, NULL, NULL),
	(35, 'TOURSPACE', 'davitdvalashvilissd@gmail.com', '$2b$10$6bVfEGcv/b.t6WV0N6WJnu/6hBIvQru2zJutjaIdNLxVKWthbVIgO', '598332134', 2, NULL, '2026-01-08 00:00:00', NULL, NULL, NULL, 0, NULL, NULL, 3, NULL, NULL),
	(36, 'TOURSPACE', 'tourspace2.ge@gmail.com', '$2b$10$p7VzO1CRIB8HAk/Uaz4AP.YAA2S6CC2VKZ9oUs2nMzkGSXqAM.ePO', '598332130', 2, NULL, '2026-01-08 00:00:00', NULL, NULL, NULL, 0, NULL, NULL, 3, NULL, NULL),
	(37, 'Travel Me', 'giorgi.mikeladze18@gmail.com', '$2b$10$xjHet90msN8ER6dhLyL2heKtHQx72gkA7ATeGkBYxtp0asC0454vu', '591443023', 2, NULL, '2026-01-26 00:00:00', NULL, NULL, NULL, 0, NULL, NULL, NULL, '$2b$10$jQX4HMmLezkx8pD0ux2CxOQJMaaptCjTHooBN3N5.MfGxCs0f9J2S', '2026-01-26 01:37:56'),
	(39, 'Dvala2325', 'davitdvalashvili2@gmail.com', '$2b$10$oxiWicso5.jA4O1PeKQDc.TaEFILnyqzg4PCI4IwMkRLeLoSDQU8q', '598332135', 2, NULL, '2026-01-26 00:00:00', NULL, NULL, NULL, 0, NULL, NULL, NULL, '$2b$10$egeRhwlxGNWv7ypHuzDhwu8cxTXHnynrfzWgj0ZuqZWwJW.l9fctq', '2026-01-26 02:20:36'),
	(40, 'NEW TRAVEL COMPANY', 'giorgi.mikeladze172@gmail.com', '$2b$10$xjHet90msN8ER6dhLyL2heKtHQx72gkA7ATeGkBYxtp0asC0454vu', '598332136', 2, NULL, '2026-02-08 00:00:00', NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL),
	(41, 'TourSpace2', 'tours55pace.ge@gmail.com', '$2b$10$n6fyJ7LeeQY9L6wm0uEd.Or3B4AgioEXfk4vdt/wb3aiqa56NWpCS', '598732137', 2, NULL, '2026-02-11 00:00:00', NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL),
	(42, 'newcompany', 'davitdvalashvili@gmail.com', '$2b$10$CSRXnQbSA3uXdf2IP31BmusdRyEsgWgZQh1ASPvPOKoVJnj5.9zum', '598332155', 2, NULL, '2026-03-30 00:00:00', NULL, NULL, NULL, 0, NULL, NULL, 0, '$2b$10$tlrD3jHI.YoUQ/MYcviAvugsbFsQG4eH2MvihWwP5bhNomzSvGHDi', '2026-03-30 21:59:05');

-- Dumping structure for table tour_space.company_categories
CREATE TABLE IF NOT EXISTS `company_categories` (
  `company_category_id` int NOT NULL AUTO_INCREMENT,
  `company_id` int DEFAULT NULL,
  `category_id` int DEFAULT NULL,
  PRIMARY KEY (`company_category_id`),
  KEY `FK_company_categories_companies` (`company_id`),
  KEY `FK_company_categories_categories` (`category_id`),
  CONSTRAINT `FK_company_categories_categories` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`),
  CONSTRAINT `FK_company_categories_companies` FOREIGN KEY (`company_id`) REFERENCES `companies` (`company_id`)
) ENGINE=InnoDB AUTO_INCREMENT=176 DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.company_categories: ~13 rows (approximately)
INSERT INTO `company_categories` (`company_category_id`, `company_id`, `category_id`) VALUES
	(102, 39, 8),
	(103, 39, 3),
	(104, 39, 5),
	(105, 39, 1),
	(106, 39, 6),
	(107, 27, 7),
	(169, 41, 6),
	(170, 30, 8),
	(171, 30, 5),
	(172, 30, 3),
	(173, 30, 1),
	(174, 30, 7),
	(175, 30, 6);

-- Dumping structure for table tour_space.company_contact
CREATE TABLE IF NOT EXISTS `company_contact` (
  `contact_id` int NOT NULL AUTO_INCREMENT,
  `company_id` int DEFAULT NULL,
  `email` varchar(100) COLLATE armscii8_bin DEFAULT NULL,
  `phone` varchar(100) COLLATE armscii8_bin DEFAULT NULL,
  `facebook` varchar(100) COLLATE armscii8_bin DEFAULT NULL,
  `instagram` varchar(100) COLLATE armscii8_bin DEFAULT NULL,
  `website` varchar(100) CHARACTER SET armscii8 COLLATE armscii8_bin DEFAULT NULL,
  `sms_service_id` int DEFAULT NULL,
  `sms_sender_name` varchar(50) CHARACTER SET armscii8 COLLATE armscii8_bin DEFAULT NULL,
  `email_sender_name` varchar(50) CHARACTER SET armscii8 COLLATE armscii8_bin DEFAULT NULL,
  `is_email_verified` int DEFAULT NULL,
  `is_sms_verified` int DEFAULT NULL,
  PRIMARY KEY (`contact_id`),
  KEY `FK_company_contact_companies` (`company_id`),
  CONSTRAINT `FK_company_contact_companies` FOREIGN KEY (`company_id`) REFERENCES `companies` (`company_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.company_contact: ~1 rows (approximately)
INSERT INTO `company_contact` (`contact_id`, `company_id`, `email`, `phone`, `facebook`, `instagram`, `website`, `sms_service_id`, `sms_sender_name`, `email_sender_name`, `is_email_verified`, `is_sms_verified`) VALUES
	(1, 30, 'davitdvalashvili@gmail.com', '598996633', 'https://www.facebook.com/zehdi', 'https://www.instagram.com/zehdi', 'tourspace.ge', 3, 'TravelMe', 'Travelme', 1, 1);

-- Dumping structure for table tour_space.company_guides
CREATE TABLE IF NOT EXISTS `company_guides` (
  `compnay_guide_id` int NOT NULL AUTO_INCREMENT,
  `company_id` int DEFAULT NULL,
  `guide_id` int DEFAULT NULL,
  `activation_time` datetime DEFAULT NULL,
  `deactivation_time` datetime DEFAULT NULL,
  `show_on_homepage` int DEFAULT NULL,
  `is_deleted` int DEFAULT '0',
  PRIMARY KEY (`compnay_guide_id`) USING BTREE,
  KEY `FK_tour_operator_guides_tour_operators` (`company_id`) USING BTREE,
  KEY `FK_company_guides_guide` (`guide_id`),
  CONSTRAINT `FK_company_guides_companies` FOREIGN KEY (`company_id`) REFERENCES `companies` (`company_id`),
  CONSTRAINT `FK_company_guides_guide` FOREIGN KEY (`guide_id`) REFERENCES `guides` (`guide_id`)
) ENGINE=InnoDB AUTO_INCREMENT=90 DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.company_guides: ~13 rows (approximately)
INSERT INTO `company_guides` (`compnay_guide_id`, `company_id`, `guide_id`, `activation_time`, `deactivation_time`, `show_on_homepage`, `is_deleted`) VALUES
	(75, 28, 57, '2026-01-15 01:31:15', '2026-01-22 23:24:33', 1, 0),
	(76, 29, 58, '2026-01-15 01:31:15', '2026-02-04 22:48:48', 1, 0),
	(77, 37, 59, '2026-01-15 01:31:15', '2026-02-04 22:48:49', 1, 0),
	(78, 33, 60, '2026-01-15 01:31:15', '2026-02-04 22:48:50', 1, 0),
	(79, 35, 62, '2026-01-15 01:30:49', '2026-02-04 22:48:50', 1, 0),
	(80, 30, 57, NULL, NULL, 0, 0),
	(81, 30, 58, NULL, NULL, 1, 0),
	(82, 30, 63, '2026-02-10 16:22:54', NULL, 1, 0),
	(83, 30, 64, '2026-02-24 16:12:26', '2026-02-24 16:26:24', 0, 1),
	(84, 30, 65, '2026-02-24 16:26:59', '2026-02-25 02:08:30', 1, 1),
	(85, 30, 66, '2026-03-01 21:39:20', '2026-03-01 22:57:16', 0, 1),
	(86, 30, 67, '2026-03-01 21:51:59', '2026-03-01 22:57:19', 0, 1),
	(87, 30, 68, '2026-03-01 22:55:49', '2026-03-01 22:57:23', 0, 1),
	(88, 30, 69, '2026-03-15 00:51:49', NULL, 0, 0),
	(89, 30, 70, '2026-03-19 21:24:02', NULL, 0, 0);

-- Dumping structure for table tour_space.company_images
CREATE TABLE IF NOT EXISTS `company_images` (
  `image_id` int NOT NULL AUTO_INCREMENT,
  `company_id` int DEFAULT NULL,
  `image` varchar(150) CHARACTER SET armscii8 COLLATE armscii8_bin DEFAULT NULL,
  PRIMARY KEY (`image_id`),
  KEY `FK_tour_operator_images_tour_operators` (`company_id`) USING BTREE,
  CONSTRAINT `FK_company_images_companies` FOREIGN KEY (`company_id`) REFERENCES `companies` (`company_id`)
) ENGINE=InnoDB AUTO_INCREMENT=182 DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.company_images: ~11 rows (approximately)
INSERT INTO `company_images` (`image_id`, `company_id`, `image`) VALUES
	(159, 40, 'companies/40/images/companyImage-40-1770538100091-817.webp'),
	(160, 40, 'companies/40/images/companyImage-40-1770538101130-7.webp'),
	(161, 40, 'companies/40/images/companyImage-40-1770538101538-12.webp'),
	(162, 40, 'companies/40/images/companyImage-40-1770538101814-956.webp'),
	(163, 40, 'companies/40/images/companyImage-40-1770538102156-817.webp'),
	(164, 41, 'companies/41/images/companyImage-41-1770791343881-309.webp'),
	(165, 41, 'companies/41/images/companyImage-41-1770791345122-140.webp'),
	(166, 41, 'companies/41/images/companyImage-41-1770791345473-672.webp'),
	(177, 30, 'companies/30/images/companyImage-30-1774521202907-184.webp'),
	(178, 30, 'companies/30/images/companyImage-30-1774521203422-776.webp'),
	(179, 30, 'companies/30/images/companyImage-30-1774521204107-68.webp'),
	(180, 30, 'companies/30/images/companyImage-30-1774623978641-612.webp'),
	(181, 30, 'companies/30/images/companyImage-30-1774623979190-56.webp');

-- Dumping structure for table tour_space.company_languages
CREATE TABLE IF NOT EXISTS `company_languages` (
  `company_language_id` int NOT NULL AUTO_INCREMENT,
  `company_id` int DEFAULT NULL,
  `language_id` int DEFAULT NULL,
  PRIMARY KEY (`company_language_id`),
  KEY `FK_company_languages_languages` (`language_id`),
  KEY `FK_company_languages_companies` (`company_id`),
  CONSTRAINT `FK_company_languages_companies` FOREIGN KEY (`company_id`) REFERENCES `companies` (`company_id`),
  CONSTRAINT `FK_company_languages_languages` FOREIGN KEY (`language_id`) REFERENCES `languages` (`language_id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.company_languages: ~4 rows (approximately)
INSERT INTO `company_languages` (`company_language_id`, `company_id`, `language_id`) VALUES
	(29, 41, 3),
	(30, 41, 2),
	(31, 30, 1),
	(32, 30, 2);

-- Dumping structure for table tour_space.company_media
CREATE TABLE IF NOT EXISTS `company_media` (
  `media_id` int NOT NULL AUTO_INCREMENT,
  `video_url` varchar(250) CHARACTER SET armscii8 COLLATE armscii8_bin DEFAULT NULL,
  `company_id` int DEFAULT NULL,
  PRIMARY KEY (`media_id`),
  KEY `company_id` (`company_id`),
  CONSTRAINT `FK_company_media_companies` FOREIGN KEY (`company_id`) REFERENCES `companies` (`company_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.company_media: ~2 rows (approximately)
INSERT INTO `company_media` (`media_id`, `video_url`, `company_id`) VALUES
	(4, 'https://www.youtube.com/watch?v=F9E8nIKjkYc', 40),
	(5, 'https://www.youtube.com/watch?v=Xj4E0Zry6K4', 30),
	(6, 'https://www.youtube.com/watch?v=SqLMKz-A2cA', 41);

-- Dumping structure for table tour_space.company_regions
CREATE TABLE IF NOT EXISTS `company_regions` (
  `company_region_id` int NOT NULL AUTO_INCREMENT,
  `company_id` int DEFAULT NULL,
  `region_id` int DEFAULT NULL,
  PRIMARY KEY (`company_region_id`),
  KEY `FK_company_regions_companies` (`company_id`),
  KEY `FK_company_regions_regions` (`region_id`),
  CONSTRAINT `FK_company_regions_companies` FOREIGN KEY (`company_id`) REFERENCES `companies` (`company_id`),
  CONSTRAINT `FK_company_regions_regions` FOREIGN KEY (`region_id`) REFERENCES `regions` (`region_id`)
) ENGINE=InnoDB AUTO_INCREMENT=96 DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.company_regions: ~1 rows (approximately)
INSERT INTO `company_regions` (`company_region_id`, `company_id`, `region_id`) VALUES
	(94, 41, 1),
	(95, 30, 1);

-- Dumping structure for table tour_space.company_reviews
CREATE TABLE IF NOT EXISTS `company_reviews` (
  `company_review_id` int NOT NULL AUTO_INCREMENT,
  `company_id` int DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `review_score` int DEFAULT NULL,
  PRIMARY KEY (`company_review_id`) USING BTREE,
  KEY `FK_company_reviews_users` (`user_id`),
  KEY `FK_company_reviews_companies` (`company_id`),
  CONSTRAINT `FK_company_reviews_companies` FOREIGN KEY (`company_id`) REFERENCES `companies` (`company_id`),
  CONSTRAINT `FK_company_reviews_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.company_reviews: ~0 rows (approximately)

-- Dumping structure for table tour_space.company_review_translations
CREATE TABLE IF NOT EXISTS `company_review_translations` (
  `translation_id` int NOT NULL AUTO_INCREMENT,
  `review_text` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `language_id` int DEFAULT NULL,
  `company_reviw_id` int DEFAULT NULL,
  PRIMARY KEY (`translation_id`),
  KEY `FK_review_translations_languages` (`language_id`),
  KEY `FK_company_review_translations_company_reviews` (`company_reviw_id`),
  CONSTRAINT `FK_company_review_translations_company_reviews` FOREIGN KEY (`company_reviw_id`) REFERENCES `company_reviews` (`company_review_id`),
  CONSTRAINT `FK_review_translations_languages` FOREIGN KEY (`language_id`) REFERENCES `languages` (`language_id`)
) ENGINE=InnoDB DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.company_review_translations: ~0 rows (approximately)

-- Dumping structure for table tour_space.company_tour_types
CREATE TABLE IF NOT EXISTS `company_tour_types` (
  `company_tour_type_id` int NOT NULL AUTO_INCREMENT,
  `company_id` int DEFAULT NULL,
  `tour_type_id` int DEFAULT NULL,
  PRIMARY KEY (`company_tour_type_id`),
  KEY `FK_company_tour_types_companies` (`company_id`),
  KEY `FK_company_tour_types_tour_types` (`tour_type_id`),
  CONSTRAINT `FK_company_tour_types_companies` FOREIGN KEY (`company_id`) REFERENCES `companies` (`company_id`),
  CONSTRAINT `FK_company_tour_types_tour_types` FOREIGN KEY (`tour_type_id`) REFERENCES `tour_types` (`tour_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.company_tour_types: ~4 rows (approximately)
INSERT INTO `company_tour_types` (`company_tour_type_id`, `company_id`, `tour_type_id`) VALUES
	(50, 41, 2),
	(51, 41, 3),
	(52, 30, 1),
	(53, 30, 3);

-- Dumping structure for table tour_space.company_translations
CREATE TABLE IF NOT EXISTS `company_translations` (
  `translations_id` int NOT NULL AUTO_INCREMENT,
  `company_id` int DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `language_id` int DEFAULT NULL,
  `tagline` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`translations_id`),
  KEY `FK_tour_operator_translations_languages` (`language_id`),
  KEY `FK_tour_operator_translations_tour_operators` (`company_id`) USING BTREE,
  CONSTRAINT `FK_company_translations_companies` FOREIGN KEY (`company_id`) REFERENCES `companies` (`company_id`),
  CONSTRAINT `FK_tour_operator_translations_languages` FOREIGN KEY (`language_id`) REFERENCES `languages` (`language_id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.company_translations: ~19 rows (approximately)
INSERT INTO `company_translations` (`translations_id`, `company_id`, `description`, `language_id`, `tagline`) VALUES
	(2, 26, 'სანდო ტურისტული კომპანია, რომელიც გთავაზობთ გიდირებულ ტურებს და პაკეტებს საქართველოს მასშტაბით.', 2, NULL),
	(3, 26, 'Надежное туристическое агентство, предлагающее туры и отдых по всей Грузии.', 3, NULL),
	(4, 27, 'Specializing in personalized dream vacations and premium travel experiences.', 1, NULL),
	(5, 27, 'სპეციალიზდება პერსონალიზირებულ სამოგზაურო გამოცდილებებსა და პრემიუმ ტურებში.', 2, NULL),
	(6, 27, 'Специализируется на персонализированных путешествиях и премиальных турах.', 3, NULL),
	(7, 28, 'Tour company offering adventure trips and cultural tours throughout Georgia.', 1, NULL),
	(8, 28, 'სათავგადასავლო და კულტურული ტურების პროვაიდერი საქართველოს სხვადასხვა რეგიონში.', 2, NULL),
	(9, 28, 'Компания, предлагающая приключенческие и культурные туры по всей Грузии.', 3, NULL),
	(10, 29, 'International travel brand helping customers compare and book top-rated tours.', 1, NULL),
	(11, 29, 'საერთაშორისო სამოგზაურო ბრენდი, რომელიც გეხმარებათ ტოპ ტურების შერჩევასა და დაჯავშნაში.', 2, NULL),
	(12, 29, 'Международный туристический бренд, помогающий сравнивать и бронировать лучшие туры.', 3, NULL),
	(13, 30, 'We offer simple, reliable, and individually tailored travel planning in Georgia and beyond.', 1, 'Hezdi Travel is a travel company that offers its customers comfortable and reliable travel planning.'),
	(14, 30, 'ჩვენ გთავაზობთ მარტივ, სანდო და ინდივიდუალურად მორგებულ მოგზაურობის დაგეგმვას საქართველოში და მის ფარგლებს გარეთ.', 2, 'Hezdi Travel არის ტურისტული კომპანია, რომელიც მომხმარებლებს სთავაზობს კომფორტულ და სანდო მოგზაურობის დაგეგმ'),
	(15, 30, 'Мы предлагаем простое, надежное и индивидуально разработанное планирование путешествий по Грузии и за ее пределами.', 3, 'Hezdi Travel — это туристическая компания, предлагающая своим клиентам комфортное и надежное планирование путешествий.'),
	(19, 40, 'DSDd', 1, 'fdfd'),
	(20, 40, 'DSDd', 2, 'ფდფდ'),
	(21, 40, 'ДСДд', 3, 'фдфд'),
	(22, 41, NULL, 1, 'sdsd'),
	(23, 41, NULL, 2, 'sdsd'),
	(24, 41, NULL, 3, 'сдсд');

-- Dumping structure for table tour_space.currency
CREATE TABLE IF NOT EXISTS `currency` (
  `currency_id` int NOT NULL AUTO_INCREMENT,
  `currency_name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `currency_code` char(3) COLLATE utf8mb4_general_ci NOT NULL,
  `symbol` varchar(5) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`currency_id`),
  UNIQUE KEY `uniq_currency_code` (`currency_code`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table tour_space.currency: ~3 rows (approximately)
INSERT INTO `currency` (`currency_id`, `currency_name`, `currency_code`, `symbol`) VALUES
	(1, 'Georgian Lari', 'GEL', '₾'),
	(2, 'US Dollar', 'USD', '$'),
	(3, 'Euro', 'EUR', '€');

-- Dumping structure for table tour_space.difficulty_levels
CREATE TABLE IF NOT EXISTS `difficulty_levels` (
  `difficulty_level_id` int NOT NULL AUTO_INCREMENT,
  `level` varchar(50) CHARACTER SET armscii8 COLLATE armscii8_bin DEFAULT NULL,
  PRIMARY KEY (`difficulty_level_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.difficulty_levels: ~3 rows (approximately)
INSERT INTO `difficulty_levels` (`difficulty_level_id`, `level`) VALUES
	(1, 'easy'),
	(2, 'medium'),
	(3, 'hard');

-- Dumping structure for table tour_space.difficulty_level_translations
CREATE TABLE IF NOT EXISTS `difficulty_level_translations` (
  `translation_id` int NOT NULL AUTO_INCREMENT,
  `difficulty_level_id` int DEFAULT NULL,
  `difficulty_level_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `language_id` int DEFAULT NULL,
  PRIMARY KEY (`translation_id`),
  KEY `FK_difficulty_level_translations_languages` (`language_id`),
  KEY `FK_difficulty_level_translations_difficulty_levels` (`difficulty_level_id`),
  CONSTRAINT `FK_difficulty_level_translations_difficulty_levels` FOREIGN KEY (`difficulty_level_id`) REFERENCES `difficulty_levels` (`difficulty_level_id`),
  CONSTRAINT `FK_difficulty_level_translations_languages` FOREIGN KEY (`language_id`) REFERENCES `languages` (`language_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.difficulty_level_translations: ~9 rows (approximately)
INSERT INTO `difficulty_level_translations` (`translation_id`, `difficulty_level_id`, `difficulty_level_name`, `language_id`) VALUES
	(1, 1, 'Easy', 1),
	(2, 2, 'Medium', 1),
	(3, 3, 'Hard', 1),
	(4, 1, 'მარტივი', 2),
	(5, 2, 'საშუალო', 2),
	(6, 3, 'რთული', 2),
	(7, 1, 'Легко', 3),
	(8, 2, 'Средне', 3),
	(9, 3, 'Сложно', 3);

-- Dumping structure for table tour_space.distance_unites
CREATE TABLE IF NOT EXISTS `distance_unites` (
  `unit_id` int NOT NULL AUTO_INCREMENT,
  `unit` varchar(50) CHARACTER SET armscii8 COLLATE armscii8_bin DEFAULT NULL,
  PRIMARY KEY (`unit_id`),
  UNIQUE KEY `unit` (`unit`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.distance_unites: ~3 rows (approximately)
INSERT INTO `distance_unites` (`unit_id`, `unit`) VALUES
	(1, 'kilometer'),
	(2, 'meter'),
	(3, 'mile');

-- Dumping structure for table tour_space.events
CREATE TABLE IF NOT EXISTS `events` (
  `event_id` int NOT NULL AUTO_INCREMENT,
  `tour_id` int DEFAULT NULL,
  `start_date_time` datetime DEFAULT NULL,
  `end_date_time` datetime DEFAULT NULL,
  `active_status` int DEFAULT '1',
  `waiting_list_status` int DEFAULT '0',
  `max_client_amount` int DEFAULT NULL,
  `max_waiting_amount` int DEFAULT NULL,
  `min_client_amount` int DEFAULT NULL,
  `event_price` int DEFAULT NULL,
  `currency_id` int DEFAULT NULL,
  `is_deleted` int DEFAULT '0',
  PRIMARY KEY (`event_id`) USING BTREE,
  KEY `FK_event_tours` (`tour_id`),
  KEY `FK_events_currency` (`currency_id`),
  CONSTRAINT `FK_event_tours` FOREIGN KEY (`tour_id`) REFERENCES `tours` (`tour_id`),
  CONSTRAINT `FK_events_currency` FOREIGN KEY (`currency_id`) REFERENCES `currency` (`currency_id`)
) ENGINE=InnoDB AUTO_INCREMENT=207 DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.events: ~9 rows (approximately)
INSERT INTO `events` (`event_id`, `tour_id`, `start_date_time`, `end_date_time`, `active_status`, `waiting_list_status`, `max_client_amount`, `max_waiting_amount`, `min_client_amount`, `event_price`, `currency_id`, `is_deleted`) VALUES
	(198, 176, '2026-03-03 08:30:00', '2026-03-03 20:30:00', 1, 1, 20, 5, 5, NULL, 1, 0),
	(199, 176, '2026-04-18 08:30:00', '2026-04-18 20:30:00', 1, 1, 20, 2, 5, NULL, 1, 0),
	(200, 176, '2026-04-25 08:30:00', '2026-04-25 20:30:00', 1, 1, 20, 2, 5, NULL, 1, 0),
	(201, 176, '2026-04-11 08:30:00', '2026-04-11 20:30:00', 1, NULL, 20, NULL, 5, NULL, 1, 0),
	(202, 177, '2026-03-30 07:30:00', '2026-04-01 23:00:00', 1, 1, 20, 20, NULL, 50, 1, 0),
	(203, 177, '2026-04-05 07:30:00', '2026-04-05 23:00:00', 1, NULL, 20, NULL, NULL, 50, 1, 0),
	(204, 177, '2026-04-12 07:30:00', '2026-04-12 23:00:00', 1, NULL, 20, NULL, NULL, 50, 1, 0),
	(205, 177, '2026-04-19 07:30:00', '2026-04-19 23:00:00', 1, NULL, 20, NULL, NULL, 50, 1, 0),
	(206, 177, '2026-03-26 07:30:00', '2026-03-26 23:00:00', 1, NULL, 20, NULL, NULL, 50, 1, 0);

-- Dumping structure for table tour_space.event_guides
CREATE TABLE IF NOT EXISTS `event_guides` (
  `event_guide_id` int NOT NULL AUTO_INCREMENT,
  `event_id` int DEFAULT NULL,
  `guide_id` int DEFAULT NULL,
  PRIMARY KEY (`event_guide_id`),
  KEY `FK_event_guides_guides` (`guide_id`),
  KEY `FK_event_guides_events` (`event_id`),
  CONSTRAINT `FK_event_guides_events` FOREIGN KEY (`event_id`) REFERENCES `events` (`event_id`) ON DELETE CASCADE,
  CONSTRAINT `FK_event_guides_guides` FOREIGN KEY (`guide_id`) REFERENCES `guides` (`guide_id`)
) ENGINE=InnoDB AUTO_INCREMENT=788 DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.event_guides: ~18 rows (approximately)
INSERT INTO `event_guides` (`event_guide_id`, `event_id`, `guide_id`) VALUES
	(770, 198, 58),
	(771, 198, 63),
	(772, 199, 58),
	(773, 199, 63),
	(774, 200, 58),
	(775, 200, 63),
	(776, 201, 58),
	(777, 201, 63),
	(778, 202, 69),
	(779, 202, 70),
	(780, 203, 69),
	(781, 203, 70),
	(782, 204, 69),
	(783, 204, 70),
	(784, 205, 69),
	(785, 205, 70),
	(786, 206, 69),
	(787, 206, 70);

-- Dumping structure for table tour_space.faq
CREATE TABLE IF NOT EXISTS `faq` (
  `faq_id` int NOT NULL AUTO_INCREMENT,
  `create_at` datetime DEFAULT NULL,
  PRIMARY KEY (`faq_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.faq: ~7 rows (approximately)
INSERT INTO `faq` (`faq_id`, `create_at`) VALUES
	(1, '2025-09-20 00:16:43'),
	(2, '2025-09-20 00:16:48'),
	(3, '2025-09-20 00:16:58'),
	(4, '2025-09-20 00:17:03'),
	(5, '2025-09-20 00:17:07'),
	(6, '2025-09-20 00:17:11'),
	(7, '2025-09-20 00:17:15');

-- Dumping structure for table tour_space.faq_translations
CREATE TABLE IF NOT EXISTS `faq_translations` (
  `faq_translation_id` int NOT NULL AUTO_INCREMENT,
  `question` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `answer` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `language_id` int DEFAULT NULL,
  `faq_id` int DEFAULT NULL,
  PRIMARY KEY (`faq_translation_id`),
  KEY `FK_faq_translations_languages` (`language_id`) USING BTREE,
  KEY `FK_faq_translations_faq` (`faq_id`),
  CONSTRAINT `FK_faq_translations_faq` FOREIGN KEY (`faq_id`) REFERENCES `faq` (`faq_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_faq_translations_languages` FOREIGN KEY (`language_id`) REFERENCES `languages` (`language_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=106 DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.faq_translations: ~21 rows (approximately)
INSERT INTO `faq_translations` (`faq_translation_id`, `question`, `answer`, `language_id`, `faq_id`) VALUES
	(85, 'What is PayLess?', 'PayLess is a digital discount platform where users scan QR codes at partner locations to receive instant discounts.', 1, 1),
	(86, 'რა არის PayLess?', 'PayLess არის ციფრული ფასდაკლების პლატფორმა, სადაც მომხმარებელი პარტნიორ ობიექტებში QR კოდის სკანირებით იღებს ფასდაკლებას.', 2, 1),
	(87, 'Что такое PayLess?', 'PayLess — это цифровая платформа скидок, где пользователи сканируют QR-коды у партнеров и получают мгновенные скидки.', 3, 1),
	(88, 'How can I register?', 'You can register by downloading the app and filling out the sign-up form.', 1, 2),
	(89, 'როგორ დავრეგისტრირდე?', 'რეგისტრაციისთვის ჩამოტვირთეთ აპლიკაცია და შეავსეთ რეგისტრაციის ფორმა.', 2, 2),
	(90, 'Как зарегистрироваться?', 'Зарегистрироваться можно, скачав приложение и заполнив форму регистрации.', 3, 2),
	(91, 'Is the service free?', 'Yes, using PayLess is completely free for users.', 1, 3),
	(92, 'სერვისი უფასოა?', 'დიახ, PayLess-ის გამოყენება სრულიად უფასოა მომხმარებლებისთვის.', 2, 3),
	(93, 'Сервис бесплатный?', 'Да, использование PayLess полностью бесплатно для пользователей.', 3, 3),
	(94, 'How do businesses join?', 'Businesses can join by registering as partners on our platform.', 1, 4),
	(95, 'ბიზნესები როგორ ერთვებიან?', 'ბიზნესებს შეუძლიათ გაწევრიანება პარტნიორებად რეგისტრაციით ჩვენს პლატფორმაზე.', 2, 4),
	(96, 'Как бизнес может присоединиться?', 'Бизнесы могут присоединиться, зарегистрировавшись как партнеры на нашей платформе.', 3, 4),
	(97, 'Can I use it offline?', 'No, you need an internet connection to scan QR codes and receive discounts.', 1, 5),
	(98, 'შეიძლება ოფლაინ გამოყენება?', 'არა, QR კოდის სკანირებისა და ფასდაკლების მისაღებად საჭიროა ინტერნეტთან წვდომა.', 2, 5),
	(99, 'Можно использовать офлайн?', 'Нет, для сканирования QR-кодов и получения скидок требуется интернет.', 3, 5),
	(100, 'Do I need an account to use discounts?', 'Yes, you need to create an account to access discounts.', 1, 6),
	(101, 'მჭირდება ანგარიში ფასდაკლებისთვის?', 'დიახ, ფასდაკლებების მისაღებად აუცილებელია ანგარიშის შექმნა.', 2, 6),
	(102, 'Нужен ли аккаунт для скидок?', 'Да, для получения скидок необходимо создать аккаунт.', 3, 6),
	(103, 'How can I contact support?', 'You can contact our support team through the app or by email.', 1, 7),
	(104, 'როგორ დავუკავშირდე მხარდაჭერას?', 'დახმარების მისაღებად დაგვიკავშირდით აპლიკაციის მეშვეობით ან ელფოსტით.', 2, 7),
	(105, 'Как связаться с поддержкой?', 'Вы можете связаться с нашей службой поддержки через приложение или по электронной почте.', 3, 7);

-- Dumping structure for table tour_space.finance
CREATE TABLE IF NOT EXISTS `finance` (
  `finance_id` int NOT NULL AUTO_INCREMENT,
  `event_id` int DEFAULT NULL,
  `payid_amount` int DEFAULT NULL,
  `bank_id` int DEFAULT NULL,
  PRIMARY KEY (`finance_id`),
  KEY `FK_finance_bank` (`bank_id`),
  KEY `FK_finance_events` (`event_id`),
  CONSTRAINT `FK_finance_bank` FOREIGN KEY (`bank_id`) REFERENCES `banks` (`bank_id`),
  CONSTRAINT `FK_finance_events` FOREIGN KEY (`event_id`) REFERENCES `events` (`event_id`)
) ENGINE=InnoDB DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.finance: ~0 rows (approximately)

-- Dumping structure for table tour_space.guides
CREATE TABLE IF NOT EXISTS `guides` (
  `guide_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `time_interval_id` int DEFAULT NULL,
  `experience_value` int DEFAULT NULL,
  `image` varchar(150) CHARACTER SET armscii8 COLLATE armscii8_bin DEFAULT NULL,
  `email` varchar(100) COLLATE armscii8_bin DEFAULT NULL,
  `phone` varchar(50) COLLATE armscii8_bin DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `is_deleted` int DEFAULT '0',
  PRIMARY KEY (`guide_id`),
  KEY `FK_guide_users` (`user_id`),
  KEY `FK_guide_time_interval` (`time_interval_id`),
  CONSTRAINT `FK_guide_time_interval` FOREIGN KEY (`time_interval_id`) REFERENCES `time_interval` (`time_interval_id`),
  CONSTRAINT `FK_guide_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.guides: ~12 rows (approximately)
INSERT INTO `guides` (`guide_id`, `user_id`, `time_interval_id`, `experience_value`, `image`, `email`, `phone`, `created_at`, `is_deleted`) VALUES
	(57, NULL, NULL, NULL, NULL, 'davitdvalashvili@gmail.com', '598332135', '2026-01-15 01:16:52', 0),
	(58, NULL, NULL, NULL, NULL, 'machavariani@gmail.com', '598332266', '2026-01-15 01:17:27', 0),
	(59, NULL, NULL, NULL, 'guides/59/profile.webp', 'vovamarkarovi@gmail.com', '569885563', '2026-01-15 01:18:04', 0),
	(60, NULL, NULL, NULL, 'guides/60/profile.webp', 'tourspace.ge@gmail.com', '598336652', '2026-01-15 01:27:20', 0),
	(61, NULL, NULL, NULL, NULL, 'dvala@gmail.com', '598336645', '2026-01-15 01:30:16', 0),
	(62, NULL, NULL, NULL, NULL, 'ragaca@gmail.com', '598332199', '2026-01-15 01:30:49', 0),
	(63, NULL, NULL, NULL, NULL, 'keghoshvili@gmail.com', '598332139', '2026-02-10 16:22:54', 0),
	(64, NULL, NULL, NULL, 'guides/64/profile.webp', 'davitdvalashvili@gmail.com5', '598332137', '2026-02-24 16:12:25', 0),
	(65, NULL, NULL, NULL, NULL, 'davitdvalashvilif@gmail.com', '598336699', '2026-02-24 16:26:59', 0),
	(66, NULL, NULL, NULL, NULL, 'davitdvalashvil85@gmail.com', '588332137', '2026-03-01 21:39:20', 0),
	(67, NULL, NULL, NULL, NULL, 'davitdvala5shvil85@gmail.com', '588352135', '2026-03-01 21:51:59', 0),
	(68, NULL, NULL, NULL, NULL, 'davitdvala22shvili@gmail.com', '598336666', '2026-03-01 22:55:49', 0),
	(69, NULL, NULL, NULL, NULL, 'abdaladze25@gmail.com', '598332136', '2026-03-15 00:51:49', 0),
	(70, NULL, NULL, NULL, NULL, 'ioseliani2020@gmail.com', '590332135', '2026-03-19 21:24:02', 0);

-- Dumping structure for table tour_space.guide_languages
CREATE TABLE IF NOT EXISTS `guide_languages` (
  `guide_language_id` int NOT NULL AUTO_INCREMENT,
  `guide_id` int DEFAULT NULL,
  `language_id` int DEFAULT NULL,
  PRIMARY KEY (`guide_language_id`),
  KEY `FK__guides` (`guide_id`),
  KEY `FK__languages` (`language_id`),
  CONSTRAINT `FK__guides` FOREIGN KEY (`guide_id`) REFERENCES `guides` (`guide_id`),
  CONSTRAINT `FK__languages` FOREIGN KEY (`language_id`) REFERENCES `languages` (`language_id`)
) ENGINE=InnoDB AUTO_INCREMENT=372 DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.guide_languages: ~20 rows (approximately)
INSERT INTO `guide_languages` (`guide_language_id`, `guide_id`, `language_id`) VALUES
	(271, 60, 1),
	(272, 59, 1),
	(273, 59, 2),
	(274, 59, 3),
	(288, 62, 2),
	(289, 62, 1),
	(321, 64, 2),
	(322, 64, 1),
	(323, 65, 1),
	(339, 67, 2),
	(340, 66, 2),
	(350, 57, 1),
	(351, 57, 2),
	(365, 58, 3),
	(366, 58, 2),
	(367, 63, 1),
	(368, 63, 2),
	(369, 63, 3),
	(370, 69, 1),
	(371, 70, 2);

-- Dumping structure for table tour_space.guide_review
CREATE TABLE IF NOT EXISTS `guide_review` (
  `review_id` int NOT NULL AUTO_INCREMENT,
  `rate_score` int DEFAULT NULL,
  `guide_id` int DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  PRIMARY KEY (`review_id`),
  KEY `FK_guide_review_users` (`user_id`),
  KEY `FK_guide_review_guide` (`guide_id`),
  CONSTRAINT `FK_guide_review_guide` FOREIGN KEY (`guide_id`) REFERENCES `guides` (`guide_id`),
  CONSTRAINT `FK_guide_review_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.guide_review: ~0 rows (approximately)

-- Dumping structure for table tour_space.guide_review_translations
CREATE TABLE IF NOT EXISTS `guide_review_translations` (
  `translation_id` int NOT NULL AUTO_INCREMENT,
  `guide_review_id` int DEFAULT NULL,
  `review_text` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `language_id` int DEFAULT NULL,
  PRIMARY KEY (`translation_id`),
  KEY `FK_guide_review_translations_guide_review` (`guide_review_id`),
  KEY `FK_guide_review_translations_languages` (`language_id`),
  CONSTRAINT `FK_guide_review_translations_guide_review` FOREIGN KEY (`guide_review_id`) REFERENCES `guide_review` (`review_id`),
  CONSTRAINT `FK_guide_review_translations_languages` FOREIGN KEY (`language_id`) REFERENCES `languages` (`language_id`)
) ENGINE=InnoDB DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.guide_review_translations: ~0 rows (approximately)

-- Dumping structure for table tour_space.guide_translations
CREATE TABLE IF NOT EXISTS `guide_translations` (
  `guide_translation_id` int NOT NULL AUTO_INCREMENT,
  `guide_id` int DEFAULT NULL,
  `language_id` int DEFAULT NULL,
  `first_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `last_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `guide_description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`guide_translation_id`),
  KEY `guide_translation_id` (`guide_translation_id`),
  KEY `FK_guide_translations_languages` (`language_id`),
  KEY `FK_guide_translations_guides` (`guide_id`),
  CONSTRAINT `FK_guide_translations_guides` FOREIGN KEY (`guide_id`) REFERENCES `guides` (`guide_id`),
  CONSTRAINT `FK_guide_translations_languages` FOREIGN KEY (`language_id`) REFERENCES `languages` (`language_id`)
) ENGINE=InnoDB AUTO_INCREMENT=727 DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.guide_translations: ~36 rows (approximately)
INSERT INTO `guide_translations` (`guide_translation_id`, `guide_id`, `language_id`, `first_name`, `last_name`, `guide_description`) VALUES
	(556, 60, 1, 'David', 'Dvalashvili', NULL),
	(557, 60, 2, 'დავითი', 'დვალაშვილი', NULL),
	(558, 60, 3, 'Дэйвид', 'Двалашвили', NULL),
	(562, 59, 1, 'Vova', 'Markarov', NULL),
	(563, 59, 2, 'ვოვა', 'მარკაროვი', NULL),
	(564, 59, 3, 'Вова', 'Маркаров', NULL),
	(586, 62, 1, 'George', 'Robakidze', NULL),
	(587, 62, 2, 'გიორგი', 'რობაქიძე', NULL),
	(588, 62, 3, 'Джордж', 'Робакидзе', NULL),
	(631, 64, 1, 'David', 'Keghoshvili', NULL),
	(632, 64, 2, 'დავითი', 'კეღოშვილი', NULL),
	(633, 64, 3, 'Дэйвид', 'Кегошвили', NULL),
	(634, 65, 1, 'David', 'Keghoshvili', NULL),
	(635, 65, 2, 'დავითი', 'კეღოშვილი', NULL),
	(636, 65, 3, 'Дэйвид', 'Кегошвили', NULL),
	(664, 67, 1, 'David', 'Dvalashvili', 'Manage bookings, schedules, and guests in one simple dashboard, save time with automation, avoid overbooking, and deliver a smooth experience. today!!'),
	(665, 67, 2, 'დავითი', 'დვალაშვილი', 'Manage bookings, schedules, and guests in one simple dashboard, save time with automation, avoid overbooking, and deliver a smooth experience. today!!'),
	(666, 67, 3, 'Дэйвид', 'Двалашвили', 'Manage bookings, schedules, and guests in one simple dashboard, save time with automation, avoid overbooking, and deliver a smooth experience. today!!'),
	(667, 68, 1, 'David', 'Dvalashvili', 'TourSpace helps travel and tour operators automate bookings, manage guides and operations, and communicate with customers—all from one modern dashboar'),
	(668, 68, 2, 'დავითი', 'დვალაშვილი', 'TourSpace ეხმარება მოგზაურობისა და ტუროპერატორებს დაჯავშნების ავტომატიზაციაში, გიდებისა და ოპერაციების მართვაში და მომხმარებლებთან კომუნიკაციაში - ყველაფერი ეს ერთი თანამედროვე დაფიდან.'),
	(669, 68, 3, 'Дэйвид', 'Двалашвили', 'TourSpace помогает туроператорам автоматизировать бронирование, управлять гидами и операциями, а также общаться с клиентами — и все это с помощью одной современной панели управления.'),
	(670, 66, 1, 'David', 'Dvalashvili', 'TourSpace helps travel and tour operators automate bookings, manage guides and operations, and communicate with customers—all from one modern dashboar'),
	(671, 66, 2, 'დავითი', 'დვალაშვილი', 'TourSpace helps travel and tour operators automate bookings, manage guides and operations, and communicate with customers—all from one modern dashboar'),
	(672, 66, 3, 'Дэйвид', 'Двалашвили', 'TourSpace helps travel and tour operators automate bookings, manage guides and operations, and communicate with customers—all from one modern dashboar'),
	(715, 58, 1, 'ალექსანდრე', 'მაჭავარიანი', 'Manage bookings, schedules, and guests in one simple dashboard, save time with automation, avoid overbooking, and offer free...'),
	(716, 58, 2, 'ალექსანდრე', 'მაჭავარიანი', 'მართეთ დაჯავშნები, გრაფიკები და სტუმრები ერთ მარტივ დაფაზე, დაზოგეთ დრო ავტომატიზაციით, თავიდან აიცილეთ ზედმეტი დაჯავშნა და შესთავაზეთ უფასო...'),
	(717, 58, 3, 'ალექსანდრე', 'მაჭავარიანი', 'Управляйте бронированиями, расписаниями и гостями на одной простой панели управления, экономьте время благодаря автоматизации, избегайте перебронирования и предлагайте бесплатные номера...'),
	(718, 63, 1, 'ლუკა', 'კეღოშვილი', NULL),
	(719, 63, 2, 'ლუკა', 'კეღოშვილი', NULL),
	(720, 63, 3, 'ლუკა', 'კეღოშვილი', NULL),
	(721, 69, 1, 'დავითი', 'აბდალაძე', ''),
	(722, 69, 2, 'დავითი', 'აბდალაძე', ''),
	(723, 69, 3, 'დავითი', 'აბდალაძე', ''),
	(724, 70, 1, 'გიორგი', 'იოსელიანი', ''),
	(725, 70, 2, 'გიორგი', 'იოსელიანი', ''),
	(726, 70, 3, 'გიორგი', 'იოსელიანი', '');

-- Dumping structure for table tour_space.inclusions
CREATE TABLE IF NOT EXISTS `inclusions` (
  `inclusion_id` int NOT NULL AUTO_INCREMENT,
  `inclusion_status` int DEFAULT NULL,
  PRIMARY KEY (`inclusion_id`)
) ENGINE=InnoDB AUTO_INCREMENT=612 DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.inclusions: ~18 rows (approximately)
INSERT INTO `inclusions` (`inclusion_id`, `inclusion_status`) VALUES
	(519, 1),
	(520, 0),
	(521, 1),
	(522, 0),
	(573, 1),
	(574, 1),
	(575, 0),
	(576, 0),
	(577, 1),
	(578, 1),
	(579, 0),
	(591, 1),
	(592, 1),
	(593, 0),
	(602, 1),
	(603, 1),
	(604, 0),
	(605, 0);

-- Dumping structure for table tour_space.inclusion_translations
CREATE TABLE IF NOT EXISTS `inclusion_translations` (
  `inclusion_translation_id` int NOT NULL AUTO_INCREMENT,
  `inclusion_id` int NOT NULL,
  `inclusion` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `language_id` int NOT NULL,
  PRIMARY KEY (`inclusion_translation_id`),
  KEY `language_id` (`language_id`),
  KEY `FK_inclusion_translations_inclusions` (`inclusion_id`),
  CONSTRAINT `FK_inclusion_translations_inclusions` FOREIGN KEY (`inclusion_id`) REFERENCES `inclusions` (`inclusion_id`) ON DELETE CASCADE,
  CONSTRAINT `inclusion_translations_ibfk_2` FOREIGN KEY (`language_id`) REFERENCES `languages` (`language_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1780 DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.inclusion_translations: ~54 rows (approximately)
INSERT INTO `inclusion_translations` (`inclusion_translation_id`, `inclusion_id`, `inclusion`, `language_id`) VALUES
	(1501, 519, '22', 1),
	(1502, 520, '22', 1),
	(1503, 519, '22', 2),
	(1504, 520, '22', 2),
	(1505, 519, '22', 3),
	(1506, 520, '22', 3),
	(1507, 521, '2', 1),
	(1508, 522, '2', 1),
	(1509, 521, '2', 2),
	(1510, 522, '2', 2),
	(1511, 521, '2', 3),
	(1512, 522, '2', 3),
	(1663, 573, 'Guide', 1),
	(1664, 574, 'Travel', 1),
	(1665, 575, 'Museum ticket', 1),
	(1666, 576, 'Food', 1),
	(1667, 573, 'გზამკვლევი', 2),
	(1668, 574, 'მოგზაურობა', 2),
	(1669, 575, 'მუზეუმის ბილეთი', 2),
	(1670, 576, 'საკვები', 2),
	(1671, 573, 'Гид', 3),
	(1672, 574, 'Путешествовать', 3),
	(1673, 575, 'Билет в музей', 3),
	(1674, 576, 'Еда', 3),
	(1675, 577, 'Travel', 1),
	(1676, 578, 'Guide', 1),
	(1677, 579, 'Food', 1),
	(1678, 577, 'მგზავრობა', 2),
	(1679, 578, 'გიდი', 2),
	(1680, 579, 'კვება', 2),
	(1681, 577, 'Путешествовать', 3),
	(1682, 578, 'Гид', 3),
	(1683, 579, 'Еда', 3),
	(1717, 591, 'Guide', 1),
	(1718, 592, 'Transportation', 1),
	(1719, 593, 'Food', 1),
	(1720, 591, 'გიდი', 2),
	(1721, 592, 'ტრანსპორტირება', 2),
	(1722, 593, 'კვება', 2),
	(1723, 591, 'Гид', 3),
	(1724, 592, 'Транспорт', 3),
	(1725, 593, 'Еда', 3),
	(1750, 602, 'Guide, companion', 1),
	(1751, 603, 'Travel by minibus', 1),
	(1752, 604, 'Food', 1),
	(1753, 605, 'Rabat and Vardzia ticket', 1),
	(1754, 602, 'გიდი, გამყოლი', 2),
	(1755, 603, 'მგზავრობა მიკროავტობუსით', 2),
	(1756, 604, 'კვება', 2),
	(1757, 605, 'რაბათის და ვარძიის ბილეთი', 2),
	(1758, 602, 'Гид, компаньон', 3),
	(1759, 603, 'Путешествие на микроавтобусе', 3),
	(1760, 604, 'Еда', 3),
	(1761, 605, 'Билеты в Рабат и Вардзию', 3);

-- Dumping structure for table tour_space.languages
CREATE TABLE IF NOT EXISTS `languages` (
  `language_id` int NOT NULL AUTO_INCREMENT,
  `code` varchar(5) CHARACTER SET armscii8 COLLATE armscii8_bin NOT NULL,
  `name` varchar(100) CHARACTER SET armscii8 COLLATE armscii8_bin NOT NULL,
  `native_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`language_id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.languages: ~3 rows (approximately)
INSERT INTO `languages` (`language_id`, `code`, `name`, `native_name`) VALUES
	(1, 'en', 'english', 'English'),
	(2, 'ka', 'georgian', 'ქართული'),
	(3, 'ru', 'russian', 'Русский');

-- Dumping structure for table tour_space.payment
CREATE TABLE IF NOT EXISTS `payment` (
  `payment_id` int NOT NULL AUTO_INCREMENT,
  `booking_id` int DEFAULT NULL,
  `payment` int DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `refunded` int DEFAULT '0',
  PRIMARY KEY (`payment_id`),
  KEY `FK_payment_bookings` (`booking_id`),
  CONSTRAINT `FK_payment_bookings` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`)
) ENGINE=InnoDB AUTO_INCREMENT=301 DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.payment: ~6 rows (approximately)
INSERT INTO `payment` (`payment_id`, `booking_id`, `payment`, `created_at`, `refunded`) VALUES
	(287, 1264, 30, '2026-03-27 14:34:37', 0),
	(288, 1264, 110, '2026-03-27 14:35:08', 0),
	(289, 1265, 2, '2026-03-27 16:09:07', 0),
	(290, 1270, 100, '2026-03-29 02:28:36', 0),
	(292, 1271, 800, '2026-03-29 02:31:59', 0),
	(299, 1271, 100, '2026-03-29 03:40:08', 0),
	(300, 1271, -900, '2026-03-29 03:41:28', 1);

-- Dumping structure for table tour_space.payment_receipts
CREATE TABLE IF NOT EXISTS `payment_receipts` (
  `payment_receipt_id` int NOT NULL AUTO_INCREMENT,
  `image` varchar(100) CHARACTER SET armscii8 COLLATE armscii8_bin DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `payment_id` int DEFAULT NULL,
  PRIMARY KEY (`payment_receipt_id`),
  KEY `FK_payment_receipts_payment` (`payment_id`),
  CONSTRAINT `FK_payment_receipts_payment` FOREIGN KEY (`payment_id`) REFERENCES `payment` (`payment_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=229 DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.payment_receipts: ~6 rows (approximately)
INSERT INTO `payment_receipts` (`payment_receipt_id`, `image`, `created_at`, `payment_id`) VALUES
	(216, NULL, '2026-03-27 14:34:37', 287),
	(217, NULL, '2026-03-27 14:35:08', 288),
	(218, NULL, '2026-03-27 16:09:07', 289),
	(219, 'companies/30/bookings/receipt-1270-1774736915437-465.webp', '2026-03-29 02:28:36', 290),
	(221, NULL, '2026-03-29 02:31:59', 292),
	(228, 'companies/30/bookings/receipt-1271-1774741208238-271.webp', '2026-03-29 03:40:08', 299);

-- Dumping structure for table tour_space.payment_status
CREATE TABLE IF NOT EXISTS `payment_status` (
  `payment_status_id` int NOT NULL AUTO_INCREMENT,
  `payment_status` varchar(25) COLLATE armscii8_bin DEFAULT NULL,
  PRIMARY KEY (`payment_status_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.payment_status: ~4 rows (approximately)
INSERT INTO `payment_status` (`payment_status_id`, `payment_status`) VALUES
	(1, 'pending'),
	(2, 'partially_paid'),
	(3, 'paid'),
	(4, 'refunded');

-- Dumping structure for table tour_space.recommendations
CREATE TABLE IF NOT EXISTS `recommendations` (
  `recommendation_id` int NOT NULL AUTO_INCREMENT,
  `recommendation_status` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`recommendation_id`)
) ENGINE=InnoDB AUTO_INCREMENT=224 DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.recommendations: ~9 rows (approximately)
INSERT INTO `recommendations` (`recommendation_id`, `recommendation_status`) VALUES
	(191, 0),
	(192, 0),
	(193, 0),
	(194, 0),
	(206, 0),
	(212, 0),
	(217, 0),
	(218, 0),
	(223, 0);

-- Dumping structure for table tour_space.recommendation_translations
CREATE TABLE IF NOT EXISTS `recommendation_translations` (
  `recommendation_translation_id` int NOT NULL AUTO_INCREMENT,
  `recommendation` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `language_id` int DEFAULT NULL,
  `recommendation_id` int DEFAULT NULL,
  PRIMARY KEY (`recommendation_translation_id`),
  KEY `FK_tour_recommendation_translations_languages` (`language_id`),
  KEY `FK_recommendation_translations_recommendations` (`recommendation_id`),
  CONSTRAINT `FK_recommendation_translations_recommendations` FOREIGN KEY (`recommendation_id`) REFERENCES `recommendations` (`recommendation_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_tour_recommendation_translations_languages` FOREIGN KEY (`language_id`) REFERENCES `languages` (`language_id`)
) ENGINE=InnoDB AUTO_INCREMENT=660 DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.recommendation_translations: ~27 rows (approximately)
INSERT INTO `recommendation_translations` (`recommendation_translation_id`, `recommendation`, `language_id`, `recommendation_id`) VALUES
	(561, '22', 1, 191),
	(562, '22', 2, 191),
	(563, '22', 3, 191),
	(564, '55', 1, 192),
	(565, '55', 2, 192),
	(566, '55', 3, 192),
	(567, '2', 1, 193),
	(568, '2', 2, 193),
	(569, '2', 3, 193),
	(570, '2', 1, 194),
	(571, '2', 2, 194),
	(572, '2', 3, 194),
	(606, 'Dress warmly.', 1, 206),
	(607, 'თბილად ჩაიცვით.', 2, 206),
	(608, 'Одевайтесь потеплее.', 3, 206),
	(624, 'Dress warmly.', 1, 212),
	(625, 'ჩაიცვით თბილად', 2, 212),
	(626, 'Одевайтесь потеплее.', 3, 212),
	(639, 'Dress warmly.', 1, 217),
	(640, 'Bring food.', 1, 218),
	(641, 'ჩაიცვით თბილად', 2, 217),
	(642, 'წამოიღეთ საკვები', 2, 218),
	(643, 'Одевайтесь потеплее.', 3, 217),
	(644, 'Возьмите с собой еду.', 3, 218),
	(657, '2', 1, 223),
	(658, '2', 2, 223),
	(659, '2', 3, 223);

-- Dumping structure for table tour_space.regions
CREATE TABLE IF NOT EXISTS `regions` (
  `region_id` int NOT NULL AUTO_INCREMENT,
  `region` varchar(50) COLLATE armscii8_bin DEFAULT NULL,
  PRIMARY KEY (`region_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.regions: ~2 rows (approximately)
INSERT INTO `regions` (`region_id`, `region`) VALUES
	(1, 'georgia'),
	(2, 'abroad');

-- Dumping structure for table tour_space.roles
CREATE TABLE IF NOT EXISTS `roles` (
  `role_id` int NOT NULL AUTO_INCREMENT,
  `role` varchar(50) CHARACTER SET armscii8 COLLATE armscii8_bin NOT NULL,
  PRIMARY KEY (`role_id`),
  UNIQUE KEY `role_name` (`role`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.roles: ~5 rows (approximately)
INSERT INTO `roles` (`role_id`, `role`) VALUES
	(1, 'admin'),
	(6, 'client'),
	(2, 'company'),
	(4, 'guide'),
	(3, 'operator');

-- Dumping structure for table tour_space.sessions
CREATE TABLE IF NOT EXISTS `sessions` (
  `session_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `expires` int unsigned NOT NULL,
  `data` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  PRIMARY KEY (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.sessions: ~1 rows (approximately)

-- Dumping structure for table tour_space.subscriptions
CREATE TABLE IF NOT EXISTS `subscriptions` (
  `subscription_id` int NOT NULL AUTO_INCREMENT,
  `subscription` varchar(10) CHARACTER SET armscii8 COLLATE armscii8_bin DEFAULT NULL,
  PRIMARY KEY (`subscription_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.subscriptions: ~3 rows (approximately)
INSERT INTO `subscriptions` (`subscription_id`, `subscription`) VALUES
	(0, 'basic'),
	(1, 'pro'),
	(2, 'enterprice');

-- Dumping structure for table tour_space.time_interval
CREATE TABLE IF NOT EXISTS `time_interval` (
  `time_interval_id` int NOT NULL AUTO_INCREMENT,
  `time_interval` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`time_interval_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.time_interval: ~5 rows (approximately)
INSERT INTO `time_interval` (`time_interval_id`, `time_interval`) VALUES
	(1, 'hour'),
	(2, 'day'),
	(3, 'week'),
	(4, 'month'),
	(5, 'year');

-- Dumping structure for table tour_space.tours
CREATE TABLE IF NOT EXISTS `tours` (
  `tour_id` int NOT NULL AUTO_INCREMENT,
  `price` int DEFAULT NULL,
  `currency_id` int DEFAULT NULL,
  `difficulty_level_id` int DEFAULT NULL,
  `category_id` int DEFAULT NULL,
  `status_id` int DEFAULT '2',
  `company_id` int DEFAULT NULL,
  `distance_value` int DEFAULT NULL,
  `distance_unit_id` int DEFAULT NULL,
  `cancellation_day_value` int DEFAULT NULL,
  `time_interval_value` int DEFAULT NULL,
  `time_interval_id` int DEFAULT NULL,
  `starting_location_id` varchar(500) CHARACTER SET armscii8 COLLATE armscii8_bin DEFAULT NULL,
  `ending_location_id` varchar(500) CHARACTER SET armscii8 COLLATE armscii8_bin DEFAULT NULL,
  `show_available_spots` int DEFAULT NULL,
  `is_deleted` int DEFAULT '0',
  PRIMARY KEY (`tour_id`),
  KEY `tour_id` (`tour_id`),
  KEY `FK_tours_currency` (`currency_id`),
  KEY `FK_tours_categories` (`category_id`),
  KEY `FK_tours_status` (`status_id`),
  KEY `FK_tours_tour_operators` (`company_id`) USING BTREE,
  KEY `FK_tours_distance_unites` (`distance_unit_id`) USING BTREE,
  KEY `FK_tours_time_interval` (`time_interval_id`),
  KEY `FK_tours_difficulty_levels` (`difficulty_level_id`) USING BTREE,
  CONSTRAINT `FK_tours_categories` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`),
  CONSTRAINT `FK_tours_companies` FOREIGN KEY (`company_id`) REFERENCES `companies` (`company_id`),
  CONSTRAINT `FK_tours_currency` FOREIGN KEY (`currency_id`) REFERENCES `currency` (`currency_id`),
  CONSTRAINT `FK_tours_difficulty_levels` FOREIGN KEY (`difficulty_level_id`) REFERENCES `difficulty_levels` (`difficulty_level_id`),
  CONSTRAINT `FK_tours_distance_unites` FOREIGN KEY (`distance_unit_id`) REFERENCES `distance_unites` (`unit_id`),
  CONSTRAINT `FK_tours_status` FOREIGN KEY (`status_id`) REFERENCES `subscriptions` (`subscription_id`),
  CONSTRAINT `FK_tours_time_interval` FOREIGN KEY (`time_interval_id`) REFERENCES `time_interval` (`time_interval_id`)
) ENGINE=InnoDB AUTO_INCREMENT=182 DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.tours: ~4 rows (approximately)
INSERT INTO `tours` (`tour_id`, `price`, `currency_id`, `difficulty_level_id`, `category_id`, `status_id`, `company_id`, `distance_value`, `distance_unit_id`, `cancellation_day_value`, `time_interval_value`, `time_interval_id`, `starting_location_id`, `ending_location_id`, `show_available_spots`, `is_deleted`) VALUES
	(176, 70, 1, 1, 3, 2, 30, NULL, 1, NULL, 1, 2, 'ChIJ5b9T84VyREAR9-Sj8QQKbnI', 'ChIJ5b9T84VyREAR9-Sj8QQKbnI', 0, 0),
	(177, 50, 1, 1, 1, 2, 30, NULL, 1, NULL, NULL, 2, 'ChIJ5b9T84VyREAR9-Sj8QQKbnI', 'ChIJ5b9T84VyREAR9-Sj8QQKbnI', 1, 0),
	(179, 2, 1, 1, 1, 2, 30, 2, 1, 2, 2, 2, 'ChIJ5b9T84VyREAR9-Sj8QQKbnI', 'ChIJ5b9T84VyREAR9-Sj8QQKbnI', 0, 0),
	(180, 2, 1, 1, 1, 2, 30, 2, 1, 2, 2, 2, 'ChIJO6NVdHhvREARwsZfFdNUrnc', 'ChIJO6NVdHhvREARwsZfFdNUrnc', 1, 0),
	(181, 2, 1, NULL, 1, 2, 30, NULL, 1, 2, NULL, 2, 'ChIJl175lPFtREARs1plXLAYLGQ', 'ChIJEzDuhetMREARQgBZKwM3ez8', 0, 0);

-- Dumping structure for table tour_space.tour_destinations
CREATE TABLE IF NOT EXISTS `tour_destinations` (
  `tour_destination_id` int NOT NULL AUTO_INCREMENT,
  `tour_id` int NOT NULL DEFAULT '0',
  `destination_id` varchar(150) COLLATE armscii8_bin DEFAULT NULL,
  PRIMARY KEY (`tour_destination_id`) USING BTREE,
  KEY `FK_tour_locations_locations` (`destination_id`) USING BTREE,
  KEY `FK_tour_destinations_tours` (`tour_id`),
  CONSTRAINT `FK_tour_destinations_tours` FOREIGN KEY (`tour_id`) REFERENCES `tours` (`tour_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=420 DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.tour_destinations: ~8 rows (approximately)
INSERT INTO `tour_destinations` (`tour_destination_id`, `tour_id`, `destination_id`) VALUES
	(400, 177, 'ChIJ0YBzoSA1RUARKFcD7kzQxFU'),
	(401, 177, 'ChIJ22o-M6-1WkARsuGtoek_Lgk'),
	(402, 177, 'ChIJy4IxzJL6REARjpHtdHy_8N4'),
	(403, 177, 'ChIJR_JQJIj5REARwDTLpitLHz0'),
	(410, 176, 'ChIJ20lpRFTxQkARHB-2vHJL8KM'),
	(411, 176, 'ChIJa2XkrYfaQkARYBISc4qXOR4'),
	(412, 176, 'ChIJbzxbyWfbQkAReCg0gcT34xA'),
	(417, 179, 'ChIJy-2Ii_CMXEARipNs85u8I6E'),
	(418, 180, 'ChIJO6NVdHhvREARwsZfFdNUrnc'),
	(419, 181, 'ChIJFb95drtvREARct2NT7l3xBc');

-- Dumping structure for table tour_space.tour_images
CREATE TABLE IF NOT EXISTS `tour_images` (
  `image_id` int NOT NULL AUTO_INCREMENT,
  `tour_id` int DEFAULT NULL,
  `image` varchar(250) CHARACTER SET armscii8 COLLATE armscii8_bin DEFAULT NULL,
  PRIMARY KEY (`image_id`),
  KEY `FK_tour_images_tours` (`tour_id`),
  CONSTRAINT `FK_tour_images_tours` FOREIGN KEY (`tour_id`) REFERENCES `tours` (`tour_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=500 DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.tour_images: ~22 rows (approximately)
INSERT INTO `tour_images` (`image_id`, `tour_id`, `image`) VALUES
	(470, 176, 'tours/tour-176-1774526786507-493.webp'),
	(471, 176, 'tours/tour-176-1774526787195-906.webp'),
	(472, 176, 'tours/tour-176-1774526787327-679.webp'),
	(473, 176, 'tours/tour-176-1774526787460-717.webp'),
	(474, 176, 'tours/tour-176-1774526787586-855.webp'),
	(475, 177, 'tours/tour-177-1774527127096-612.webp'),
	(476, 177, 'tours/tour-177-1774527128497-425.webp'),
	(477, 177, 'tours/tour-177-1774527129164-942.webp'),
	(478, 177, 'tours/tour-177-1774527129754-544.webp'),
	(479, 177, 'tours/tour-177-1774527130036-124.webp'),
	(485, 179, 'tours/tour-179-1774779949670-970.webp'),
	(486, 179, 'tours/tour-179-1774779950619-699.webp'),
	(487, 179, 'tours/tour-179-1774779951273-852.webp'),
	(488, 179, 'tours/tour-179-1774779951894-577.webp'),
	(489, 179, 'tours/tour-179-1774779952183-93.webp'),
	(490, 180, 'tours/tour-180-1774780090884-280.webp'),
	(491, 180, 'tours/tour-180-1774780091832-206.webp'),
	(492, 180, 'tours/tour-180-1774780092326-671.webp'),
	(493, 180, 'tours/tour-180-1774780092607-374.webp'),
	(494, 180, 'tours/tour-180-1774780093172-146.webp'),
	(495, 181, 'tours/tour-181-1774780856429-51.webp'),
	(496, 181, 'tours/tour-181-1774780857333-132.webp'),
	(497, 181, 'tours/tour-181-1774780857956-405.webp'),
	(498, 181, 'tours/tour-181-1774780858421-17.webp'),
	(499, 181, 'tours/tour-181-1774780858699-249.webp');

-- Dumping structure for table tour_space.tour_inclusions
CREATE TABLE IF NOT EXISTS `tour_inclusions` (
  `tour_inclusion_id` int NOT NULL AUTO_INCREMENT,
  `inclusion_id` int NOT NULL DEFAULT '0',
  `tour_id` int NOT NULL,
  PRIMARY KEY (`tour_inclusion_id`) USING BTREE,
  KEY `FK_tour_inclusions_inclusions` (`inclusion_id`),
  KEY `tour_inclusions_ibfk_1` (`tour_id`),
  CONSTRAINT `FK_tour_inclusions_inclusions` FOREIGN KEY (`inclusion_id`) REFERENCES `inclusions` (`inclusion_id`) ON DELETE CASCADE,
  CONSTRAINT `tour_inclusions_ibfk_1` FOREIGN KEY (`tour_id`) REFERENCES `tours` (`tour_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=760 DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.tour_inclusions: ~7 rows (approximately)
INSERT INTO `tour_inclusions` (`tour_inclusion_id`, `inclusion_id`, `tour_id`) VALUES
	(739, 591, 177),
	(740, 592, 177),
	(741, 593, 177),
	(750, 602, 176),
	(751, 603, 176),
	(752, 604, 176),
	(753, 605, 176);

-- Dumping structure for table tour_space.tour_languages
CREATE TABLE IF NOT EXISTS `tour_languages` (
  `tour_language_id` int NOT NULL AUTO_INCREMENT,
  `tour_id` int DEFAULT NULL,
  `language_id` int DEFAULT NULL,
  PRIMARY KEY (`tour_language_id`),
  KEY `FK_tour_languages_languages` (`language_id`),
  KEY `FK_tour_languages_tours` (`tour_id`),
  CONSTRAINT `FK_tour_languages_languages` FOREIGN KEY (`language_id`) REFERENCES `languages` (`language_id`),
  CONSTRAINT `FK_tour_languages_tours` FOREIGN KEY (`tour_id`) REFERENCES `tours` (`tour_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=547 DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.tour_languages: ~7 rows (approximately)
INSERT INTO `tour_languages` (`tour_language_id`, `tour_id`, `language_id`) VALUES
	(527, 177, 2),
	(532, 176, 2),
	(533, 176, 1),
	(542, 179, 2),
	(543, 179, 1),
	(544, 180, 2),
	(545, 180, 1),
	(546, 181, 2);

-- Dumping structure for table tour_space.tour_recommendations
CREATE TABLE IF NOT EXISTS `tour_recommendations` (
  `tour_recommendation_id` int NOT NULL AUTO_INCREMENT,
  `tour_id` int DEFAULT NULL,
  `recommendation_id` int DEFAULT NULL,
  PRIMARY KEY (`tour_recommendation_id`) USING BTREE,
  KEY `FK_tour_recommendations_recommendations` (`recommendation_id`) USING BTREE,
  KEY `FK_tour_recomenadations_tours` (`tour_id`),
  CONSTRAINT `FK_tour_recomenadations_tours` FOREIGN KEY (`tour_id`) REFERENCES `tours` (`tour_id`) ON DELETE CASCADE,
  CONSTRAINT `FK_tour_recommendations_recommendations` FOREIGN KEY (`recommendation_id`) REFERENCES `recommendations` (`recommendation_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=346 DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.tour_recommendations: ~4 rows (approximately)
INSERT INTO `tour_recommendations` (`tour_recommendation_id`, `tour_id`, `recommendation_id`) VALUES
	(334, 177, 212),
	(339, 176, 217),
	(340, 176, 218),
	(345, 179, 223);

-- Dumping structure for table tour_space.tour_reviews
CREATE TABLE IF NOT EXISTS `tour_reviews` (
  `tour_review_id` int NOT NULL AUTO_INCREMENT,
  `tour_id` int DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `review_score` int DEFAULT NULL,
  `create_at` date DEFAULT NULL,
  PRIMARY KEY (`tour_review_id`) USING BTREE,
  KEY `FK_tour_reviews_users` (`user_id`),
  KEY `FK_tour_reviews_tours` (`tour_id`),
  CONSTRAINT `FK_tour_reviews_tours` FOREIGN KEY (`tour_id`) REFERENCES `tours` (`tour_id`),
  CONSTRAINT `FK_tour_reviews_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.tour_reviews: ~0 rows (approximately)

-- Dumping structure for table tour_space.tour_review_translations
CREATE TABLE IF NOT EXISTS `tour_review_translations` (
  `translation_id` int NOT NULL AUTO_INCREMENT,
  `review_text` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `language_id` int DEFAULT NULL,
  `tour_review_id` int DEFAULT NULL,
  PRIMARY KEY (`translation_id`)
) ENGINE=InnoDB DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.tour_review_translations: ~0 rows (approximately)

-- Dumping structure for table tour_space.tour_translations
CREATE TABLE IF NOT EXISTS `tour_translations` (
  `translation_id` int NOT NULL AUTO_INCREMENT,
  `tour_id` int DEFAULT NULL,
  `tour_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `language_id` int DEFAULT NULL,
  PRIMARY KEY (`translation_id`),
  KEY `FK_tour_translations_languages` (`language_id`),
  KEY `FK_tour_translations_tours` (`tour_id`),
  CONSTRAINT `FK_tour_translations_languages` FOREIGN KEY (`language_id`) REFERENCES `languages` (`language_id`),
  CONSTRAINT `FK_tour_translations_tours` FOREIGN KEY (`tour_id`) REFERENCES `tours` (`tour_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=847 DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.tour_translations: ~15 rows (approximately)
INSERT INTO `tour_translations` (`translation_id`, `tour_id`, `tour_name`, `description`, `language_id`) VALUES
	(814, 177, 'Kazbegi', '<p>We offer a one-day tour to Kazbegi, an unforgettable day awaits you - beautiful views and boundless emotions!</p>', 1),
	(815, 177, 'ყაზბეგი', '<p>გთავაზობთ ერთდღიან ტურს ყაზბეგში, გელით დაუვიწყარი დღე — ულამაზესი ხედები და უსაზღვრო ემოციები!</p>', 2),
	(816, 177, 'Казбеги', '<p>Мы предлагаем однодневную экскурсию в Казбеги, где вас ждет незабываемый день — прекрасные виды и безграничные эмоции!</p>', 3),
	(823, 176, 'Vardzia', '<p>An unforgettable one-day trip to Meskhet, where you will see very interesting historical places and spend an unforgettable time.</p>', 1),
	(824, 176, 'ვარძია', '<p>დაუვიწყარი ერთ დღიანი მოგზაურობა მესხეტში, სადაც ნახავთ ძალიან საინტერსო ისტოიულ ადგილებს და გაატარებთ დაუვიწყარ დროს</p>', 2),
	(825, 176, 'Вардзия', '<p>Незабываемая однодневная поездка в Месхет, где вы увидите очень интересные исторические места и проведете незабываемое время.</p>', 3),
	(838, 179, '20', '<p>zx</p>', 1),
	(839, 179, '20', '<p>zx</p>', 2),
	(840, 179, '20', '<p>зх</p>', 3),
	(841, 180, 'Mtskheta Tour 2', '<p>RT</p>', 1),
	(842, 180, 'მცხეთის ტური2', '<p>რტ</p>', 2),
	(843, 180, 'Тур в Мцхету 2', '<p>РТ</p>', 3),
	(844, 181, 'Mtskheta tour', '<p>2</p>', 1),
	(845, 181, 'მცხეთის ტური', '<p>2</p>', 2),
	(846, 181, 'тур в Мцхету', '<p>2</p>', 3);

-- Dumping structure for table tour_space.tour_types
CREATE TABLE IF NOT EXISTS `tour_types` (
  `tour_type_id` int NOT NULL AUTO_INCREMENT,
  `tour_type` varchar(50) COLLATE armscii8_bin DEFAULT NULL,
  PRIMARY KEY (`tour_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.tour_types: ~2 rows (approximately)
INSERT INTO `tour_types` (`tour_type_id`, `tour_type`) VALUES
	(1, 'group'),
	(2, 'private'),
	(3, 'corporate');

-- Dumping structure for table tour_space.users
CREATE TABLE IF NOT EXISTS `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(100) CHARACTER SET armscii8 COLLATE armscii8_bin DEFAULT NULL,
  `password_hash` text CHARACTER SET armscii8 COLLATE armscii8_bin,
  `first_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `last_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `phone` varchar(30) CHARACTER SET armscii8 COLLATE armscii8_bin DEFAULT NULL,
  `image` varchar(250) CHARACTER SET armscii8 COLLATE armscii8_bin DEFAULT NULL,
  `gender` int DEFAULT NULL,
  `birth_date` date DEFAULT NULL,
  `privite_number` varchar(20) CHARACTER SET armscii8 COLLATE armscii8_bin DEFAULT NULL,
  `preferred_language_id` int DEFAULT '2',
  `create_at` date DEFAULT NULL,
  `country_id` int DEFAULT NULL,
  `recovery_code_hash` text COLLATE armscii8_bin,
  `recovery_code_expire` datetime DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `phone` (`phone`),
  KEY `FK_users_languages` (`preferred_language_id`),
  KEY `FK_users_countries` (`country_id`),
  CONSTRAINT `FK_users_countries` FOREIGN KEY (`country_id`) REFERENCES `countries` (`country_id`),
  CONSTRAINT `FK_users_languages` FOREIGN KEY (`preferred_language_id`) REFERENCES `languages` (`language_id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.users: ~3 rows (approximately)
INSERT INTO `users` (`user_id`, `email`, `password_hash`, `first_name`, `last_name`, `phone`, `image`, `gender`, `birth_date`, `privite_number`, `preferred_language_id`, `create_at`, `country_id`, `recovery_code_hash`, `recovery_code_expire`) VALUES
	(27, 'davitdvalashvili@gmail.com', '$2b$10$5vlMByBWxBuOn2PTmnX1P.Hn/Ul8rTF4FuinKLJB16ue6NB08WuXW', 'Davit', 'DValashvili', '598332135', NULL, NULL, NULL, NULL, 2, '2025-12-10', NULL, NULL, NULL),
	(28, 'giorgimikeladze@gmail.com', '$2b$10$pIIIhnt0RNvlhbSzw6bNEuhUpFTLppOA3/egF43GYYyVEl.YE5ss6', 'giorgi', 'mikeladze', '598336571', NULL, NULL, NULL, NULL, 2, '2025-12-10', NULL, NULL, NULL),
	(29, 'tornikekokhreidze@gmail.com', '$2b$10$ruWA9KXY6ohRC47dScpuveuBKntZeloJF/7wwiUrc9MW.I5oyLEFi', 'tornike', 'kokhreidze', '555446633', NULL, NULL, NULL, NULL, 2, '2025-12-10', NULL, NULL, NULL);

-- Dumping structure for table tour_space.user_interests
CREATE TABLE IF NOT EXISTS `user_interests` (
  `user_interest_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `category_id` int DEFAULT NULL,
  PRIMARY KEY (`user_interest_id`),
  KEY `FK_user_interests_users` (`user_id`),
  KEY `FK_user_interests_categories` (`category_id`),
  CONSTRAINT `FK_user_interests_categories` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`),
  CONSTRAINT `FK_user_interests_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.user_interests: ~0 rows (approximately)

-- Dumping structure for table tour_space.user_role
CREATE TABLE IF NOT EXISTS `user_role` (
  `user_role_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `role_id` int DEFAULT NULL,
  `default_role` int DEFAULT '0',
  `company_id` int DEFAULT NULL,
  PRIMARY KEY (`user_role_id`),
  UNIQUE KEY `uniq_user_role_org` (`user_id`,`role_id`,`company_id`) USING BTREE,
  KEY `FK_user_role_roles` (`role_id`),
  KEY `FK_user_role_companies` (`company_id`),
  CONSTRAINT `FK_user_role_companies` FOREIGN KEY (`company_id`) REFERENCES `companies` (`company_id`),
  CONSTRAINT `FK_user_role_roles` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`),
  CONSTRAINT `FK_user_role_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.user_role: ~2 rows (approximately)
INSERT INTO `user_role` (`user_role_id`, `user_id`, `role_id`, `default_role`, `company_id`) VALUES
	(1, 27, 6, 1, NULL),
	(2, 28, 6, 1, NULL),
	(3, 29, 6, 1, NULL);

-- Dumping structure for table tour_space.user_translations
CREATE TABLE IF NOT EXISTS `user_translations` (
  `user_translation_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `language_id` int DEFAULT NULL,
  `first_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `last_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `city` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`user_translation_id`),
  KEY `FK_user_translations_languages` (`language_id`),
  KEY `FK_user_translations_users` (`user_id`),
  CONSTRAINT `FK_user_translations_languages` FOREIGN KEY (`language_id`) REFERENCES `languages` (`language_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_user_translations_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table tour_space.user_translations: ~9 rows (approximately)
INSERT INTO `user_translations` (`user_translation_id`, `user_id`, `language_id`, `first_name`, `last_name`, `city`, `address`) VALUES
	(1, 27, 1, 'Davit', 'DValashvili', 'Tbilisi', 'Rustaveli Avenue 10'),
	(2, 27, 2, 'დავით', 'დვალაშვილი', 'თბილისი', 'რუსთაველის გამზ. 10'),
	(3, 27, 3, 'Давид', 'Двалашвили', 'Тбилиси', 'проспект Руставели 10'),
	(4, 28, 1, 'Giorgi', 'Mikeladze', 'Batumi', 'Chavchavadze Street 15'),
	(5, 28, 2, 'გიორგი', 'მიკელაძე', 'ბათუმი', 'ჭავჭავაძის ქუჩა 15'),
	(6, 28, 3, 'Гиорги', 'Микеладзе', 'Батуми', 'улица Чавчавадзе 15'),
	(7, 29, 1, 'Tornike', 'Kokhreidze', 'Kutaisi', 'Rustaveli Street 5'),
	(8, 29, 2, 'თორნიკე', 'კოხრეიძე', 'ქუთაისი', 'რუსთაველის ქუჩა 5'),
	(9, 29, 3, 'Торнике', 'Кохрейдзе', 'Кутаиси', 'улица Руставели 5');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
