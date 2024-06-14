
-- 1/ Donnez la liste des bières de même couleur et de même type que la bière ayant le code 142.
--     (affichez le code et le nom de la bière, le nom de la couleur et le nom du type)

SELECT id_article, article_name, color_name, type_name
FROM type
    JOIN article USING (id_type)
    JOIN color USING (id_color)
WHERE (id_color, id_type) = (
    SELECT id_color, id_type
    FROM article
    WHERE id_article = 142
);

-- 2/ Lister les quantités vendues de chaque article pour les années 2014, 2015,2016 et 2017.

SELECT id_article, YEAR(ticket_date) AS year_, SUM(quantity) AS sold_quantity
FROM sale
    JOIN ticket USING (id_ticket)
WHERE YEAR(ticket_date) IN (2014, 2015, 2016, 2017)
GROUP BY id_article, year_
ORDER BY id_article, year_;

SELECT SUM(quantity) AS sold_quantity
FROM sale
    JOIN ticket USING (id_ticket)
WHERE YEAR(ticket_date) = 2014 AND id_article = 1;

SELECT id_article, article_name,
    (
        SELECT SUM(quantity) AS sold_quantity
        FROM sale
            JOIN ticket USING (id_ticket)
        WHERE YEAR(ticket_date) = 2014
            AND id_article = a.id_article
    ) AS sold_2014,
    (
        SELECT SUM(quantity) AS sold_quantity
        FROM sale
            JOIN ticket USING (id_ticket)
        WHERE YEAR(ticket_date) = 2015
            AND id_article = a.id_article
    ) AS sold_2015,
    (
        SELECT SUM(quantity) AS sold_quantity
        FROM sale
            JOIN ticket USING (id_ticket)
        WHERE YEAR(ticket_date) = 2016
            AND id_article = a.id_article
    ) AS sold_2016,
    (
        SELECT SUM(quantity) AS sold_quantity
        FROM sale
            JOIN ticket USING (id_ticket)
        WHERE YEAR(ticket_date) = 2017
            AND id_article = a.id_article
    ) AS sold_2017
FROM article a
ORDER BY id_article;

-- 3/ Lister les tickets sur lesquels apparaissent un des articles apparaissant aussi sur le ticket 20175123.

SELECT id_ticket 
FROM sale 
WHERE id_article IN (
    SELECT id_article
    FROM sale 
    WHERE id_ticket = 20175123
 );

SELECT id_ticket 
FROM sale s 
WHERE EXISTS (
    SELECT id_article
    FROM sale 
    WHERE id_ticket = 20175123
        AND id_article = s.id_article
 );


-- 4/ Donner pour chaque Type de bière, la bière la plus vendue en 2017. (Classer par quantité décroissante)

SELECT type_name, article_name, SUM(quantity) AS total
FROM article
    JOIN type USING (id_type)
    JOIN sale USING (id_article)
    JOIN ticket USING (id_ticket)
WHERE id_type = 1 AND YEAR(ticket_date) = 2017
GROUP BY id_article
ORDER BY SUM(quantity) DESC
LIMIT 1;

SELECT id_type AS type_id ,type_name, article_name, SUM(quantity) AS total
FROM article
    JOIN type t USING (id_type)
    JOIN sale USING (id_article)
    JOIN ticket USING (id_ticket)
WHERE YEAR(ticket_date) = 2017
GROUP BY id_article
HAVING total = (
    SELECT SUM(quantity) AS total
    FROM article
            JOIN type USING (id_type)
            JOIN sale USING (id_article)
            JOIN ticket USING (id_ticket)
    WHERE id_type = type_id AND YEAR(ticket_date) = 2017
    GROUP BY id_article
    ORDER BY total DESC
    LIMIT 1)
ORDER BY total DESC;


SELECT id_type AS type_id ,type_name, article_name, SUM(quantity) AS total
FROM article
    JOIN type t USING (id_type)
    JOIN sale USING (id_article)
    JOIN ticket USING (id_ticket)
WHERE YEAR(ticket_date) = 2017
GROUP BY id_article
HAVING total >= ALL (
    SELECT SUM(quantity) AS total
    FROM article
            JOIN type USING (id_type)
            JOIN sale USING (id_article)
            JOIN ticket USING (id_ticket)
    WHERE id_type = type_id AND YEAR(ticket_date) = 2017
    GROUP BY id_article
)
ORDER BY total DESC;


SELECT MAX(total)
FROM (
    SELECT SUM(quantity) AS total
    FROM article
            JOIN type USING (id_type)
            JOIN sale USING (id_article)
            JOIN ticket USING (id_ticket)
    WHERE id_type = 1 AND YEAR(ticket_date) = 2017
    GROUP BY id_article
) AS type_2017;


-- 5/ Donner la liste des bières qui n'ont pas été vendues en 2014 ni en 2015. (Id, nom et volume)

SELECT id_article, article_name, volume
FROM article
WHERE id_article NOT IN (
    SELECT id_article
    FROM sale
        JOIN ticket USING (id_ticket)
    WHERE YEAR(ticket_date) IN (2014, 2015)
);

-- 6/ Donner la liste des bières qui n'ont pas été vendues en 2014 mais ont été vendues en 2015. (Id, nom et volume)

SELECT id_article, article_name, volume
FROM article
WHERE id_article NOT IN (
    SELECT id_article
    FROM sale
        JOIN ticket USING (id_ticket)
    WHERE YEAR(ticket_date) = 2014
)AND id_article IN (
    SELECT id_article
    FROM sale
        JOIN ticket USING (id_ticket)
    WHERE YEAR(ticket_date) = 2015
)
-- another :
SELECT id_article, article_name, volume
FROM sale
        JOIN ticket USING (id_ticket)
        JOIN article USING (id_article)
WHERE YEAR(ticket_date) = 2015 
GROUP BY id_article
HAVING id_article NOT IN (
    SELECT id_article
    FROM sale
        JOIN ticket USING (id_ticket)
    WHERE YEAR(ticket_date) = 2014
    GROUP BY id_article
)
