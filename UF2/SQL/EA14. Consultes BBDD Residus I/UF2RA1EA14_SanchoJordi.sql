/* 1. Mostra el nom de les empreses, les seves ciutats i les seves activitats, d'aquelles empreses
que generen residus amb el constituent amb codi 9912. Mostra el resultats ordenats pel nom
de l'empresa. (Utilitza la subconsulta).
El resultat mostra 15 files*/
SELECT nom_empresa, ciutat_empresa, activitat
FROM EmpresaProductora
WHERE nif_empresa IN (
    SELECT nif_empresa
    FROM Residu_constituent
    WHERE cod_constituent = 9912
)
ORDER BY nom_empresa;



/*2. Mostra el nom de l’empresa i la quantitat de residus de l’empresa productora que genera
més residus tóxics. (Utilitza la cláusula JOIN).
El resultat mostra 1 fila.*/
SELECT e.nom_empresa, SUM(r.toxicitat) as total_toxicitat
FROM EmpresaProductora e
JOIN Residu r ON e.nif_empresa = r.nif_empresa
GROUP BY e.nom_empresa
ORDER BY total_toxicitat DESC
LIMIT 1;



/*3. Mostra per cada tipus de tractament, la quantitat màxima de residus traslladats i la quantitat
mínima. Has de mostrar la informació en tres columnes anomenades com "max_quantitat",
"min_quantitat" i "tractament". Mostra només els tractaments que la quantitat mínima sigui
més gran que 1, i ordena els resultats per tractament.
El resultat mostra 2 files*/
SELECT tractament, MAX(quantitat_trasllat) as max_quantitat, MIN(quantitat_trasllat) as min_quantitat
FROM Trasllat
GROUP BY tractament
HAVING MIN(quantitat_trasllat) > 1
ORDER BY tractament;



/*4. Mostra els nom del destí com a "Destí", els nom de les ciutats de destí com a "Ciutat de
destí" de tots els trasllats que ha realitzat l'empresa transportista 'A-22300325' d'una distància
superior als 4297 kms. (Utilitza una subconsulta).
El resultat mostra 2 files*/
SELECT d.nom_desti as Destí, d.ciutat_desti as Ciutat_de_desti
FROM Desti d
WHERE cod_desti IN (
    SELECT cod_desti
    FROM Trasllat_EmpresaTransport
    WHERE nif_emptransport = 'A-22300325' AND kms > 4297
);



/*5. Mostra els nom de l'empresa i el total de kilòmetres recorreguts per cada empresa de
transport de residus entre l’1 d’octubre del 2016 i el 30 de novembre del 2016. Mostra només
les empreses que han recorregut més de 3400 Km i ordena els resultats per total de
kilòmetres de forma descendent.
El resultat mostra 11 files*/
SELECT e.nom_emptransport, SUM(t.kms) as total_kms
FROM EmpresaTransportista e
JOIN Trasllat_EmpresaTransport t ON e.nif_emptransport = t.nif_emptransport
WHERE t.data_enviament BETWEEN '2016-10-01' AND '2016-11-30'
GROUP BY e.nom_emptransport
HAVING SUM(t.kms) > 3400
ORDER BY total_kms DESC;


