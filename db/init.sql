-- Adminer 5.2.1 MySQL 8.0.45 dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

SET NAMES utf8mb4;

DROP TABLE IF EXISTS `Test`;
CREATE TABLE `Test` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `Test` (`id`, `nom`) VALUES
(3,	'Joan'),
(4,	'TimOThé'),
(5,	'Nzo');

-- 2026-01-23 15:32:25 UTC