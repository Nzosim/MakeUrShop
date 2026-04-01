-- Adminer 5.4.1 MySQL 8.0.45 dump

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

DROP TABLE IF EXISTS `address`;
CREATE TABLE `address` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `type` enum('livraison','facturation') NOT NULL,
  `address` varchar(255) NOT NULL,
  `city` varchar(100) NOT NULL,
  `zip_code` varchar(20) NOT NULL,
  `country` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `address_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `address` (`id`, `user_id`, `type`, `address`, `city`, `zip_code`, `country`) VALUES
(1,	2,	'livraison',	'12 rue de Paris',	'Lyon',	'69000',	'France'),
(2,	2,	'facturation',	'12 rue de Paris',	'Lyon',	'69000',	'France'),
(3,	3,	'livraison',	'45 avenue Victor Hugo',	'Paris',	'75016',	'France'),
(4,	4,	'livraison',	'8 boulevard Gambetta',	'Nice',	'06000',	'France');

DROP TABLE IF EXISTS `brand`;
CREATE TABLE `brand` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `brand` (`id`, `name`) VALUES
(1,	'Nike'),
(2,	'Adidas'),
(3,	'Puma'),
(4,	'H&M'),
(5,	'Zara'),
(6,	'Tommy Hilfiger'),
(7,	'Calvin Klein');

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

DROP TABLE IF EXISTS `daily_product_stat`;
CREATE TABLE `daily_product_stat` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `date` date NOT NULL,
  `view_number` int DEFAULT NULL,
  `add_cart_number` int DEFAULT NULL,
  `nb_order` int DEFAULT NULL,
  `total_revenue` decimal(12,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `daily_product_stat_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `daily_product_stat` (`id`, `product_id`, `date`, `view_number`, `add_cart_number`, `nb_order`, `total_revenue`) VALUES
(1,	1,	'2026-01-20',	120,	30,	2,	39.98),
(2,	4,	'2026-01-20',	80,	15,	1,	59.99),
(3,	7,	'2026-01-20',	60,	20,	2,	29.99);

