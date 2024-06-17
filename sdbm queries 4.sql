-- 1/ Récupérer toutes les bières les plus alcoolisés de chaque continent
-- afficher le nom du contient , le nom de la bière, le degrès d'alcool et le volume 

SELECT article_name, alcohol, continent_name, volume
FROM article
    JOIN brand USING(id_brand)
    JOIN country USING(id_country)
    JOIN continent c USING(id_continent)
WHERE alcohol = (
    SELECT MAX(alcohol)
    FROM article
        JOIN brand USING(id_brand)
        JOIN country USING(id_country)
        JOIN continent USING(id_continent)
    WHERE id_continent = c.id_continent
);


-- 2/ Récupérer le volume de bières vendu pour chaque mois et pour chaque type de bière
-- classés par années, mois et type de bière

SELECT DATE_FORMAT(ticket_date, '%Y-%m') AS month_, type_name, SUM(volume * quantity)/100 AS sum
FROM article join type USING (id_type) 
JOIN sale USING(id_article) 
JOIN ticket USING(id_ticket)
GROUP BY id_type, month_
ORDER BY month_, type_name;

-- 3/ Récupérer le nom et le volume des bières allemandes achetées en même temps que des bières françaises
-- classés par nom de bière

SELECT id_article, article_name, volume
FROM sale s
    JOIN article USING (id_article)
    JOIN brand USING (id_brand)
    JOIN country USING (id_country)
WHERE country_name = 'allemagne' AND EXISTS (
    SELECT id_ticket
    FROM sale
        JOIN article USING (id_article)
        JOIN brand USING (id_brand)
        JOIN country USING (id_country)
    WHERE country_name = 'france' AND
    id_ticket = s.id_ticket
    GROUP BY id_ticket
)
GROUP BY id_article
ORDER BY article_name;

-- 4/ Récupérer la liste des bières pour lequelles les ventes ont agumentées entre 2015 et 2016
SELECT article_name, total_2015.total AS total2015, total_2016.total AS total2016
FROM article
    JOIN (
        SELECT id_article, SUM(quantity) AS total
        FROM sale
            JOIN ticket USING (id_ticket)
        WHERE YEAR(ticket_date) = 2015
        GROUP BY id_article) AS total_2015 USING (id_article)
    JOIN (SELECT id_article, SUM(quantity) AS total
        FROM sale
            JOIN ticket USING (id_ticket)
        WHERE YEAR(ticket_date) = 2016
        GROUP BY id_article) AS total_2016 USING (id_article)
WHERE total_2016.total > total_2015.total


-- 5/ Récupérer les bières pour lesquelles le volume de bières
-- vendus est d'au moins 200 litres pour toutes les années

SELECT id_article, article_name
FROM article a
    JOIN sale USING (id_article)
GROUP BY id_article
HAVING NOT EXISTS (
    SELECT SUM(quantity * volume) / 100 AS total_litres
    FROM article
        JOIN sale USING (id_article)
        JOIN ticket USING (id_ticket)
    WHERE id_article = a.id_article
    GROUP BY YEAR(ticket_date)
    HAVING total_litres < 200
) 
ORDER BY id_article;

-------------- C'était pas facile ----------------------

SELECT id_article, article_name
FROM article a
WHERE 200 < ALL (
    SELECT SUM(quantity * volume) / 100 AS total_litres
    FROM article
        JOIN sale USING (id_article)
        JOIN ticket USING (id_ticket)
    WHERE id_article = a.id_article
    GROUP BY YEAR(ticket_date)
) 
ORDER BY id_article;

--------------------------------------------------------

SELECT YEAR(ticket_date) AS year_, id_article, article_name, SUM(quantity * volume) / 100 AS total_litres
FROM article
    JOIN sale USING (id_article)
    JOIN ticket USING (id_ticket)
GROUP BY id_article, year_
HAVING total_litres >= 200
ORDER BY id_article, year_;

SELECT YEAR(ticket_date) AS year_, id_article, article_name, SUM(quantity * volume) / 100 AS total_litres
FROM article
    JOIN sale USING (id_article)
    JOIN ticket USING (id_ticket)
WHERE id_article = 14
GROUP BY year_;

-- HAVING total_litres > 200

-- 6/ Récupérer pour chaque pays la ou les marques de bière dont le degrès d'alcool moyen est le plus élevé en affichant le degré d'alcool moyen

SELECT id_country AS id_country1, country_name, brand_name, AVG(alcohol) AS average_alcohol
FROM country
    JOIN brand USING (id_country)
    JOIN article USING (id_brand)
