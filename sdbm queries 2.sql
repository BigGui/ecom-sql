-- 1/ Quels sont les tickets qui comportent l'article d'ID 500 ?
-- Afficher le numéro de ticket uniquement.

SELECT id_ticket
FROM sale
WHERE id_article = 500;

-- 2/ Quels sont les tickets du 15/01/2017 ?
-- Afficher le numéro de ticket et la date.

SELECT id_ticket, ticket_date
FROM ticket
WHERE ticket_date = "2017-01-15"

-- 3/ Quels sont les tickets émis du 15/01/2017 au 17/01/2017 ?
-- Afficher le numéro de ticket et la date.

SELECT id_ticket, ticket_date
FROM ticket
WHERE ticket_date BETWEEN "2017-01-15" AND "2017-01-17";

-- 4/ Quels sont les articles (Code et nom uniquement) apparaissant sur un ticket à au moins 95 exemplaires.

SELECT id_article, article_name
FROM sale
    JOIN article USING (id_article)
WHERE quantity >= 95
GROUP BY id_article;

-- 5/ Quels sont les tickets émis au mois de mars 2017 ?
-- Afficher le numéro de ticket et la date.

SELECT id_ticket, ticket_date
FROM ticket
WHERE EXTRACT(YEAR_MONTH FROM ticket_date) = 201703
ORDER BY ticket_date;

SELECT id_ticket, ticket_date
FROM ticket
WHERE ticket_date LIKE "2017-03-%"
ORDER BY ticket_date;

SELECT id_ticket, ticket_date
FROM ticket
WHERE MONTH(ticket_date) = 3 AND YEAR(ticket_date) = 2017;
ORDER BY ticket_date;


-- 6/ Quels sont les tickets émis au deuxième trimestre 2017 ?
-- Afficher le numéro de ticket et la date.

SELECT id_ticket, ticket_date
FROM ticket
WHERE ticket_date BETWEEN "2017-04-01" AND "2017-06-30"
ORDER BY ticket_date;

SELECT id_ticket, ticket_date
FROM ticket
WHERE QUARTER(ticket_date) = 2 AND YEAR(ticket_date) = 2017
ORDER BY ticket_date;

-- 7/ Quels sont les tickets émis au mois de mars et juillet 2017 ?
-- Afficher le numéro de ticket et la date.

SELECT id_ticket, ticket_date
FROM ticket
WHERE DATE_FORMAT(ticket_date, "%Y-%m") IN ("2017-03", "2017-07");

SELECT id_ticket, ticket_date
FROM ticket
WHERE YEAR(ticket_date) = 2017
AND MONTH(ticket_date) IN (3, 7);


-- 8/ Afficher la liste de toutes les bières classée par couleur.
-- Afficher code et nom de bière, nom de la couleur

SELECT id_article, article_name, IFNULL(color_name, '-- PAS DE COULEUR --') AS id_color
FROM article
    LEFT JOIN color USING (id_color)
ORDER BY color_name;

-- 9/ Afficher la liste des bières n'ayant pas de couleur. 
-- Afficher le code et le nom

SELECT id_article, article_name
FROM article
WHERE id_color IS NULL;

-- 10/ Lister pour chaque ticket la quantité totale d'articles vendus (en nombre).
-- Classer par quantité décroissante

SELECT id_ticket, SUM(quantity) AS total
FROM sale
GROUP BY id_ticket
ORDER BY total DESC;

-- 11/ Lister chaque ticket pour lequel la quantité totale d'articles vendus est inférieure à 50.
-- Classer par quantité croissante

SELECT id_ticket, SUM(quantity) AS total
FROM sale
GROUP BY id_ticket
HAVING total < 50
ORDER BY total ASC;

-- 12/ Lister chaque ticket pour lequel la quantité totale d'articles vendus est supérieure à 500.
-- Classer par quantité décroissante

SELECT id_ticket, SUM(quantity) AS total
FROM sale
GROUP BY id_ticket
HAVING total > 500
ORDER BY total DESC;

-- 13/ Lister chaque ticket pour lequel la quantité totale d'articles vendus est supérieure à 500. On exclura du total, les ventes de 50 articles et plus.
-- classer par quantité décroissante

SELECT id_ticket, SUM(quantity) AS total
FROM sale
WHERE quantity < 50
GROUP BY id_ticket
HAVING total > 500
ORDER BY total DESC;


-- 14/ Lister les bières de type ‘Trappiste'.
-- Afficher id, nom de la bière, volume et titrage

SELECT id_article, article_name, volume, alcohol
FROM article
    JOIN type USING (id_type)
WHERE type_name = "Trappiste";

-- 15/ Lister les marques du continent ‘Afrique'.
-- Afficher id et nom de marque, nom du continent

SELECT id_brand, brand_name, continent_name
FROM brand 
    JOIN country USING (id_country)
    JOIN continent USING (id_continent)
WHERE continent_name = "Afrique";

-- 16/ Lister les bières du continent ‘Afrique'.
-- Afficher ID, Nom et volume

SELECT id_article, article_name, volume
FROM article
    JOIN brand USING (id_brand)
    JOIN country USING (id_country)
    JOIN continent USING (id_continent)
WHERE continent_name = "Afrique";

-- 17/ Lister les tickets classés par montant décroissant.
-- Afficher l'année, numéro de ticket, montant total à payer
--     En sachant que l'on applique un taux de TVA de 20% au montant total hors taxe de chaque ticket.

SELECT id_ticket, YEAR(ticket_date) AS year_, ROUND(SUM(quantity * purchase_price) * 1.2, 2) AS total_price_tax
FROM ticket
    JOIN sale USING (id_ticket)
    JOIN article USING (id_article)
GROUP BY id_ticket
ORDER BY total_price_tax DESC;

-- 18/ Donner le C.A. par année.
-- Afficher les années et Total HT

SELECT YEAR(ticket_date) AS year_, SUM(quantity * purchase_price) AS total_ex_tax
FROM ticket
    JOIN sale USING (id_ticket)
    JOIN article USING (id_article)
GROUP BY year_
ORDER BY year_;

-- 19/ Lister les quantités vendues de chaque article pour l'année 2017.
-- Afficher id et nom de l'article, quantité vendue

SELECT id_article, article_name, SUM(quantity) AS total
FROM article
    JOIN sale USING (id_article)
    JOIN ticket USING (id_ticket)
WHERE YEAR(ticket_date) = 2017
GROUP BY id_article;