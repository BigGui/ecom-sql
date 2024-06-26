-- 1/ Afficher la liste des articles avec leur nom, prix d'achat et quantité totale vendue (en nombre de bière).

SELECT article_name,purchase_price, SUM(quantity) as quantity_total
 From article
  JOIN sale USING (id_article)
  GROUP BY id_article;

-- 2/ Afficher le nombre de bières vendues par pays, en affichant le nom du pays.
SELECT country_name, COUNT(id_article) as quantity_total
FROM country    
    JOIN brand USING(id_country)
    JOIN article USING(id_brand)
GROUP BY id_country
ORDER BY quantity_total DESC;



-- 3/ Afficher la quantité totale de bières vendues par marque, avec le nom de chaque marque, triée par ordre décroissant.
SELECT SUM(quantity) AS total_qty, brand_name
FROM sale
    JOIN article USING (id_article)
    JOIN brand USING (id_brand)
GROUP BY id_brand
ORDER BY total_qty DESC;

-- 4/ Afficher la quantité totale de bières vendues par continent, en affichant le nom du continent.

SELECT SUM(quantity) AS total_qty, continent_name
FROM sale
    JOIN article USING (id_article)
    JOIN brand USING (id_brand)
    JOIN country USING (id_country)
    JOIN continent USING (id_continent)
GROUP BY id_continent
ORDER BY total_qty DESC;

-- 5/ Afficher la moyenne des prix d'achat des articles par type, en indiquant le nom du type et la moyenne des prix d'achat.

SELECT type_name, ROUND(AVG(purchase_price), 2) AS average
FROM type
    JOIN article USING (id_type)
GROUP BY id_type;

-- 6/ Afficher la somme des quantités vendues pour chaque couleur de bière, en affichant le nom de la couleur et la somme des quantités.

SELECT color_name, SUM(quantity) AS total_quantity
FROM color
    JOIN article USING (id_color)
    JOIN sale USING (id_article)
GROUP BY id_color;

-- 7/ Afficher le volume total des ventes réalisées pour chaque marque, trié par ordre décroissant.

SELECT brand_name, SUM(volume * quantity) / 100 AS total_vol_litre,  SUM(purchase_price * quantity) AS total_revenue
FROM brand  
    JOIN article USING (id_brand)
    JOIN sale  USING (id_article)
GROUP BY id_brand
ORDER BY total_vol DESC;

-- 8/ Afficher le prix d'achat moyen des articles pour chaque pays, en indiquant le nom du pays et le prix d'achat moyen.

SELECT country_name, ROUND(AVG(purchase_price), 2) AS average_price
FROM country   
    JOIN brand USING (id_country)
    JOIN article USING (id_brand)
GROUP BY id_country; 

-- 9/ Afficher le prix d'achat le plus élevé et le prix d'achat le plus bas par continent, en précisant le nom du continent.

SELECT continent_name, MAX(purchase_price) AS max_purchase_price, MIN(purchase_price) AS min_purchase_price
FROM article
    JOIN brand USING (id_brand)
    JOIN country USING (id_country)
    JOIN continent USING (id_continent)
GROUP BY id_continent;

-- 10/ Afficher le nombre total d'articles vendus pour chaque type de bière, en affichant le nom du type et le nombre total d'articles vendus.

SELECT type_name, SUM(quantity) AS sum_quantity
FROM sale
    JOIN article USING (id_article)
    JOIN type USING (id_type)
GROUP BY id_type;