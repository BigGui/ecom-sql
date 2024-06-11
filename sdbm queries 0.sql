-- 1/ Combien de bières différentes sont disponibles dans la base de données ?

SELECT COUNT(id_article) AS nb_article
FROM article;

-- 2/ Quel est le nom de la bière avec le prix de vente le plus élevé ?

SELECT article_name, purchase_price
FROM article
ORDER BY purchase_price DESC
LIMIT 3;

-- 3/ Quel est le nom du continent qui compte le plus grand nombre de pays répertoriés dans la base de données ?

SELECT continent_name, COUNT(id_country) AS nb_countries
FROM continent
    JOIN country USING (id_continent)
GROUP BY id_continent
ORDER BY nb_countries DESC
LIMIT 1;

-- 4/ Quel est le nom du pays d'origine de la marque de bière "Heineken" ?

SELECT country_name
FROM country
    JOIN brand USING (id_country)
WHERE brand_name = "Heineken"
GROUP BY id_country;

-- 5/ Combien de bières ont été vendues lors de chaque transaction ? Afficher les numéros de ticket, la date de ticket, et le nombre de bières.

SELECT id_ticket, ticket_date, SUM(quantity) AS total
FROM sale 
    JOIN ticket USING (id_ticket)
GROUP BY id_ticket;

-- 6/ Quel est le nombre total de bières vendues jusqu'à présent ?

SELECT SUM(quantity) AS total_quantity
FROM sale;

-- 7/ Quelle est la marque de bière la plus vendue (en termes de quantité) ?

SELECT brand_name, SUM(quantity) AS sum_quantity
FROM brand
    JOIN article USING (id_brand)
    JOIN sale USING (id_article)
GROUP BY id_brand
ORDER BY sum_quantity DESC
LIMIT 1;