DROP TABLE IF EXISTS `daily_stat`;
CREATE TABLE `daily_stat` (
  `id` int NOT NULL AUTO_INCREMENT,
  `date` date NOT NULL,
  `total_revenue` decimal(12,2) DEFAULT NULL,
  `revenue_bid` decimal(12,2) DEFAULT NULL,
  `revenue_classic` decimal(12,2) DEFAULT NULL,
  `total_order_number` int DEFAULT NULL,
  `revenue_order_number` int DEFAULT NULL,
  `bid_order_number` int DEFAULT NULL,
  `average_cart` decimal(10,2) DEFAULT NULL,
  `new_user_number` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `daily_stat` (`id`, `date`, `total_revenue`, `revenue_bid`, `revenue_classic`, `total_order_number`, `revenue_order_number`, `bid_order_number`, `average_cart`, `new_user_number`) VALUES
(1,	'2026-01-20',	159.96,	39.99,	119.97,	3,	2,	1,	53.32,	2);

DROP TABLE IF EXISTS `global_stat`;
CREATE TABLE `global_stat` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `total_order` int DEFAULT NULL,
  `total_revenue` decimal(12,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `global_stat_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `global_stat` (`id`, `user_id`, `total_order`, `total_revenue`) VALUES
(1,	2,	1,	39.98),
(2,	3,	1,	59.99),
(3,	4,	1,	29.99);

DROP TABLE IF EXISTS `image`;
CREATE TABLE `image` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `url` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `image_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `image` (`id`, `product_id`, `url`) VALUES
(1,	1,	'https://www.lapolemik.com/4295/t-shirt-homme-basic-citadel-blue.jpg'),
(2,	2,	'https://www.lapolemik.com/4295/t-shirt-homme-basic-citadel-blue.jpg'),
(3,	3,	'https://assets.adidas.com/images/w_600,f_auto,q_auto/a1a4f5c5d02f4b6e8e1daf0000a0e8b0_9366/T-shirt_Essentials_Blanc_GL0058_01_laydown.jpg'),
(4,	4,	'https://images.puma.com/image/upload/f_auto,q_auto,b_rgb:fafafa,w_600,h_600/global/586668/56/mod01/fnd/EEA/fmt/png'),
(5,	5,	'https://www.lapolemik.com/4295/t-shirt-homme-basic-citadel-blue.jpg'),
(6,	6,	'https://www.lapolemik.com/4295/t-shirt-homme-basic-citadel-blue.jpg'),
(7,	7,	'https://www.lapolemik.com/4295/t-shirt-homme-basic-citadel-blue.jpg'),
(8,	8,	'https://www.lapolemik.com/4295/t-shirt-homme-basic-citadel-blue.jpg'),
(9,	9,	'https://www.lapolemik.com/4295/t-shirt-homme-basic-citadel-blue.jpg'),
(10,	10,	'https://www.lapolemik.com/4295/t-shirt-homme-basic-citadel-blue.jpg'),
(11,	11,	'https://www.lapolemik.com/4295/t-shirt-homme-basic-citadel-blue.jpg'),
(12,	12,	'https://www.lapolemik.com/4295/t-shirt-homme-basic-citadel-blue.jpg'),
(13,	13,	'https://www.vibs.com/on/demandware.static/-/Sites-Bonobo_master/default/dw0ca89ecb/jeans-slim-ultra-stretch-denim-stone-homme-vue1-36125211151230242.jpg'),
(14,	14,	'https://www.vibs.com/on/demandware.static/-/Sites-Bonobo_master/default/dw0ca89ecb/jeans-slim-ultra-stretch-denim-stone-homme-vue1-36125211151230242.jpg'),
(15,	15,	'https://www.vibs.com/on/demandware.static/-/Sites-Bonobo_master/default/dw0ca89ecb/jeans-slim-ultra-stretch-denim-stone-homme-vue1-36125211151230242.jpg'),
(16,	16,	'https://www.vibs.com/on/demandware.static/-/Sites-Bonobo_master/default/dw0ca89ecb/jeans-slim-ultra-stretch-denim-stone-homme-vue1-36125211151230242.jpg'),
(17,	17,	'https://www.vibs.com/on/demandware.static/-/Sites-Bonobo_master/default/dw0ca89ecb/jeans-slim-ultra-stretch-denim-stone-homme-vue1-36125211151230242.jpg'),
(18,	18,	'https://www.vibs.com/on/demandware.static/-/Sites-Bonobo_master/default/dw0ca89ecb/jeans-slim-ultra-stretch-denim-stone-homme-vue1-36125211151230242.jpg'),
(19,	19,	'https://www.vibs.com/on/demandware.static/-/Sites-Bonobo_master/default/dw0ca89ecb/jeans-slim-ultra-stretch-denim-stone-homme-vue1-36125211151230242.jpg'),
(20,	20,	'https://www.vibs.com/on/demandware.static/-/Sites-Bonobo_master/default/dw0ca89ecb/jeans-slim-ultra-stretch-denim-stone-homme-vue1-36125211151230242.jpg'),
(21,	21,	'https://www.vibs.com/on/demandware.static/-/Sites-Bonobo_master/default/dw0ca89ecb/jeans-slim-ultra-stretch-denim-stone-homme-vue1-36125211151230242.jpg'),
(22,	22,	'https://www.vibs.com/on/demandware.static/-/Sites-Bonobo_master/default/dw0ca89ecb/jeans-slim-ultra-stretch-denim-stone-homme-vue1-36125211151230242.jpg'),
(23,	23,	'https://www.vibs.com/on/demandware.static/-/Sites-Bonobo_master/default/dw0ca89ecb/jeans-slim-ultra-stretch-denim-stone-homme-vue1-36125211151230242.jpg'),
(24,	24,	'https://www.vibs.com/on/demandware.static/-/Sites-Bonobo_master/default/dw0ca89ecb/jeans-slim-ultra-stretch-denim-stone-homme-vue1-36125211151230242.jpg'),
(25,	25,	'https://www.gardedenfantspourtous.fr/wp-content/uploads/2022/06/veste-homme-mi-saison-686vso-1.jpg'),
(26,	26,	'https://www.gardedenfantspourtous.fr/wp-content/uploads/2022/06/veste-homme-mi-saison-686vso-1.jpg'),
(27,	27,	'https://www.gardedenfantspourtous.fr/wp-content/uploads/2022/06/veste-homme-mi-saison-686vso-1.jpg'),
(28,	28,	'https://www.gardedenfantspourtous.fr/wp-content/uploads/2022/06/veste-homme-mi-saison-686vso-1.jpg'),
(29,	29,	'https://www.gardedenfantspourtous.fr/wp-content/uploads/2022/06/veste-homme-mi-saison-686vso-1.jpg'),
(30,	30,	'https://www.gardedenfantspourtous.fr/wp-content/uploads/2022/06/veste-homme-mi-saison-686vso-1.jpg'),
(31,	31,	'https://www.gardedenfantspourtous.fr/wp-content/uploads/2022/06/veste-homme-mi-saison-686vso-1.jpg'),
(32,	32,	'https://www.gardedenfantspourtous.fr/wp-content/uploads/2022/06/veste-homme-mi-saison-686vso-1.jpg'),
(33,	33,	'https://www.gardedenfantspourtous.fr/wp-content/uploads/2022/06/veste-homme-mi-saison-686vso-1.jpg'),
(34,	34,	'https://www.gardedenfantspourtous.fr/wp-content/uploads/2022/06/veste-homme-mi-saison-686vso-1.jpg'),
(35,	35,	'https://www.gardedenfantspourtous.fr/wp-content/uploads/2022/06/veste-homme-mi-saison-686vso-1.jpg'),
(36,	36,	'https://www.gardedenfantspourtous.fr/wp-content/uploads/2022/06/veste-homme-mi-saison-686vso-1.jpg'),
(37,	37,	'https://static.nike.com/a/images/t_PDP_936_v1/f_auto,q_auto:eco/b7d9211c-26e7-431a-ac24-b0540fb3c00f/AIR+MAX+90.png'),
(38,	38,	'https://static.nike.com/a/images/t_PDP_936_v1/f_auto,q_auto:eco/b7d9211c-26e7-431a-ac24-b0540fb3c00f/AIR+MAX+90.png'),
(39,	39,	'https://static.nike.com/a/images/t_PDP_936_v1/f_auto,q_auto:eco/b7d9211c-26e7-431a-ac24-b0540fb3c00f/AIR+MAX+90.png'),
(40,	40,	'https://static.nike.com/a/images/t_PDP_936_v1/f_auto,q_auto:eco/b7d9211c-26e7-431a-ac24-b0540fb3c00f/AIR+MAX+90.png'),
(41,	41,	'https://static.nike.com/a/images/t_PDP_936_v1/f_auto,q_auto:eco/b7d9211c-26e7-431a-ac24-b0540fb3c00f/AIR+MAX+90.png'),
(42,	42,	'https://static.nike.com/a/images/t_PDP_936_v1/f_auto,q_auto:eco/b7d9211c-26e7-431a-ac24-b0540fb3c00f/AIR+MAX+90.png'),
(43,	43,	'https://static.nike.com/a/images/t_PDP_936_v1/f_auto,q_auto:eco/b7d9211c-26e7-431a-ac24-b0540fb3c00f/AIR+MAX+90.png'),
(44,	44,	'https://static.nike.com/a/images/t_PDP_936_v1/f_auto,q_auto:eco/b7d9211c-26e7-431a-ac24-b0540fb3c00f/AIR+MAX+90.png'),
(45,	45,	'https://static.nike.com/a/images/t_PDP_936_v1/f_auto,q_auto:eco/b7d9211c-26e7-431a-ac24-b0540fb3c00f/AIR+MAX+90.png'),
(46,	46,	'https://static.nike.com/a/images/t_PDP_936_v1/f_auto,q_auto:eco/b7d9211c-26e7-431a-ac24-b0540fb3c00f/AIR+MAX+90.png'),
(47,	47,	'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRP8oaSDIicR1Enfndo9l2bc9laui4PIXNfYw&s'),
(48,	48,	'https://images.etam.com/on/demandware.static/-/Sites-ELIN-master/default/dwb225c2c6/654542301_a.jpg?sw=1000&sh=1510'),
(49,	49,	'https://medias.afibel.com/fr/media/6/5/jupe-longue-metallisee-plissee--65581_SF1_S-20240911104706.jpg?twic=v1/quality=85/cover=500x667'),
(50,	50,	'https://m.media-amazon.com/images/I/6193-P7FPJL._AC_UY350_.jpg'),
(51,	51,	'https://m.media-amazon.com/images/I/61HVV5nJWvL._AC_UY1000_.jpg'),
(52,	52,	'https://www.lespetitsbaroudeurs.com/37852-large_default/veste-serkkula-reima.jpg');

DROP TABLE IF EXISTS `order_list`;
CREATE TABLE `order_list` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `product_id` int NOT NULL,
  `quantity` int NOT NULL,
  `unit_price` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `order_list_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  CONSTRAINT `order_list_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `order_list` (`id`, `order_id`, `product_id`, `quantity`, `unit_price`) VALUES
(1,	1,	1,	2,	19.99),
(2,	2,	47,	1,	59.99),
(3,	3,	50,	2,	14.99);

DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `shipping_address_id` int NOT NULL,
  `billing_address_id` int NOT NULL,
  `statut` enum('en_attente','payee','expediee','livree','annulee') NOT NULL,
  `total` decimal(10,2) NOT NULL,
  `order_date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `shipping_address_id` (`shipping_address_id`),
  KEY `billing_address_id` (`billing_address_id`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`shipping_address_id`) REFERENCES `address` (`id`),
  CONSTRAINT `orders_ibfk_3` FOREIGN KEY (`billing_address_id`) REFERENCES `address` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `orders` (`id`, `user_id`, `shipping_address_id`, `billing_address_id`, `statut`, `total`, `order_date`) VALUES
(1,	2,	1,	2,	'payee',	69.98,	'2026-03-24 08:16:17'),
(2,	3,	3,	3,	'expediee',	59.99,	'2026-03-24 08:16:17'),
(3,	4,	4,	4,	'livree',	29.99,	'2026-03-24 08:16:17');

DROP TABLE IF EXISTS `product`;
CREATE TABLE `product` (
  `id` int NOT NULL AUTO_INCREMENT,
  `category_id` int NOT NULL,
  `brand_id` int DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `description` text,
  `price` decimal(10,2) NOT NULL,
  `sale_price` int NOT NULL,
  `type` enum('classique','enchere') NOT NULL,
  `actif` tinyint(1) DEFAULT '0',
  `creation_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `image` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `category_id` (`category_id`),
  KEY `brand_id` (`brand_id`),
  CONSTRAINT `product_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`),
  CONSTRAINT `product_ibfk_2` FOREIGN KEY (`brand_id`) REFERENCES `brand` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `product` (`id`, `category_id`, `brand_id`, `name`, `description`, `price`, `sale_price`, `type`, `actif`, `creation_date`, `image`) VALUES
(1,	4,	1,	'T-shirt Homme Basic',	'T-shirt coton 100%',	19.99,	0,	'classique',	1,	'2026-03-24 08:16:17',	NULL),
(2,	4,	1,	'T-shirt Homme Basic V2',	'T-shirt coton 100%',	19.99,	0,	'classique',	1,	'2026-03-24 08:16:17',	NULL),
(3,	4,	2,	'T-shirt Homme Sport Adidas',	'T-shirt technique respirant',	29.99,	0,	'classique',	1,	'2026-03-24 08:16:17',	NULL),
(4,	4,	3,	'T-shirt Homme Puma Essential',	'T-shirt casual confortable',	24.99,	15,	'classique',	1,	'2026-03-24 08:16:17',	NULL),
(5,	4,	4,	'T-shirt Homme H&M Oversized',	'T-shirt oversize tendance',	14.99,	0,	'classique',	1,	'2026-03-24 08:16:17',	NULL),
(6,	4,	5,	'T-shirt Homme Zara Premium',	'T-shirt coton premium',	22.99,	0,	'classique',	1,	'2026-03-24 08:16:17',	NULL),
(7,	4,	6,	'T-shirt Homme Tommy Classic',	'T-shirt col rond classique',	39.99,	10,	'classique',	1,	'2026-03-24 08:16:17',	NULL),
(8,	4,	7,	'T-shirt Homme Calvin Klein Logo',	'T-shirt avec logo brodé',	34.99,	0,	'classique',	1,	'2026-03-24 08:16:17',	NULL),
(9,	4,	1,	'T-shirt Homme Nike Dri-FIT',	'T-shirt performance sport',	34.99,	0,	'classique',	1,	'2026-03-24 08:16:17',	NULL),
(10,	4,	2,	'T-shirt Homme Adidas Trefoil',	'T-shirt rétro logo trèfle',	27.99,	20,	'classique',	1,	'2026-03-24 08:16:17',	NULL),
(11,	4,	3,	'T-shirt Homme Puma Graphic',	'T-shirt imprimé graphique',	22.99,	0,	'classique',	1,	'2026-03-24 08:16:17',	NULL),
(12,	4,	4,	'T-shirt Homme H&M Slim Fit',	'T-shirt ajusté stretch',	12.99,	0,	'classique',	1,	'2026-03-24 08:16:17',	NULL),
(13,	5,	4,	'Jean Homme Slim',	'Jean slim bleu',	49.99,	0,	'classique',	1,	'2026-03-24 08:16:17',	NULL),
(14,	5,	4,	'Jean Homme Slim V2',	'Jean slim bleu délavé',	49.99,	0,	'classique',	1,	'2026-03-24 08:16:17',	NULL),
(15,	5,	5,	'Pantalon Homme Chino Zara',	'Chino coupe droite beige',	39.99,	0,	'classique',	1,	'2026-03-24 08:16:17',	NULL),
(16,	5,	6,	'Jean Homme Tommy Regular',	'Jean regular fit indigo',	79.99,	15,	'classique',	1,	'2026-03-24 08:16:17',	NULL),
(17,	5,	7,	'Jean Homme Calvin Klein Straight',	'Jean droit noir',	89.99,	0,	'classique',	1,	'2026-03-24 08:16:17',	NULL),
(18,	5,	1,	'Jogger Homme Nike Tech',	'Pantalon jogger tech fleece',	59.99,	0,	'classique',	1,	'2026-03-24 08:16:17',	NULL),
(19,	5,	2,	'Pantalon Homme Adidas Training',	'Pantalon entraînement',	44.99,	25,	'classique',	1,	'2026-03-24 08:16:17',	NULL),
(20,	5,	3,	'Pantalon Homme Puma Cargo',	'Pantalon cargo streetwear',	54.99,	0,	'classique',	1,	'2026-03-24 08:16:17',	NULL),
(21,	5,	4,	'Pantalon Homme H&M Lin',	'Pantalon en lin léger',	34.99,	0,	'classique',	1,	'2026-03-24 08:16:17',	NULL),
(22,	5,	5,	'Jean Homme Zara Skinny',	'Jean skinny stretch noir',	45.99,	10,	'classique',	1,	'2026-03-24 08:16:17',	NULL),
(23,	5,	6,	'Pantalon Homme Tommy Chino',	'Chino Tommy coupe slim',	69.99,	0,	'classique',	1,	'2026-03-24 08:16:17',	NULL),
(24,	5,	7,	'Jean Homme CK Slim Taper',	'Jean slim tapered gris',	94.99,	0,	'classique',	1,	'2026-03-24 08:16:17',	NULL),
(25,	6,	2,	'Veste Homme Mi-saison',	'Veste légère',	89.99,	20,	'classique',	1,	'2026-03-24 08:16:17',	NULL),
(26,	6,	2,	'Veste Homme Mi-saison V2',	'Veste légère imperméable',	89.99,	0,	'classique',	1,	'2026-03-24 08:16:17',	NULL),
(27,	6,	1,	'Veste Homme Nike Windrunner',	'Coupe-vent classique',	99.99,	0,	'classique',	1,	'2026-03-24 08:16:17',	NULL),
(28,	6,	3,	'Veste Homme Puma Bomber',	'Bomber jacket streetwear',	79.99,	10,	'classique',	1,	'2026-03-24 08:16:17',	NULL),
(29,	6,	4,	'Veste Homme H&M Denim',	'Veste en jean classique',	49.99,	0,	'classique',	1,	'2026-03-24 08:16:17',	NULL),
(30,	6,	5,	'Veste Homme Zara Blazer',	'Blazer casual marine',	89.99,	0,	'classique',	1,	'2026-03-24 08:16:17',	NULL),
(31,	6,	6,	'Veste Homme Tommy Padded',	'Doudoune légère',	149.99,	30,	'classique',	1,	'2026-03-24 08:16:17',	NULL),
(32,	6,	7,	'Veste Homme CK Leather',	'Veste cuir synthétique',	129.99,	0,	'classique',	1,	'2026-03-24 08:16:17',	NULL),
(33,	6,	1,	'Veste Homme Nike Down Fill',	'Doudoune chaude hiver',	159.99,	0,	'classique',	1,	'2026-03-24 08:16:17',	NULL),
(34,	6,	2,	'Veste Homme Adidas Track',	'Veste de survêtement rétro',	69.99,	15,	'classique',	1,	'2026-03-24 08:16:17',	NULL),
(35,	6,	5,	'Veste Homme Zara Parka',	'Parka longue kaki',	119.99,	0,	'classique',	1,	'2026-03-24 08:16:17',	NULL),
(36,	6,	4,	'Veste Homme H&M Matelassée',	'Veste matelassée noire',	59.99,	0,	'classique',	1,	'2026-03-24 08:16:17',	NULL),
(37,	7,	1,	'Nike Air Max 90 Homme',	'Sneakers iconiques',	139.99,	0,	'classique',	1,	'2026-03-24 08:16:17',	NULL),
(38,	7,	2,	'Adidas Stan Smith Homme',	'Baskets cuir blanc',	99.99,	0,	'classique',	1,	'2026-03-24 08:16:17',	NULL),
(39,	7,	3,	'Puma Suede Classic Homme',	'Baskets daim rétro',	79.99,	20,	'classique',	1,	'2026-03-24 08:16:17',	NULL),
(40,	7,	1,	'Nike Air Force 1 Homme',	'Sneakers blanches classiques',	109.99,	0,	'classique',	1,	'2026-03-24 08:16:17',	NULL),
(41,	7,	2,	'Adidas Ultraboost Homme',	'Running haute performance',	179.99,	15,	'classique',	1,	'2026-03-24 08:16:17',	NULL),
(42,	7,	3,	'Puma RS-X Homme',	'Sneakers chunky colorées',	109.99,	0,	'classique',	1,	'2026-03-24 08:16:17',	NULL),
(43,	7,	1,	'Nike Dunk Low Homme',	'Sneakers streetwear',	119.99,	0,	'classique',	1,	'2026-03-24 08:16:17',	NULL),
(44,	7,	2,	'Adidas Gazelle Homme',	'Baskets rétro suède',	89.99,	10,	'classique',	1,	'2026-03-24 08:16:17',	NULL),
(45,	7,	5,	'Zara Boots Homme Chelsea',	'Boots chelsea cuir',	69.99,	0,	'classique',	1,	'2026-03-24 08:16:17',	NULL),
(46,	7,	6,	'Tommy Hilfiger Sneakers Homme',	'Sneakers casual cuir',	99.99,	0,	'classique',	1,	'2026-03-24 08:16:17',	NULL),
(47,	8,	5,	'Robe Femme Été',	'Robe fluide',	59.99,	0,	'classique',	1,	'2026-03-24 08:16:17',	NULL),
(48,	9,	6,	'Top Femme Blanc',	'Top manches courtes',	24.99,	0,	'classique',	1,	'2026-03-24 08:16:17',	NULL),
(49,	10,	5,	'Jupe Femme Plissée',	'Jupe mi-longue',	39.99,	0,	'enchere',	1,	'2026-03-24 08:16:17',	NULL),
(50,	12,	3,	'T-shirt Enfant Fun',	'T-shirt imprimé',	14.99,	0,	'classique',	1,	'2026-03-24 08:16:17',	NULL),
(51,	13,	2,	'Pantalon Enfant',	'Pantalon confortable',	29.99,	0,	'classique',	1,	'2026-03-24 08:16:17',	NULL),
(52,	14,	1,	'Veste Enfant Hiver',	'Veste chaude',	79.99,	0,	'enchere',	1,	'2026-03-24 08:16:17',	'https://i.postimg.cc/1RGKyRx5/veste-enfant.jpg');

DROP TABLE IF EXISTS `product_status`;
CREATE TABLE `product_status` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `total_order` int DEFAULT NULL,
  `total_revenue` decimal(12,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `product_status_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `product_status` (`id`, `product_id`, `total_order`, `total_revenue`) VALUES
(1,	1,	2,	39.98),
(2,	4,	1,	59.99),
(3,	7,	2,	29.99);

DROP TABLE IF EXISTS `stock`;
CREATE TABLE `stock` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `size` varchar(10) DEFAULT NULL,
  `stock_number` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `stock_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `stock` (`id`, `product_id`, `size`, `stock_number`) VALUES
(1,	1,	'S',	30),
(2,	1,	'M',	50),
(3,	1,	'L',	40),
(4,	2,	'S',	25),
(5,	2,	'M',	35),
(6,	2,	'L',	30),
(7,	3,	'M',	40),
(8,	3,	'L',	30),
(9,	3,	'XL',	20),
(10,	4,	'S',	15),
(11,	4,	'M',	25),
(12,	4,	'L',	20),
(13,	5,	'S',	50),
(14,	5,	'M',	60),
(15,	5,	'L',	45),
(16,	5,	'XL',	30),
(17,	6,	'S',	20),
(18,	6,	'M',	30),
(19,	6,	'L',	25),
(20,	7,	'M',	15),
(21,	7,	'L',	20),
(22,	7,	'XL',	10),
(23,	8,	'S',	25),
(24,	8,	'M',	35),
(25,	9,	'M',	40),
(26,	9,	'L',	30),
(27,	10,	'S',	20),
(28,	10,	'M',	15),
(29,	10,	'L',	25),
(30,	11,	'M',	30),
(31,	11,	'L',	20),
(32,	12,	'S',	45),
(33,	12,	'M',	55),
(34,	12,	'L',	35),
(35,	13,	'M',	30),
(36,	13,	'L',	25),
(37,	13,	'XL',	20),
(38,	14,	'M',	20),
(39,	14,	'L',	40),
(40,	15,	'S',	15),
(41,	15,	'M',	25),
(42,	15,	'L',	30),
(43,	16,	'M',	20),
(44,	16,	'L',	15),
(45,	16,	'XL',	10),
(46,	17,	'M',	12),
(47,	17,	'L',	18),
(48,	18,	'S',	30),
(49,	18,	'M',	40),
(50,	18,	'L',	25),
(51,	19,	'M',	35),
(52,	19,	'L',	28),
(53,	19,	'XL',	15),
(54,	20,	'M',	20),
(55,	20,	'L',	15),
(56,	21,	'S',	10),
(57,	21,	'M',	20),
(58,	21,	'L',	30),
(59,	22,	'M',	25),
(60,	22,	'L',	20),
(61,	23,	'M',	15),
(62,	23,	'L',	10),
(63,	23,	'XL',	8),
(64,	24,	'M',	12),
(65,	24,	'L',	10),
(66,	25,	'L',	15),
(67,	25,	'XL',	10),
(68,	26,	'M',	20),
(69,	26,	'L',	15),
(70,	27,	'M',	18),
(71,	27,	'L',	22),
(72,	27,	'XL',	12),
(73,	28,	'S',	10),
(74,	28,	'M',	15),
(75,	28,	'L',	12),
(76,	29,	'M',	30),
(77,	29,	'L',	25),
(78,	29,	'XL',	15),
(79,	30,	'M',	20),
(80,	30,	'L',	18),
(81,	31,	'M',	8),
(82,	31,	'L',	12),
(83,	31,	'XL',	6),
(84,	32,	'M',	10),
(85,	32,	'L',	8),
(86,	33,	'M',	15),
(87,	33,	'L',	20),
(88,	33,	'XL',	10),
(89,	34,	'M',	22),
(90,	34,	'L',	18),
(91,	35,	'M',	12),
(92,	35,	'L',	15),
(93,	36,	'M',	25),
(94,	36,	'L',	20),
(95,	37,	'M',	20),
(96,	37,	'L',	15),
(97,	38,	'M',	30),
(98,	38,	'L',	25),
(99,	39,	'M',	18),
(100,	39,	'L',	12),
(101,	40,	'M',	25),
(102,	40,	'L',	20),
(103,	41,	'M',	10),
(104,	41,	'L',	8),
(105,	42,	'M',	15),
(106,	42,	'L',	12),
(107,	43,	'M',	22),
(108,	43,	'L',	18),
(109,	44,	'M',	28),
(110,	44,	'L',	20),
(111,	45,	'M',	15),
(112,	45,	'L',	10),
(113,	46,	'M',	20),
(114,	46,	'L',	15),
(115,	47,	'S',	60),
(116,	47,	'M',	40),
(117,	48,	'M',	25),
(118,	48,	'L',	15),
(119,	49,	'L',	8),
(120,	50,	'S',	30),
(121,	50,	'M',	25),
(122,	51,	'M',	20),
(123,	51,	'L',	15),
(124,	52,	'M',	10),
(125,	52,	'L',	8),
(126,	53,	'XS',	100),
(127,	53,	'S',	90),
(128,	54,	'XS',	100),
(129,	54,	'S',	90),
(130,	55,	'XS',	1),
(131,	55,	'S',	0),
(132,	56,	'XS',	0);

DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `firstname` varchar(100) DEFAULT NULL,
  `lastname` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `role` enum('admin','gestionnaire','client') NOT NULL,
  `address` int DEFAULT NULL,
  `reset_token` varchar(255) DEFAULT NULL,
  `reset_token_expiry` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `address` (`address`),
  CONSTRAINT `user_ibfk_1` FOREIGN KEY (`address`) REFERENCES `address` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `user` (`id`, `email`, `password`, `firstname`, `lastname`, `phone`, `role`, `address`, `reset_token`, `reset_token_expiry`) VALUES
(1,	'admin@makeurshop.fr',	'$2b$10$lJpq.y.OVh1tT2kafSUBhOXbWypkYlljp4HRk8TDi22Rj/4rQexQi',	'Admin',	'Istrateur',	'0644444444',	'admin',	NULL,	NULL,	NULL);
