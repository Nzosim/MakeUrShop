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
(1, 'Homme', NULL),
(2, 'Femme', NULL),
(3, 'Enfant', NULL),
(4, 'qzdqzd', 1),
(5, 'qe', 2),
(6, 'qdz', 2),
(7, 'z', 2),
(8, 'dz', 2),
(9, 'dz', 2),
(10, 'z', 2),
(11, 'z', 2),
(12, 'z', 2),
(13, 'dzqdz', 2),
(14, 'zdqz', 2)
;