
-- 1/ Donner la liste des fabriquants dont le type de bière les plus vendues en 2016 sont les abbayes.

create VIEW type_name_by_maker_2016 AS

SELECT maker_name, SUM(quantity) AS total, type_name
FROM maker
    JOIN brand USING (id_maker)
    JOIN article USING (id_brand)
    JOIN sale USING (id_article)
    JOIN ticket USING (id_ticket)
    JOIN type USING (id_type)
WHERE YEAR(ticket_date) = 2016
GROUP BY id_maker, id_type;

SELECT maker_name
FROM type_name_by_maker_2016 t
WHERE type_name = "abbaye" AND total >= ALL (
    SELECT total
    FROM type_name_by_maker_2016
    WHERE maker_name = t.maker_name
);


-- 2/ Automatiser le calcul de la quantité total de bière vendu en nombre de bière pour un jour donné.


------------ CREATE PROCEDURE ------------------------
CREATE PROCEDURE get_beer_quantity_per_day (IN d DATE)
    SELECT DATE_FORMAT(ticket_date, "%Y-%m-%d") AS date_, SUM(quantity) AS total_sold
    FROM ticket
        JOIN sale USING (id_ticket)
        WHERE ticket_date = d
        GROUP BY date_;


---------------- CALL PROCEDURE ------------------------
CALL get_beer_quantity_per_day ("2017-12-31");

-- 3/ Donner pour chaque année la ou les marques ayant vendues le plus gros volume de bière (en litres)

-- SELECT id_brand, brand_name, YEAR(ticket_date) AS years, SUM(quantity * volume)  / 100 AS total_vol
-- FROM article
--     JOIN sale USING (id_article)
--     JOIN ticket USING (id_ticket)
--     JOIN brand USING (id_brand)
-- GROUP BY id_brand, years
-- ORDER BY id_brand;

SELECT brand_name, years
FROM brand_volume_years b
WHERE volume_total >= ALL (
    SELECT volume_total
    FROM brand_volume_years
    WHERE years = b.years
)
ORDER BY years;


-- 4/ Automatiser la mise à jour de la date d'un ticket à la date du jour à chaque ajout d'une bière à celui-ci.

CREATE TRIGGER after_insert_sale AFTER INSERT ON sale
FOR EACH ROW UPDATE ticket SET ticket_date = CURRENT_DATE()
WHERE id_ticket = NEW.id_ticket;

-- 5/ Donnez la liste des marques de bière dont au moins une bière a été vendu à plus de 500 unitées en 2016

CREATE VIEW sales_by_article_per_years AS
SELECT YEAR(ticket_date) AS years, id_brand, brand_name, id_article, article_name, SUM(quantity) AS total_sold
FROM brand
    JOIN article USING (id_brand)
    JOIN sale USING (id_article)
    JOIN ticket USING (id_ticket)
GROUP BY id_article, id_brand, years;

SELECT brand_name
FROM sales_by_article_per_years
WHERE years = 2016 AND total_sold > 500
GROUP BY brand_name;


SELECT brand_name
FROM brand
	JOIN article USING (id_brand)
WHERE article_name IN (
    SELECT article_name
    FROM article
        JOIN sale USING (id_article)
        JOIN ticket USING (id_ticket)
    WHERE YEAR(ticket_date) = 2016
    GROUP BY id_article
    HAVING SUM(quantity) > 500
)
GROUP BY id_brand
ORDER BY brand_name ASC; 

SELECT
    brand_name
FROM
    brand
    JOIN article USING(id_brand)
    JOIN sale USING(id_article)
    JOIN ticket USING (id_ticket)
WHERE
    YEAR(ticket_date) = 2016
GROUP BY
    id_brand,
    id_article
HAVING
    SUM(quantity) > 500;


SELECT brand_name
FROM brand b
WHERE 500 < ANY (
    SELECT SUM(quantity)
    FROM sale
        JOIN ticket USING (id_ticket)
        JOIN article a USING(id_article)
    WHERE a.id_brand = b.id_brand
        AND YEAR(ticket_date) = 2016
    GROUP BY id_article
);


-- 6/ Automatiser le fait de pouvoir augmenter ou diminuer les prix de toutes les bières d'une même marque d'un certain pourcentage.

CREATE PROCEDURE modify_price_by_brand(IN percentage INT, IN this_id_brand INT)
UPDATE article 
SET purchase_price = purchase_price * (1 + percentage / 100)
WHERE id_brand = this_id_brand;



SELECT article_name, purchase_price
FROM article
WHERE id_brand = 1;

CALL modify_price_by_brand(10, 1);

SELECT article_name, purchase_price
FROM article
WHERE id_brand = 1;

-- 7/ Donnez pour chaque type de bière le pourcentage de répartition par continent (en nb d'article)

CREATE VIEW number_beer_by_type_by_continent AS
SELECT COUNT(id_article) AS count_id, id_type, type_name, id_continent, continent_name
FROM article
    JOIN type USING (id_type)
    JOIN brand USING (id_brand)
    JOIN country USING (id_country)
    JOIN continent USING (id_continent)
GROUP BY id_type, id_continent
ORDER BY id_type, id_continent;

SELECT type_name,
    ROUND(count_id / (
        SELECT SUM(count_id)
        FROM number_beer_by_type_by_continent
        WHERE id_type = b.id_type
        GROUP BY id_type
    ) * 100, 2) AS percentage_,
    continent_name
FROM number_beer_by_type_by_continent b
ORDER BY id_type;


SELECT type_name, continent_name,
    ROUND(COUNT(id_article) / (
        SELECT COUNT(id_article)
        FROM article
            JOIN type USING (id_type)
            JOIN brand USING (id_brand)
            JOIN country USING (id_country)
            JOIN continent USING (id_continent)
        WHERE id_type = t.id_type
    ) * 100, 2) AS nb_beers
FROM article
    JOIN type t USING (id_type)
    JOIN brand USING (id_brand)
    JOIN country USING (id_country)
    JOIN continent c USING (id_continent)
GROUP BY id_type, id_continent
ORDER BY type_name, continent_name;