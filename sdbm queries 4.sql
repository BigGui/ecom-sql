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


-- 4/ Récupérer la liste des bières pour lequelles les ventes ont agumentées entre 2015 et 2016



-- 5/ Récupérer les bières pour lesquelles le volume de bières
-- vendus est d'au moins 200 litres pour toutes les années



-- 6/ Récupérer pour chaque pays la ou les marques de bière dont le degrès d'alcool moyen est le plus élevé en affichant le degré d'alcool moyen



-- 7/ Donner pour chaque type de bière, la bière la plus vendue et la bière la moins vendue en 2016



-- 8/ Donner pour toutes les couleurs de bières la plus vendue pour chacune des années 2015, 2016 et 2017 



-- 9/ Lister les marques de bières dont le volume total vendu (en litres) en 2015 est supérieur à celui de Heineken.



-- 10/ Lister les marques de bières dont le volume total vendu (en litres) est supérieur à celui de Heineken pour chaque année entre 2015 et 2017.