GROUP BY id_brand
HAVING average_alcohol >= ALL (
    SELECT AVG(alcohol)
    FROM brand
        JOIN article USING (id_brand)
    WHERE id_country = id_country1
    GROUP BY id_brand
);


SELECT id_country AS id_country1, country_name, brand_name, AVG(alcohol) AS average_alcohol
FROM country
    JOIN brand USING (id_country)
    JOIN article USING (id_brand)
GROUP BY id_brand
HAVING average_alcohol = (
    SELECT MAX(avg) 
    FROM (
        SELECT AVG(alcohol) AS avg
        FROM brand
            JOIN article USING (id_brand)
        WHERE id_country = id_country1
        GROUP BY id_brand
    ) AS avg_alcohol_brand
);


SELECT id_country AS id_country1, country_name, brand_name, AVG(alcohol) AS average_alcohol
FROM country
    JOIN brand USING (id_country)
    JOIN article USING (id_brand)
GROUP BY id_brand
HAVING average_alcohol = (
    SELECT AVG(alcohol) AS avg
    FROM brand 
        JOIN article USING (id_brand)
    WHERE id_country = id_country1
    GROUP BY id_brand
    ORDER BY avg DESC
    LIMIT 1
);


-- 7/ Donner pour chaque type de bière, la bière la plus vendue et la bière la moins vendue en 2016

--create a view conatin the id_type, id_article and the sum  
CREATE VIEW type_article_quantity_2016 AS
SELECT  id_article, id_type ,sum(quantity) AS sum
FROM article
    JOIN sale USING (id_article)
    JOIN ticket USING (id_ticket)
WHERE YEAR(ticket_date) = 2016
GROUP BY id_article;


(
    SELECT type_name, article_name, 'best seller' AS seller
    FROM type_article_quantity_2016 s
        JOIN article USING (id_article)
        JOIN type ON s.id_type = type.id_type
    WHERE sum >= all (
        SELECT sum 
        FROM type_article_quantity_2016 
        WHERE id_type = s.id_type
    )
) 
UNION 
(
    SELECT type_name, article_name, 'worst seller' AS seller
    FROM type_article_quantity_2016 s
        JOIN article USING (id_article)
        JOIN type ON s.id_type = type.id_type
    WHERE sum <= all (
        SELECT sum 
        from type_article_quantity_2016 
        WHERE id_type = s.id_type
    )
) 
ORDER BY  type_name;


-- 8/ Donner pour toutes les couleurs de bières la plus vendue pour chacune des années 2015, 2016 et 2017 

SELECT id_color AS color_id, color_name, YEAR(ticket_date) AS years, article_name, SUM(quantity) AS sum
FROM article
    JOIN sale USING (id_article)
    JOIN ticket USING (id_ticket)
    JOIN color USING (id_color)
WHERE YEAR(ticket_date) IN (2015, 2016, 2017)
GROUP BY id_article, years
HAVING sum >= ALL (
    SELECT SUM(quantity) AS sum
    FROM article
        JOIN sale USING (id_article)
        JOIN ticket USING (id_ticket)
    WHERE YEAR(ticket_date) = years AND id_color = color_id
    GROUP BY id_article
)
ORDER BY color_id, years;


-- 9/ Lister les marques de bières dont le volume total vendu (en litres) en 2015 est supérieur à celui de Heineken.
CREATE VIEW brand_volume_years AS 
SELECT brand_name, YEAR(ticket_date) AS years,(SUM(volume*quantity)/100) AS volume_total
FROM article
    JOIN sale USING (id_article)
    JOIN brand USING (id_brand)
    JOIN ticket USING (id_ticket)
GROUP BY id_brand, years;


SELECT brand_name, (SUM(volume*quantity)/100) AS volume_total
FROM article
    JOIN sale USING (id_article)
    JOIN brand USING (id_brand)
    JOIN ticket USING (id_ticket)
WHERE YEAR(ticket_date) = 2015
GROUP BY id_brand
HAVING volume_total > (
   SELECT SUM(volume*quantity)/100
    FROM article
        JOIN sale USING (id_article)
        JOIN brand USING (id_brand)
        JOIN ticket USING (id_ticket)
    WHERE YEAR(ticket_date) = 2015 AND brand_name = "Heineken" 
    GROUP BY id_brand 
)




-- 10/ Lister les marques de bières dont le volume total vendu (en litres) est supérieur à celui de Heineken pour chaque année entre 2015 et 2017.
