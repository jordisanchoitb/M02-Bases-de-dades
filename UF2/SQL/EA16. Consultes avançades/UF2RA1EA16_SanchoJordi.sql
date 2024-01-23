/* Exercici 1 BBDD residus
Mostra el codi de destí, la ciutat de destí, el NIF de la empresa productora, la ciutat de l’empresa productora i el
tractament que han fet servir les empreses productores que han traslladat la màxima quantitat (quantitat_trasllat)
fent servir un tractament del tipus "Segregació i lliurament".
El resultat mostra 1 fila*/

SELECT te.cod_desti, d.ciutat_desti, te.nif_empresa, ep.ciutat_empresa, t.tractament
FROM Trasllat_EmpresaTransport te
JOIN Desti d ON te.cod_desti = d.cod_desti
JOIN EmpresaProductora ep ON te.nif_empresa = ep.nif_empresa
JOIN Trasllat t ON te.nif_empresa = t.nif_empresa AND te.cod_residu = t.cod_residu AND te.data_enviament = t.data_enviament AND te.cod_desti = t.cod_desti
WHERE t.quantitat_trasllat = (SELECT MAX(quantitat_trasllat) FROM Trasllat WHERE tractament = 'Segregació i lliurament');

/*Exercici 2 BBDD residus
Quin tipus de tractament s'ha fet servir menys durant l'any 2017 (utilitzarem la data d'enviament per comptar el
tractament menys utilitzat). Utilitza només subconsultes.
El resultat mostra 1 fila*/

SELECT tractament, count(tractament) "Num tractaments"
FROM trasllat
WHERE TO_CHAR(data_enviament,'yyyy')='2017'
GROUP BY tractament
HAVING COUNT(tractament) = (SELECT MIN(c) FROM (SELECT COUNT(tractament) AS c
FROM trasllat WHERE data_enviament BETWEEN '01/01/17' AND '31/12/17' GROUP BY tractament) AS a);

/*Exercici 3 BBDD residus
Mostra quins són els dos envasos que s'han fet servir més vegades per traslladar els residus. Mostra els envasos i
el número de vegades que s’han fet servir. Utilitza només subconsultes.
El resultat mostra 2 files
llauna 87
bido 87*/

SELECT envas, COUNT(envas)
FROM trasllat
GROUP BY envas
HAVING COUNT(envas) = (SELECT MAX(c) FROM (SELECT COUNT(envas) AS c FROM trasllat
GROUP BY envas) AS a);

/*Exercici 4 BBDD residus
Obtenir el nom de totes les ciutats a les que van a parar els residus que inclouen el constituent "Solucions
bàsiques o bases en forma sòlid". Mostra els resultats ordenats per ciutat destí. Utilitza només subconsultes.
El resultat mostra 28 files*/

SELECT DISTINCT ciutat_desti "Ciutat de destí"
FROM Desti
WHERE cod_desti IN
(SELECT DISTINCT cod_desti
FROM Trasllat
WHERE nif_empresa IN
(SELECT DISTINCT nif_empresa
FROM Residu_constituent
WHERE cod_constituent IN (SELECT cod_constituent FROM
Constituent WHERE lower(nom_constituent) = 'solucions bàsiques o bases en forma sòlida')))
ORDER BY ciutat_desti;

/*Exercici 5 BBDD training
Mostrar l'identificador del client i el nom de l’empresa client dels clients on el límit de crèdit sigui més petit que
la suma de tots els imports de les comandes d'aquell client. Utilitza la subconsulta i no es pot agrupar.
El resultat mostra 3 files*/

SELECT num_clie, empresa
FROM clientes
WHERE limite_credito < (SELECT SUM(importe) FROM pedidos WHERE clie = clientes.num_clie);


/*Exercici 6 BBDD training
Mostrar tots els camps d'aquelles oficines que tots els seus venedors tinguin unes vendes superiors a la suma dels
imports de totes les comandes. Utilitza subconsultes.
El resultat mostra 3 files*/

SELECT * FROM oficinas
WHERE (SELECT SUM(importe) FROM pedidos) < ALL(SELECT ventas
FROM repventas
WHERE oficina_rep = oficina);

/*Exercici 7 BBDD training
Mostra el nom de l'empresa client, l'identificador i el nom del venedor assignat al client, i l’identificador i la
ciutat de l'oficina en la que treballa el venedor assignat al client en cas que aquest tingui una oficina assignada.
El resultat mostra 21 files*/

SELECT c.empresa, c.num_clie, r.nombre, r.num_empl, o.ciudad
FROM clientes c
LEFT JOIN repventas r ON c.rep_clie = r.num_empl
LEFT JOIN oficinas o ON r.oficina_rep = o.oficina;


/*Exercici 8 BBDD training
Revisa aquest exemple d’utilització de l’expressió condicional CASE, similar a IF/ELSE en altres llenguatges de
programació, en una consulta a la base de dades HR:
SELECT employee_id,
CASE
WHEN employee_id =100 THEN (SELECT last_name FROM employees WHERE employee_id =100)
WHEN employee_id =120 THEN (SELECT last_name FROM employees WHERE employee_id =120)
ELSE 'Other'
END
FROM employees;
Utilitza el CASE per mostrar el següent:
Si el client amb el nom 'Zetacorp' ha fet més de 10 comandes mostra el missatge 'Gran Client'.
Si ha fet entre 5 i 10 comandes mostra el missatge 'Client Mitjà'.
Si ha fet menys de 5 comades mostra el missatge 'Petit Client'.
S’ha de mostrar el número de comades que ha fet aquest client i el missatge corresponent.*/

SELECT COUNT(*),
CASE
WHEN COUNT(*) > 10 THEN 'Gran Client'
WHEN COUNT(*) >= 5 AND COUNT(*) <= 10 THEN 'Client mitja'
ELSE 'Petit Client'
END
FROM pedidos
WHERE clie = (SELECT num_clie FROM clientes
WHERE LOWER(empresa) LIKE 'zetacorp');

