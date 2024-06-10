
-- 1/ Récupérer le numéro, la date et l'email du client des commandes passées en 2021, ordonnées par date

SELECT id_order, date_order, email
FROM customer c
    JOIN orders o USING(id_customer)
WHERE YEAR(date_order) = 2021
ORDER BY date_order;

-- 2/ Récupérer le nom, le prénom et l'email des clients n'ayant jamais passé de commande

SELECT firstname, lastname, email
FROM customer
    LEFT JOIN orders USING (id_customer)
WHERE id_order IS NULL;



-- 3/ Récupérer pour la commande numéro 15 pour chaque produit acheté : son nom, la quantité achetée, le prix d'achat unitaire et le prix total de la ligne

SELECT name_product, quantity, price_order, quantity * price_order AS total_price
FROM product
    JOIN product_order USING (ref_product)
WHERE id_order = 15;

-- 4/ Récupérer le nom et le prix des produits qui n'ont jamais été vendus

SELECT name_product, price
FROM product
   LEFT JOIN product_order USING (ref_product)
WHERE id_order IS NULL;

-- 5/ Récupérer le numéro, la date et le montant total des commandes d'avril 2022

SELECT id_order, date_order, SUM(price_order * quantity) AS total_price
FROM orders o
    JOIN product_order po USING(id_order)
WHERE YEAR(date_order) = 2022 AND MONTH(date_order) = 04
GROUP BY o.id_order;

-- 6/ Récupérer l'historique des commandes par ordre décroissant pour le client numéro 14
-- en affichant le montant total de chaque commande

SELECT id_order, date_order, SUM(quantity*price_order) AS total
FROM orders
    JOIN product_order USING(id_order)
WHERE id_customer = 14
GROUP BY id_order
ORDER BY date_order DESC;

-- 7/ Récupérer le nom et la quantité vendues pour chaque vin dont au moins 10 bouteilles ont été vendues

SELECT name_product, SUM(quantity) AS total_qty
FROM product JOIN product_order USING (ref_product)
WHERE name_product like "wine%" 
GROUP BY ref_product
HAVING total_qty >=10;

-- 8/ Récupérer le nom et le total de chiffre d'affaire de tous les produits (0.00 si le produit n'a pas été vendu)



-- 9/ Récupérer les noms des produits qui n'ont jamais été vendus
-- à un prix aussi bas qu'aujourd'hui



-- 10/ Récupérer pour toutes les commandes passées le 27 novembre 2021,
-- le nom, le prénom, l'email du client et le montant total



-- 11/ Récupérer l'adresse email des clients ayant effectués plus de 300 euros de commande au total en 2021



-- 12/ Récupérer le nom et le prénom du plus gros acheteur de vin en quantité



-- 13/ Récupérer les emails de tous les clients et aussi leur dernière date de commande
-- s'ils ont déjà passé commande



-- 14/ Récupérer l'historique des chiffres d'affaire mensuels des ventes de fromage



-- 15/ Récupérer le nom et le chiffre d'affaire total de décembre 2021
-- des produits ayant généré plus 100 € de chiffre d'affaire sur ce mois.



-- 16/ Récupérer pour chaque mois la valeur du panier moyen
-- (moyenne du total des commandes de la période)



-- BONUS.17/ Récupérer les emails des clients qui ont achetés en 2021 le produit "Cheese - Brie, Triple Creme" à moins de 80% de son prix actuel
