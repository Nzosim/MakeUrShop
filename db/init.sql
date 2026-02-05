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
-- Homme
(4, 1, 'T-shirt Homme Basic', 'T-shirt coton 100%', 19.99, 0, 'classique', TRUE),
(5, 4, 'Jean Homme Slim', 'Jean slim bleu', 49.99, 0, 'classique', TRUE),
(6, 2, 'Veste Homme Mi-saison', 'Veste légère', 89.99, 20, 'classique', TRUE),
(4, 1, 'T-shirt Homme Basic V2', 'T-shirt coton 100%', 19.99, 0, 'classique', TRUE),
(5, 4, 'Jean Homme Slim V2', 'Jean slim bleu', 49.99, 0, 'classique', TRUE),
(6, 2, 'Veste Homme Mi-saison V2', 'Veste légère', 89.99, 0, 'classique', TRUE),

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
(1, 'S', 30),
(1, 'M', 50),
(1, 'L', 40),
(2, 'M', 30),
(2, 'L', 25),
(2, 'XL', 20),
(3, 'L', 15),
(3, 'XL', 10),
(4, 'M', 20),
(5, 'L', 40),
(7, 'S', 60),
(8, 'M', 25),
(9, 'L', 8);




INSERT INTO image (product_id, url)
VALUES
(1, 'https://www.lapolemik.com/4295/t-shirt-homme-basic-citadel-blue.jpg'),
(2, 'https://www.vibs.com/on/demandware.static/-/Sites-Bonobo_master/default/dw0ca89ecb/jeans-slim-ultra-stretch-denim-stone-homme-vue1-36125211151230242.jpg'),
(3, 'https://www.gardedenfantspourtous.fr/wp-content/uploads/2022/06/veste-homme-mi-saison-686vso-1.jpg'),
(4, 'https://www.lapolemik.com/4295/t-shirt-homme-basic-citadel-blue.jpg'),
(5, 'https://www.vibs.com/on/demandware.static/-/Sites-Bonobo_master/default/dw0ca89ecb/jeans-slim-ultra-stretch-denim-stone-homme-vue1-36125211151230242.jpg'),
(6, 'https://www.gardedenfantspourtous.fr/wp-content/uploads/2022/06/veste-homme-mi-saison-686vso-1.jpg'),
(7, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRP8oaSDIicR1Enfndo9l2bc9laui4PIXNfYw&s'),
(8, 'https://images.etam.com/on/demandware.static/-/Sites-ELIN-master/default/dwb225c2c6/654542301_a.jpg?sw=1000&sh=1510'),
(9, 'https://medias.afibel.com/fr/media/6/5/jupe-longue-metallisee-plissee--65581_SF1_S-20240911104706.jpg?twic=v1/quality=85/cover=500x667'),
(10, 'https://m.media-amazon.com/images/I/6193-P7FPJL._AC_UY350_.jpg'),
(11, 'https://m.media-amazon.com/images/I/61HVV5nJWvL._AC_UY1000_.jpg'),
(12, 'https://www.lespetitsbaroudeurs.com/37852-large_default/veste-serkkula-reima.jpg');




INSERT INTO orders (user_id, shipping_address_id, billing_address_id, statut, total)
VALUES
(2, 1, 2, 'payee', 69.98),
(3, 3, 3, 'expediee', 59.99),
(4, 4, 4, 'livree', 29.99);

INSERT INTO order_list (order_id, product_id, quantity, unit_price)
VALUES
(1, 1, 2, 19.99),
(2, 4, 1, 59.99),
(3, 7, 2, 14.99);



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
