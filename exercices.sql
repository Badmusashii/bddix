--1. Liste des potions : Numéro, libellé, formule et constituant principal. (5 lignes)
select * from potion;
--2. Liste des noms des trophées rapportant 3 points. (2 lignes)
select * from trophee where num_resserre > 2;
--3. Liste des villages (noms) contenant plus de 35 huttes. (4 lignes)
SELECT nom_village  FROM village where nb_huttes  > 35;
--4. Liste des trophées (numéros) pris en mai / juin 52. (4 lignes)
SELECT num_trophee  FROM trophee where date_prise between '2052-05-01' and '2052-06-30';
--5. Noms des habitants commençant par 'a' et contenant la lettre 'r'. (3 lignes)
SELECT nom  FROM habitant where nom like 'A%r%'
--6. Numéros des habitants ayant bu les potions numéros 1, 3 ou 4. (8 lignes)
select distinct num_hab  FROM absorber where num_potion = 1 or num_potion = 2 or num_potion = 4;
--7. Liste des trophées : numéro, date de prise, nom de la catégorie et nom du preneur. (10lignes)
SELECT 
    trophee.num_trophee AS Numero_Trophee, 
    trophee.date_prise AS Date_De_Prise, 
    categorie.nom_categ AS Nom_Categorie, 
    habitant.nom AS Nom_Preneur
FROM 
    trophee
INNER JOIN 
    categorie ON trophee.code_cat = categorie.code_cat
INNER JOIN 
    habitant ON trophee.num_preneur = habitant.num_hab;
