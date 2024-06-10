
-- 1/ Récupérer le nombre de clients total dans la base de données

SELECT COUNT(id_customer) AS nb_customers 
FROM customer;

-- 2/ Récupérer le nombre de clients qui ont été créés chaque jour

SELECT  date_create, COUNT(DISTINCT id_customer) AS nb_customers
FROM customer
GROUP BY date_create
ORDER BY date_create;

-- 3/ Récupérer le prix du produit le plus bas

SELECT MIN(price) AS min_price
FROM product;

SELECT price AS min_price
FROM product
ORDER BY price ASC
LIMIT 1;

-- 4/ Récupérer le prix du produit le plus élevé

SELECT MAX(price) AS max_price
FROM product;

SELECT price AS max_price
FROM product
ORDER BY price DESC
LIMIT 1;

-- 5/ Récupérer le numéro des clients ayant commandé avec la date de leur dernière commande,
-- classés par cette date de dernière commande décroissant

SELECT id_customer, MAX(date_order) AS last_order
FROM orders
GROUP BY id_customer
ORDER BY last_order DESC;

-- 6/ Récupérer la liste des jours de commande par ordre décroissant avec pour chaque jour le nombre de commandes passées

SELECT date_order, COUNT(id_order) AS nb_order
FROM orders
GROUP BY date_order
ORDER BY date_order DESC;

-- 7/ Récupérer les identifiants des commandes et pour chacune le nombre total de produits achetés

SELECT id_order, SUM(quantity) AS sum_quantity_bought
FROM product_order
GROUP BY id_order;

-- 8/ Récupérer le nombre de comptes clients créés pour chaque année

SELECT YEAR(date_create) as year_create, COUNT(id_customer) AS create_customer_by_year
FROM customer
GROUP BY YEAR(date_create);


-- 9/ Récupérer le montant total de la commande numéro 12

SELECT SUM(price_order * quantity) AS total_price
FROM product_order
WHERE id_order = 12;

-- 10/ Récupérer les identifiants des commandes et pour chacune le montant total payé par le client

SELECT id_order, SUM(price_order * quantity) AS total_paid
FROM product_order
GROUP BY id_order;

-- 11/ Récupérer pour chaque mois le nombre de commandes passées classé par mois croissant

SELECT
    MONTH(`date_order`) AS month,
    YEAR(`date_order`) AS year,
    COUNT(`id_order`) AS order_by_month
FROM `orders` 
GROUP BY year, month
ORDER BY year, month;

SELECT
    DATE_FORMAT(date_order, "%Y%m") AS ym,
    COUNT(`id_order`) AS order_by_month
FROM `orders` 
GROUP BY ym
ORDER BY ym;

SELECT
    EXTRACT(YEAR_MONTH FROM date_order) AS ym,
    COUNT(`id_order`) AS order_by_month
FROM `orders` 
GROUP BY ym
ORDER BY ym;

-- 12/ Récupérer les identifiants des clients ayant passées au moins 3 commandes

SELECT id_customer, COUNT(id_order) AS nb_order
FROM orders
GROUP BY id_customer
HAVING nb_order >= 3;

-- 13/ Récupérer les références des produits dont il a déjà été vendu plus de 20 exemplaires, triés par nombre d'exemplaires vendus décroissant



-- 14/ Récupérer la référence et le chiffre d'affaire du produit qui a généré le plus de chiffre d'affaire


-- BONUS.15/ Récupérer les identifiants des clients ayant passés au moins 3 commandes en 2022


-- BONUS.16/ Récupérer les identifiants des produits dont le prix a varié de plus 8 € dans l'historique des ventes 


-- BONUS.17/ Récupérer l'identifiant des produits dont le prix de vente moyen est supérieur à 20€ et dont au moins 15 exemplaires ont déjà été vendus 
