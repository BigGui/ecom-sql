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


-- 5/ Afficher la moyenne des prix d'achat des articles par type, en indiquant le nom du type et la moyenne des prix d'achat.


-- 6/ Afficher la somme des quantités vendues pour chaque couleur de bière, en affichant le nom de la couleur et la somme des quantités.


-- 7/ Afficher le volume total des ventes réalisées pour chaque marque, trié par ordre décroissant.


-- 8/ Afficher le prix d'achat moyen des articles pour chaque pays, en indiquant le nom du pays et le prix d'achat moyen.


-- 9/ Afficher le prix d'achat le plus élevé et le prix d'achat le plus bas par continent, en précisant le nom du continent.


-- 10/ Afficher le nombre total d'articles vendus pour chaque type de bière, en affichant le nom du type et le nombre total d'articles vendus.