--8. Nom des habitants qui habitent à Aquilona. (7 lignes)
SELECT habitant.nom FROM habitant 
INNER JOIN village ON habitant.num_village = village.num_village
WHERE nom_village = 'Aquilona'
--9. Nom des habitants ayant pris des trophées de catégorie Bouclier de Légat. (2 lignes)
SELECT habitant.nom 
FROM habitant
INNER JOIN trophee ON habitant.num_hab = trophee.num_preneur
INNER JOIN categorie ON trophee.code_cat = categorie.code_cat
WHERE categorie.nom_categ LIKE 'Bouclier de L%gat';
--10. Liste des potions (libellés) fabriquées par Panoramix : libellé, formule et constituantprincipal. (3 lignes)
SELECT lib_potion as nom_de_potion, formule, constituant_principal FROM potion
INNER JOIN fabriquer ON potion.num_potion = fabriquer.num_potion
INNER JOIN habitant ON fabriquer.num_hab = habitant.num_hab
WHERE habitant.num_hab = 'Panoramix'
--11. Liste des potions (libellés) absorbées par Homéopatix. (2 lignes)
SELECT distinct lib_potion FROM potion 
INNER JOIN absorber ON potion.num_potion = absorber.num_potion
INNER JOIN habitant ON absorber.num_hab = habitant.num_hab
WHERE habitant.nom LIKE 'Hom%opatix'
--12. Liste des habitants (noms) ayant absorbé une potion fabriquée par l'habitant numéro 3. (4 lignes)
SELECT distinct habitant.nom 
FROM habitant
INNER JOIN absorber ON habitant.num_hab = absorber.num_hab
WHERE absorber.num_potion IN (
    SELECT fabriquer.num_potion 
    FROM fabriquer 
    WHERE fabriquer.num_hab = 3
);
--13. Liste des habitants (noms) ayant absorbé une potion fabriquée par Amnésix. (7 lignes)
SELECT distinct habitant.nom 
FROM habitant
INNER JOIN absorber ON habitant.num_hab = absorber.num_hab
WHERE absorber.num_potion IN (
    SELECT fabriquer.num_potion 
    FROM fabriquer 
    INNER JOIN habitant ON fabriquer.num_hab = habitant.num_hab
    WHERE habitant.nom LIKE 'Amn%six'
);
--14. Nom des habitants dont la qualité n'est pas renseignée. (2 lignes)
SELECT habitant.nom FROM habitant
WHERE num_qualite IS NULL
--15. Nom des habitants ayant consommé la Potion magique n°1 (c'est le libellé de lapotion) en février 52. (3 lignes)
SELECT habitant.nom FROM habitant
INNER JOIN absorber ON habitant.num_hab = absorber.num_hab
WHERE absorber.num_potion = 1 AND absorber.date_a between '2052.02.01' AND '2052.02.28'
--16. Nom et âge des habitants par ordre alphabétique. (22 lignes)
SELECT nom, age
FROM habitant
order by nom
--17. Liste des resserres classées de la plus grande à la plus petite : nom de resserre et nom du village. (3 lignes)
SELECT nom_resserre , superficie, village.nom_village
FROM resserre 
INNER JOIN village ON resserre.num_village = village.num_village
ORDER BY superficie DESC
--***

--18. Nombre d'habitants du village numéro 5. (4)
SELECT count(*)
FROM habitant
WHERE num_village = 5
--19. Nombre de points gagnés par Goudurix. (5)
SELECT SUM(categorie.nb_points)
FROM categorie
INNER JOIN trophee ON categorie.code_cat = trophee.code_cat
INNER JOIN habitant ON trophee.num_preneur = habitant.num_hab
WHERE habitant.nom = 'Goudurix'
--20. Date de première prise de trophée. (03/04/52)
SELECT date_prise
FROM trophee
order by date_prise
LIMIT 1
--21. Nombre de louches de Potion magique n°2 (c'est le libellé de la potion) absorbées. (19)
SELECT SUM(quantite)
FROM absorber
WHERE num_potion = 2
--22. Superficie la plus grande. (895)
SELECT superficie
FROM resserre
ORDER BY superficie DESC
LIMIT 1
--***

--23. Nombre d'habitants par village (nom du village, nombre). (7 lignes)
SELECT village.nom_village, COUNT(habitant.num_hab) AS nombre_habitants
FROM village
INNER JOIN habitant ON village.num_village = habitant.num_village
GROUP BY village.nom_village;

--24. Nombre de trophées par habitant (6 lignes)
SELECT count(*)
FROM trophee
GROUP BY num_preneur
--25. Moyenne d'âge des habitants par province (nom de province, calcul). (3 lignes)
SELECT nom_province, TO_CHAR(AVG(age), 'FM99999990.00') as moyenne_age
FROM province
INNER JOIN village ON province.num_province = village.num_province
INNER JOIN habitant ON village.num_village = habitant.num_village
GROUP BY province.nom_province

-- Le TO_CHAR renvoie une String, ROUND((),2) renvoie un number


--26. Nombre de potions différentes absorbées par chaque habitant (nom et nombre). (9lignes)
SELECT habitant.nom, count(distinct absorber.num_potion) as nombre_de_potion_differentes
FROM habitant
INNER JOIN absorber ON habitant.num_hab = absorber.num_hab
GROUP BY habitant.nom
--27. Nom des habitants ayant bu plus de 2 louches de potion zen. (1 ligne)
SELECT habitant.nom
FROM habitant
INNER JOIN absorber ON habitant.num_hab = absorber.num_hab
INNER JOIN potion ON absorber.num_potion = potion.num_potion
WHERE absorber.quantite > 2 and potion.lib_potion = 'Potion Zen'
--***
--28. Noms des villages dans lesquels on trouve une resserre (3 lignes)
SELECT village.nom_village
FROM village
INNER JOIN resserre ON village.num_village = resserre.num_village
WHERE resserre.num_village is NOT NULL
--29. Nom du vilage contenant le plus grand nombre de huttes. (Gergovie)
SELECT village.nom_village
FROM village
ORDER BY village.nb_huttes DESC
LIMIT 1

--30. Noms des habitants ayant pris plus de trophées qu'Obélix (3 lignes).
SELECT habitant.nom
FROM habitant
JOIN trophee ON habitant.num_hab = trophee.num_preneur
GROUP BY habitant.nom
HAVING count(num_preneur) > (
    SELECT count(num_preneur)
    FROM trophee
    INNER JOIN habitant ON trophee.num_preneur = habitant.num_hab
    WHERE habitant.nom LIKE 'Ob%lix'
)

