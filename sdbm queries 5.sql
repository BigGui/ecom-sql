
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



-- 6/ Automatiser le fait de pouvoir augmenter ou diminuer les prix de toutes les bières d'une même marque d'un certain pourcentage.



-- 7/ Donnez pour chaque type de bière le pourcentage de répartition par continent (en nb d'article)

