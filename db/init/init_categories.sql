-- Categories et sous-catégories

DROP TABLE IF EXISTS `category`;
CREATE TABLE `category` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `category_parent_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `category_parent_id` (`category_parent_id`),
  CONSTRAINT `category_ibfk_1` FOREIGN KEY (`category_parent_id`) REFERENCES `category` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `category` (`id`, `name`, `category_parent_id`) VALUES
(1,	'Homme',	NULL),
(2,	'Femme',	NULL),
(3,	'Enfant',	NULL),
(4,	'T-shirts',	1),
(5,	'Pantalons',	1),
(6,	'Vestes',	1),
(7,	'Chaussures',	1),
(8,	'Robes',	2),
(9,	'Tops',	2),
(10,	'Jupes',	2),
(11,	'Chaussures',	2),
(12,	'T-shirts',	3),
(13,	'Pantalons',	3),
(14,	'Vestes',	3),
(15,	'Chaussures',	3);