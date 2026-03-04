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




DROP TABLE IF EXISTS user;
CREATE TABLE user (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    firstname VARCHAR(100),
    lastname VARCHAR(100),
    phone VARCHAR(20),
    role ENUM('admin', 'gestionnaire', 'client') NOT NULL,
    address INT,
    FOREIGN KEY (address) REFERENCES address(id)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS address;
CREATE TABLE address (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    type ENUM('livraison', 'facturation') NOT NULL,
    address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    zip_code VARCHAR(20) NOT NULL,
    country VARCHAR(100) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES user(id)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS brand;
CREATE TABLE brand (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL
) ENGINE=InnoDB;

DROP TABLE IF EXISTS category;
CREATE TABLE category (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    category_parent_id INT,
    FOREIGN KEY (category_parent_id) REFERENCES category(id)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS product;
CREATE TABLE product (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT NOT NULL,
    brand_id INT,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    sale_price INT NOT NULL,
    type ENUM('classique', 'enchere') NOT NULL,
    actif BOOLEAN DEFAULT FALSE,
    creation_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    image INT,
    FOREIGN KEY (category_id) REFERENCES category(id),
    FOREIGN KEY (brand_id) REFERENCES brand(id)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS stock;
CREATE TABLE stock (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    size VARCHAR(10),
    stock_number INT NOT NULL,
    FOREIGN KEY (product_id) REFERENCES product(id)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS image;
CREATE TABLE image (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    url VARCHAR(500) NOT NULL,
    FOREIGN KEY (product_id) REFERENCES product(id)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    shipping_address_id INT NOT NULL,
    billing_address_id INT NOT NULL,
    statut ENUM('en_attente', 'payee', 'expediee', 'livree', 'annulee') NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES user(id),
    FOREIGN KEY (shipping_address_id) REFERENCES address(id),
    FOREIGN KEY (billing_address_id) REFERENCES address(id)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS order_list;
CREATE TABLE order_list (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES product(id)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS daily_stat;
CREATE TABLE daily_stat (
    id INT AUTO_INCREMENT PRIMARY KEY,
    date DATE NOT NULL,
    total_revenue DECIMAL(12,2),
    revenue_bid DECIMAL(12,2),
    revenue_classic DECIMAL(12,2),
    total_order_number INT,
    revenue_order_number INT,
    bid_order_number INT,
    average_cart DECIMAL(10,2),
    new_user_number INT
) ENGINE=InnoDB;

DROP TABLE IF EXISTS global_stat;
CREATE TABLE global_stat (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    total_order INT,
    total_revenue DECIMAL(12,2),
    FOREIGN KEY (user_id) REFERENCES user(id)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS daily_product_stat;
CREATE TABLE daily_product_stat (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    date DATE NOT NULL,
    view_number INT,
    add_cart_number INT,
    nb_order INT,
    total_revenue DECIMAL(12,2),
    FOREIGN KEY (product_id) REFERENCES product(id)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS product_status;
CREATE TABLE product_status (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    total_order INT,
    total_revenue DECIMAL(12,2),
    FOREIGN KEY (product_id) REFERENCES product(id)
) ENGINE=InnoDB;



-- Catégories parentes
INSERT INTO category (id, name, category_parent_id) VALUES
(1, 'Homme', NULL),
(2, 'Femme', NULL),
(3, 'Enfant', NULL);

-- Sous-catégories Homme
INSERT INTO category (name, category_parent_id) VALUES
('T-shirts', 1),
('Pantalons', 1),
('Vestes', 1),
('Chaussures', 1);

-- Sous-catégories Femme
INSERT INTO category (name, category_parent_id) VALUES
('Robes', 2),
('Tops', 2),
('Jupes', 2),
('Chaussures', 2);

-- Sous-catégories Enfant
INSERT INTO category (name, category_parent_id) VALUES
('T-shirts', 3),
('Pantalons', 3),
('Vestes', 3),
('Chaussures', 3);



INSERT INTO user (email, password, firstname, lastname, phone, role)
VALUES
('admin@shop.fr', 'hashed_pwd', 'Admin', 'Shop', '0600000000', 'admin'),
('client1@mail.fr', 'hashed_pwd', 'Lucas', 'Martin', '0611111111', 'client'),
('client2@mail.fr', 'hashed_pwd', 'Emma', 'Durand', '0622222222', 'client'),
('client3@mail.fr', 'hashed_pwd', 'Noah', 'Petit', '0633333333', 'client');



INSERT INTO address (user_id, type, address, city, zip_code, country)
VALUES
(2, 'livraison', '12 rue de Paris', 'Lyon', '69000', 'France'),
(2, 'facturation', '12 rue de Paris', 'Lyon', '69000', 'France'),
(3, 'livraison', '45 avenue Victor Hugo', 'Paris', '75016', 'France'),
(4, 'livraison', '8 boulevard Gambetta', 'Nice', '06000', 'France');



-- Marques
INSERT INTO brand (name) VALUES
('Nike'),
('Adidas'),
('Puma'),
('H&M'),
('Zara'),
('Tommy Hilfiger'),
('Calvin Klein');



INSERT INTO product (category_id, brand_id, name, description, price, sale_price, type, actif)
VALUES
-- Homme - T-shirts (catégorie 4)
(4, 1, 'T-shirt Homme Basic', 'T-shirt coton 100%', 19.99, 0, 'classique', TRUE),
(4, 1, 'T-shirt Homme Basic V2', 'T-shirt coton 100%', 19.99, 0, 'classique', TRUE),
(4, 2, 'T-shirt Homme Sport Adidas', 'T-shirt technique respirant', 29.99, 0, 'classique', TRUE),
(4, 3, 'T-shirt Homme Puma Essential', 'T-shirt casual confortable', 24.99, 15, 'classique', TRUE),
(4, 4, 'T-shirt Homme H&M Oversized', 'T-shirt oversize tendance', 14.99, 0, 'classique', TRUE),
(4, 5, 'T-shirt Homme Zara Premium', 'T-shirt coton premium', 22.99, 0, 'classique', TRUE),
(4, 6, 'T-shirt Homme Tommy Classic', 'T-shirt col rond classique', 39.99, 10, 'classique', TRUE),
(4, 7, 'T-shirt Homme Calvin Klein Logo', 'T-shirt avec logo brodé', 34.99, 0, 'classique', TRUE),
(4, 1, 'T-shirt Homme Nike Dri-FIT', 'T-shirt performance sport', 34.99, 0, 'classique', TRUE),
(4, 2, 'T-shirt Homme Adidas Trefoil', 'T-shirt rétro logo trèfle', 27.99, 20, 'classique', TRUE),
(4, 3, 'T-shirt Homme Puma Graphic', 'T-shirt imprimé graphique', 22.99, 0, 'classique', TRUE),
(4, 4, 'T-shirt Homme H&M Slim Fit', 'T-shirt ajusté stretch', 12.99, 0, 'classique', TRUE),

-- Homme - Pantalons (catégorie 5)
(5, 4, 'Jean Homme Slim', 'Jean slim bleu', 49.99, 0, 'classique', TRUE),
(5, 4, 'Jean Homme Slim V2', 'Jean slim bleu délavé', 49.99, 0, 'classique', TRUE),
(5, 5, 'Pantalon Homme Chino Zara', 'Chino coupe droite beige', 39.99, 0, 'classique', TRUE),
(5, 6, 'Jean Homme Tommy Regular', 'Jean regular fit indigo', 79.99, 15, 'classique', TRUE),
(5, 7, 'Jean Homme Calvin Klein Straight', 'Jean droit noir', 89.99, 0, 'classique', TRUE),
(5, 1, 'Jogger Homme Nike Tech', 'Pantalon jogger tech fleece', 59.99, 0, 'classique', TRUE),
(5, 2, 'Pantalon Homme Adidas Training', 'Pantalon entraînement', 44.99, 25, 'classique', TRUE),
(5, 3, 'Pantalon Homme Puma Cargo', 'Pantalon cargo streetwear', 54.99, 0, 'classique', TRUE),
(5, 4, 'Pantalon Homme H&M Lin', 'Pantalon en lin léger', 34.99, 0, 'classique', TRUE),
(5, 5, 'Jean Homme Zara Skinny', 'Jean skinny stretch noir', 45.99, 10, 'classique', TRUE),
(5, 6, 'Pantalon Homme Tommy Chino', 'Chino Tommy coupe slim', 69.99, 0, 'classique', TRUE),
(5, 7, 'Jean Homme CK Slim Taper', 'Jean slim tapered gris', 94.99, 0, 'classique', TRUE),

-- Homme - Vestes (catégorie 6)
(6, 2, 'Veste Homme Mi-saison', 'Veste légère', 89.99, 20, 'classique', TRUE),
(6, 2, 'Veste Homme Mi-saison V2', 'Veste légère imperméable', 89.99, 0, 'classique', TRUE),
(6, 1, 'Veste Homme Nike Windrunner', 'Coupe-vent classique', 99.99, 0, 'classique', TRUE),
(6, 3, 'Veste Homme Puma Bomber', 'Bomber jacket streetwear', 79.99, 10, 'classique', TRUE),
(6, 4, 'Veste Homme H&M Denim', 'Veste en jean classique', 49.99, 0, 'classique', TRUE),
(6, 5, 'Veste Homme Zara Blazer', 'Blazer casual marine', 89.99, 0, 'classique', TRUE),
(6, 6, 'Veste Homme Tommy Padded', 'Doudoune légère', 149.99, 30, 'classique', TRUE),
(6, 7, 'Veste Homme CK Leather', 'Veste cuir synthétique', 129.99, 0, 'classique', TRUE),
(6, 1, 'Veste Homme Nike Down Fill', 'Doudoune chaude hiver', 159.99, 0, 'classique', TRUE),
(6, 2, 'Veste Homme Adidas Track', 'Veste de survêtement rétro', 69.99, 15, 'classique', TRUE),
(6, 5, 'Veste Homme Zara Parka', 'Parka longue kaki', 119.99, 0, 'classique', TRUE),
(6, 4, 'Veste Homme H&M Matelassée', 'Veste matelassée noire', 59.99, 0, 'classique', TRUE),

-- Homme - Chaussures (catégorie 7)
(7, 1, 'Nike Air Max 90 Homme', 'Sneakers iconiques', 139.99, 0, 'classique', TRUE),
(7, 2, 'Adidas Stan Smith Homme', 'Baskets cuir blanc', 99.99, 0, 'classique', TRUE),
(7, 3, 'Puma Suede Classic Homme', 'Baskets daim rétro', 79.99, 20, 'classique', TRUE),
(7, 1, 'Nike Air Force 1 Homme', 'Sneakers blanches classiques', 109.99, 0, 'classique', TRUE),
(7, 2, 'Adidas Ultraboost Homme', 'Running haute performance', 179.99, 15, 'classique', TRUE),
(7, 3, 'Puma RS-X Homme', 'Sneakers chunky colorées', 109.99, 0, 'classique', TRUE),
(7, 1, 'Nike Dunk Low Homme', 'Sneakers streetwear', 119.99, 0, 'classique', TRUE),
(7, 2, 'Adidas Gazelle Homme', 'Baskets rétro suède', 89.99, 10, 'classique', TRUE),
(7, 5, 'Zara Boots Homme Chelsea', 'Boots chelsea cuir', 69.99, 0, 'classique', TRUE),
(7, 6, 'Tommy Hilfiger Sneakers Homme', 'Sneakers casual cuir', 99.99, 0, 'classique', TRUE),

-- Femme
(8, 5, 'Robe Femme Été', 'Robe fluide', 59.99, 0, 'classique', TRUE),
(9, 6, 'Top Femme Blanc', 'Top manches courtes', 24.99, 0, 'classique', TRUE),
(10, 5, 'Jupe Femme Plissée', 'Jupe mi-longue', 39.99, 0, 'enchere', TRUE),

-- Enfant
(12, 3, 'T-shirt Enfant Fun', 'T-shirt imprimé', 14.99, 0, 'classique', TRUE),
(13, 2, 'Pantalon Enfant', 'Pantalon confortable', 29.99, 0, 'classique', TRUE),
(14, 1, 'Veste Enfant Hiver', 'Veste chaude', 79.99, 0, 'enchere', TRUE);



INSERT INTO stock (product_id, size, stock_number)
VALUES
-- T-shirts Homme
(1, 'S', 30), (1, 'M', 50), (1, 'L', 40),
(2, 'S', 25), (2, 'M', 35), (2, 'L', 30),
(3, 'M', 40), (3, 'L', 30), (3, 'XL', 20),
(4, 'S', 15), (4, 'M', 25), (4, 'L', 20),
(5, 'S', 50), (5, 'M', 60), (5, 'L', 45), (5, 'XL', 30),
(6, 'S', 20), (6, 'M', 30), (6, 'L', 25),
(7, 'M', 15), (7, 'L', 20), (7, 'XL', 10),
(8, 'S', 25), (8, 'M', 35),
(9, 'M', 40), (9, 'L', 30),
(10, 'S', 20), (10, 'M', 15), (10, 'L', 25),
(11, 'M', 30), (11, 'L', 20),
(12, 'S', 45), (12, 'M', 55), (12, 'L', 35),
-- Pantalons Homme
(13, 'M', 30), (13, 'L', 25), (13, 'XL', 20),
(14, 'M', 20), (14, 'L', 40),
(15, 'S', 15), (15, 'M', 25), (15, 'L', 30),
(16, 'M', 20), (16, 'L', 15), (16, 'XL', 10),
(17, 'M', 12), (17, 'L', 18),
(18, 'S', 30), (18, 'M', 40), (18, 'L', 25),
(19, 'M', 35), (19, 'L', 28), (19, 'XL', 15),
(20, 'M', 20), (20, 'L', 15),
(21, 'S', 10), (21, 'M', 20), (21, 'L', 30),
(22, 'M', 25), (22, 'L', 20),
(23, 'M', 15), (23, 'L', 10), (23, 'XL', 8),
(24, 'M', 12), (24, 'L', 10),
-- Vestes Homme
(25, 'L', 15), (25, 'XL', 10),
(26, 'M', 20), (26, 'L', 15),
(27, 'M', 18), (27, 'L', 22), (27, 'XL', 12),
(28, 'S', 10), (28, 'M', 15), (28, 'L', 12),
(29, 'M', 30), (29, 'L', 25), (29, 'XL', 15),
(30, 'M', 20), (30, 'L', 18),
(31, 'M', 8), (31, 'L', 12), (31, 'XL', 6),
(32, 'M', 10), (32, 'L', 8),
(33, 'M', 15), (33, 'L', 20), (33, 'XL', 10),
(34, 'M', 22), (34, 'L', 18),
(35, 'M', 12), (35, 'L', 15),
(36, 'M', 25), (36, 'L', 20),
-- Chaussures Homme
(37, 'M', 20), (37, 'L', 15),
(38, 'M', 30), (38, 'L', 25),
(39, 'M', 18), (39, 'L', 12),
(40, 'M', 25), (40, 'L', 20),
(41, 'M', 10), (41, 'L', 8),
(42, 'M', 15), (42, 'L', 12),
(43, 'M', 22), (43, 'L', 18),
(44, 'M', 28), (44, 'L', 20),
(45, 'M', 15), (45, 'L', 10),
(46, 'M', 20), (46, 'L', 15),
-- Femme
(47, 'S', 60), (47, 'M', 40),
(48, 'M', 25), (48, 'L', 15),
(49, 'L', 8),
-- Enfant
(50, 'S', 30), (50, 'M', 25),
(51, 'M', 20), (51, 'L', 15),
(52, 'M', 10), (52, 'L', 8);




INSERT INTO image (product_id, url)
VALUES
-- T-shirts Homme
(1, 'https://www.lapolemik.com/4295/t-shirt-homme-basic-citadel-blue.jpg'),
(2, 'https://www.lapolemik.com/4295/t-shirt-homme-basic-citadel-blue.jpg'),
(3, 'https://assets.adidas.com/images/w_600,f_auto,q_auto/a1a4f5c5d02f4b6e8e1daf0000a0e8b0_9366/T-shirt_Essentials_Blanc_GL0058_01_laydown.jpg'),
(4, 'https://images.puma.com/image/upload/f_auto,q_auto,b_rgb:fafafa,w_600,h_600/global/586668/56/mod01/fnd/EEA/fmt/png'),
(5, 'https://www.lapolemik.com/4295/t-shirt-homme-basic-citadel-blue.jpg'),
(6, 'https://www.lapolemik.com/4295/t-shirt-homme-basic-citadel-blue.jpg'),
(7, 'https://www.lapolemik.com/4295/t-shirt-homme-basic-citadel-blue.jpg'),
(8, 'https://www.lapolemik.com/4295/t-shirt-homme-basic-citadel-blue.jpg'),
(9, 'https://www.lapolemik.com/4295/t-shirt-homme-basic-citadel-blue.jpg'),
(10, 'https://www.lapolemik.com/4295/t-shirt-homme-basic-citadel-blue.jpg'),
(11, 'https://www.lapolemik.com/4295/t-shirt-homme-basic-citadel-blue.jpg'),
(12, 'https://www.lapolemik.com/4295/t-shirt-homme-basic-citadel-blue.jpg'),
-- Pantalons Homme
(13, 'https://www.vibs.com/on/demandware.static/-/Sites-Bonobo_master/default/dw0ca89ecb/jeans-slim-ultra-stretch-denim-stone-homme-vue1-36125211151230242.jpg'),
(14, 'https://www.vibs.com/on/demandware.static/-/Sites-Bonobo_master/default/dw0ca89ecb/jeans-slim-ultra-stretch-denim-stone-homme-vue1-36125211151230242.jpg'),
(15, 'https://www.vibs.com/on/demandware.static/-/Sites-Bonobo_master/default/dw0ca89ecb/jeans-slim-ultra-stretch-denim-stone-homme-vue1-36125211151230242.jpg'),
(16, 'https://www.vibs.com/on/demandware.static/-/Sites-Bonobo_master/default/dw0ca89ecb/jeans-slim-ultra-stretch-denim-stone-homme-vue1-36125211151230242.jpg'),
(17, 'https://www.vibs.com/on/demandware.static/-/Sites-Bonobo_master/default/dw0ca89ecb/jeans-slim-ultra-stretch-denim-stone-homme-vue1-36125211151230242.jpg'),
(18, 'https://www.vibs.com/on/demandware.static/-/Sites-Bonobo_master/default/dw0ca89ecb/jeans-slim-ultra-stretch-denim-stone-homme-vue1-36125211151230242.jpg'),
(19, 'https://www.vibs.com/on/demandware.static/-/Sites-Bonobo_master/default/dw0ca89ecb/jeans-slim-ultra-stretch-denim-stone-homme-vue1-36125211151230242.jpg'),
(20, 'https://www.vibs.com/on/demandware.static/-/Sites-Bonobo_master/default/dw0ca89ecb/jeans-slim-ultra-stretch-denim-stone-homme-vue1-36125211151230242.jpg'),
(21, 'https://www.vibs.com/on/demandware.static/-/Sites-Bonobo_master/default/dw0ca89ecb/jeans-slim-ultra-stretch-denim-stone-homme-vue1-36125211151230242.jpg'),
(22, 'https://www.vibs.com/on/demandware.static/-/Sites-Bonobo_master/default/dw0ca89ecb/jeans-slim-ultra-stretch-denim-stone-homme-vue1-36125211151230242.jpg'),
(23, 'https://www.vibs.com/on/demandware.static/-/Sites-Bonobo_master/default/dw0ca89ecb/jeans-slim-ultra-stretch-denim-stone-homme-vue1-36125211151230242.jpg'),
(24, 'https://www.vibs.com/on/demandware.static/-/Sites-Bonobo_master/default/dw0ca89ecb/jeans-slim-ultra-stretch-denim-stone-homme-vue1-36125211151230242.jpg'),
-- Vestes Homme
(25, 'https://www.gardedenfantspourtous.fr/wp-content/uploads/2022/06/veste-homme-mi-saison-686vso-1.jpg'),
(26, 'https://www.gardedenfantspourtous.fr/wp-content/uploads/2022/06/veste-homme-mi-saison-686vso-1.jpg'),
(27, 'https://www.gardedenfantspourtous.fr/wp-content/uploads/2022/06/veste-homme-mi-saison-686vso-1.jpg'),
(28, 'https://www.gardedenfantspourtous.fr/wp-content/uploads/2022/06/veste-homme-mi-saison-686vso-1.jpg'),
(29, 'https://www.gardedenfantspourtous.fr/wp-content/uploads/2022/06/veste-homme-mi-saison-686vso-1.jpg'),
(30, 'https://www.gardedenfantspourtous.fr/wp-content/uploads/2022/06/veste-homme-mi-saison-686vso-1.jpg'),
(31, 'https://www.gardedenfantspourtous.fr/wp-content/uploads/2022/06/veste-homme-mi-saison-686vso-1.jpg'),
(32, 'https://www.gardedenfantspourtous.fr/wp-content/uploads/2022/06/veste-homme-mi-saison-686vso-1.jpg'),
(33, 'https://www.gardedenfantspourtous.fr/wp-content/uploads/2022/06/veste-homme-mi-saison-686vso-1.jpg'),
(34, 'https://www.gardedenfantspourtous.fr/wp-content/uploads/2022/06/veste-homme-mi-saison-686vso-1.jpg'),
(35, 'https://www.gardedenfantspourtous.fr/wp-content/uploads/2022/06/veste-homme-mi-saison-686vso-1.jpg'),
(36, 'https://www.gardedenfantspourtous.fr/wp-content/uploads/2022/06/veste-homme-mi-saison-686vso-1.jpg'),
-- Chaussures Homme
(37, 'https://static.nike.com/a/images/t_PDP_936_v1/f_auto,q_auto:eco/b7d9211c-26e7-431a-ac24-b0540fb3c00f/AIR+MAX+90.png'),
(38, 'https://static.nike.com/a/images/t_PDP_936_v1/f_auto,q_auto:eco/b7d9211c-26e7-431a-ac24-b0540fb3c00f/AIR+MAX+90.png'),
(39, 'https://static.nike.com/a/images/t_PDP_936_v1/f_auto,q_auto:eco/b7d9211c-26e7-431a-ac24-b0540fb3c00f/AIR+MAX+90.png'),
(40, 'https://static.nike.com/a/images/t_PDP_936_v1/f_auto,q_auto:eco/b7d9211c-26e7-431a-ac24-b0540fb3c00f/AIR+MAX+90.png'),
(41, 'https://static.nike.com/a/images/t_PDP_936_v1/f_auto,q_auto:eco/b7d9211c-26e7-431a-ac24-b0540fb3c00f/AIR+MAX+90.png'),
(42, 'https://static.nike.com/a/images/t_PDP_936_v1/f_auto,q_auto:eco/b7d9211c-26e7-431a-ac24-b0540fb3c00f/AIR+MAX+90.png'),
(43, 'https://static.nike.com/a/images/t_PDP_936_v1/f_auto,q_auto:eco/b7d9211c-26e7-431a-ac24-b0540fb3c00f/AIR+MAX+90.png'),
(44, 'https://static.nike.com/a/images/t_PDP_936_v1/f_auto,q_auto:eco/b7d9211c-26e7-431a-ac24-b0540fb3c00f/AIR+MAX+90.png'),
(45, 'https://static.nike.com/a/images/t_PDP_936_v1/f_auto,q_auto:eco/b7d9211c-26e7-431a-ac24-b0540fb3c00f/AIR+MAX+90.png'),
(46, 'https://static.nike.com/a/images/t_PDP_936_v1/f_auto,q_auto:eco/b7d9211c-26e7-431a-ac24-b0540fb3c00f/AIR+MAX+90.png'),
-- Femme
(47, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRP8oaSDIicR1Enfndo9l2bc9laui4PIXNfYw&s'),
(48, 'https://images.etam.com/on/demandware.static/-/Sites-ELIN-master/default/dwb225c2c6/654542301_a.jpg?sw=1000&sh=1510'),
(49, 'https://medias.afibel.com/fr/media/6/5/jupe-longue-metallisee-plissee--65581_SF1_S-20240911104706.jpg?twic=v1/quality=85/cover=500x667'),
-- Enfant
(50, 'https://m.media-amazon.com/images/I/6193-P7FPJL._AC_UY350_.jpg'),
(51, 'https://m.media-amazon.com/images/I/61HVV5nJWvL._AC_UY1000_.jpg'),
(52, 'https://www.lespetitsbaroudeurs.com/37852-large_default/veste-serkkula-reima.jpg');




INSERT INTO orders (user_id, shipping_address_id, billing_address_id, statut, total)
VALUES
(2, 1, 2, 'payee', 69.98),
(3, 3, 3, 'expediee', 59.99),
(4, 4, 4, 'livree', 29.99);

INSERT INTO order_list (order_id, product_id, quantity, unit_price)
VALUES
(1, 1, 2, 19.99),
(2, 47, 1, 59.99),
(3, 50, 2, 14.99);



INSERT INTO daily_stat
(date, total_revenue, revenue_bid, revenue_classic, total_order_number,
revenue_order_number, bid_order_number, average_cart, new_user_number)
VALUES
('2026-01-20', 159.96, 39.99, 119.97, 3, 2, 1, 53.32, 2);

INSERT INTO global_stat (user_id, total_order, total_revenue)
VALUES
(2, 1, 39.98),
(3, 1, 59.99),
(4, 1, 29.99);

INSERT INTO daily_product_stat
(product_id, date, view_number, add_cart_number, nb_order, total_revenue)
VALUES
(1, '2026-01-20', 120, 30, 2, 39.98),
(4, '2026-01-20', 80, 15, 1, 59.99),
(7, '2026-01-20', 60, 20, 2, 29.99);

INSERT INTO product_status (product_id, total_order, total_revenue)
VALUES
(1, 2, 39.98),
(4, 1, 59.99),
(7, 2, 29.99);
