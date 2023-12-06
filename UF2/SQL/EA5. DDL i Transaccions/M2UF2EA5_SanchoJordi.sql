/* 
Crear la base de dades amb el usuari agenda

CREATE DATABASE agenda;
CREATE USER agenda WITH SUPERUSER CREATEROLE ENCRYPTED PASSWORD 'agenda';
ALTER DATABASE agenda OWNER TO agenda;
GRANT ALL PRIVILEGES ON DATABASE agenda TO agenda;
*/

/* EXERCICI 1 */

/* a) Crea la base de dades anomenada agenda amb la taula FITXA. */
CREATE TABLE fitxa (
    DNI NUMERIC(8),
    NOM VARCHAR(30) NOT NULL,
    COGNOMS VARCHAR(70) NOT NULL,
    ADREÇA VARCHAR(60),
    TELEFON VARCHAR(11),
    PROVINCIA VARCHAR(30),
    DATA_NAIX DATE DEFAULT CURRENT_DATE
);


/* b) Fer un ROLLBACK . Comprovar si existeix la taula. En cas afirmatiu, perquè existeix i no
s’ha eliminat?. */
ROLLBACK; 
/* Comprovo si se fet el ROLLBACK amb \d existeix ja que en ningun moment em 
tret el commit automatic i no em posat begin ni res per fer el control */



/* c) Afegir un nou camp a la taula FITXA, anomenat CP que serà el codi postal. Serà
de tipus varchar(5). */
ALTER TABLE fitxa 
ADD COLUMN CP VARCHAR(5);



/* d) Comprovar que s’ha creat correctament el camp a la taula. */
/* Comprovo si sa creat el camp amb la seguent comanda:
\d fitxa */




/* e) Fer un rollback . Comprovar si encara està a la taula el camp creat. En cas afirmatiu,
perquè existeix i no s’ha eliminat?. */
ROLLBACK;
/*Comprovo si se fet el ROLLBACK amb \d fitxa el camp segueix exisistin ja que 
en ningun moment em tret el commit automatic i 
no em posat begin ni res per fer el control*/


/* EXERCICI 2 */

/* a) Elimina la taula FITXA. */
DROP TABLE fitxa;


/* b) Comprovar que la taula està eliminada. */
/* comprovo si esta eliminada amb \d*/



/* c) Fer un rollback . Comprovar si existeix la taula. En cas negatiu, perquè existeix i no s’ha
eliminat?. */
ROLLBACK;
/*Comprovo si se fet el ROLLBACK amb \d pero la taula segueix eliminada ja que 
en ningun moment em tret el commit automatic i 
no em posat begin ni res per fer el control*/

/* d) Tornar a executar les sentències de l’exercici 1 per crear la taula FITXA una altra vegada. */
CREATE TABLE fitxa (
    DNI NUMERIC(8),
    NOM VARCHAR(30) NOT NULL,
    COGNOMS VARCHAR(70) NOT NULL,
    ADREÇA VARCHAR(60),
    TELEFON VARCHAR(11),
    PROVINCIA VARCHAR(30),
    DATA_NAIX DATE DEFAULT CURRENT_DATE
);

/* EXERCICI 3 */

/* a) Afegir un nou camp a la taula Fitxa, anomenat Equip de tipus INTEGER. */
ALTER TABLE fitxa 
ADD COLUMN EQUIP INTEGER;


/* b) Inserir els següents registres a la taula, i una vegada afegits comprovar que existeixen. */
INSERT INTO fitxa VALUES (3421232, 'LUIS MIGUEL', 'ACEDO GÓMEZ', 'GUZMÁN EL BUENO, 90', '969231256', NULL, '05/05/1970', 1);
INSERT INTO fitxa VALUES (4864868, 'BEATRIZ', 'SANCHO MANRIQUE', 'ZURRIAGA, 25', '932321212', 'BCN', '06/07/1978', 2);



/* EXERCICI 4 */

/* Entro dins del sql i desactivo el autocommit amb la seguent comanda (\set AUTOCOMMIT off) */
BEGIN;
INSERT INTO fitxa VALUES (7868544, 'JONÁS', 'ALMENDROS RODRÍGUEZ', 'FEDERICO PUERTAS, 3', '915478947', 'MADRID', '01/01/1987', 3);
INSERT INTO fitxa VALUES (8324216, 'PEDRO', 'MARTÍN HIGUERO', 'VIRGEN DEL CERRO, 154', '961522344', 'SORIA', '29/04/1978', 5);
ROLLBACK;
/* Comprovo si estan els inserts despres de haber fet ROLLBACK amb la seguent comanda */
SELECT * FROM fitxa;



/* EXERCICI 5 */

/* a) introduir el registre */
BEGIN;
INSERT INTO fitxa VALUES (14948992, 'SANDRA', 'MARTÍN GONZÁLEZ', 'PABLO NERUDA, 15', '916581515', 'MADRID', '05/05/1970', 6);

/* b) desar el canvis permanentment.*/
COMMIT;

/* c) introduir el registre*/
BEGIN;
INSERT INTO fitxa VALUES (15756214, 'MIGUEL', 'CAMARGO ROMÁN', 'ARMADORES, 1', '949488588', NULL, '12/12/1985', 7);

/* d) Posar una marca anomenada intA.*/
SAVEPOINT intA;

/* e) Desar els canvis permanentment*/
COMMIT;

/* f) Introduir els registres*/
BEGIN;
INSERT INTO fitxa VALUES (21158230, 'SERGIO', 'ALFARO IBIRICU', 'AVENIDA DEL EJERCITO, 76', '934895855', 'BCN', '11/11/1987', 8);
INSERT INTO fitxa VALUES (34225234, 'ALEJANDRO', 'ALCOCER JARABO', 'LEONOR DE CORTINAS, 7', '935321211', 'MADRID', '05/05/1970', 9);

/* g) Posar una marca anomenada intB. Comprova que estan els registres que hem donat d’alta
de moment.*/
SAVEPOINT intB;
SELECT * FROM fitxa;

/* h) Introduir el registre*/
INSERT INTO fitxa VALUES (38624852, 'ALVARO', 'RAMÍREZ AUDIGE', 'FUENCARRAL, 33', '912451168', 'MADRID', '10/09/1976', 10);

/* i) Posar una marca anomenada intC. Comprova que estan els registres que hem donat d’alta
de moment.*/
SAVEPOINT intC;
SELECT * FROM fitxa;

/* j) Introduir els registres.*/
INSERT INTO fitxa VALUES (45824852, 'ROCÍO', 'PÉREZ DEL OLMO', 'CERVANTES, 22', '912332138', 'MADRID', '06/12/1987', 11);
INSERT INTO fitxa VALUES (48488588, 'JESÚS', 'BOBADILLA SANCHO', 'GAZTAMBIQUE, 32', '913141111', 'MADRID', '05/05/1970', 12);

/* k) Posar una marca anomenada intD. Comprova que estan els registres que hem donat d’alta
de moment.*/
SAVEPOINT intD;
SELECT * FROM fitxa;

/* l) Eliminar el registre amb DNI = 45824852.*/
DELETE FROM fitxa WHERE DNI=45824852;

/* m) Posar una marca anomenada intE. Comprova que estan els registres que hem donat d’alta
de moment i que s’ha eliminat un.*/
SAVEPOINT intE;
SELECT * FROM fitxa;

/* n) Modificar l’equip de l’amic que té per DNI = 48488588. L’equip ha de ser a partir d’ara
l’11 i posar una marca anomenada intF.*/
UPDATE fitxa SET EQUIP=11 WHERE DNI=48488588;
SELECT * FROM fitxa;
SAVEPOINT intF;

/* o) Desfer les operacions fins a la marca intE. Què ha passat?. Comprova els registres.*/
ROLLBACK TO intE;
SELECT * FROM fitxa;
/* tots els camvis que he fet despres de posar el savepoint s'han desfet en 
aquest cas que el update del equip 11 a la persona amb el dni 48488588*/

/* p) Desfer les operacions fins a la marca intD. Què ha passat?. Comprova els registres.*/
ROLLBACK TO intD;
SELECT * FROM fitxa;
/* Ha pasat exactamen igual que en el anterior pero en comptes de borrar el update fet que aixo ja ho a tret abans 
en aquest cas a tret el usuari que habia eliminat*/

/* q) Modificar l’equip que té per DNI =38624852. L’equip ha de ser a partir d’ara l’11.*/
UPDATE fitxa SET EQUIP=11 WHERE DNI=38624852;

/* r) Comprovar si tots els canvis s’han realitzat correctament a la taula i desa els canvis
permanentment.*/
SELECT * FROM fitxa;
COMMIT;

/* s) Inserir el registre:*/
BEGIN;
INSERT INTO fitxa VALUES (98987765, 'PEDRO', 'RUIZ RUIZ', 'SOL, 43', '916564332', 'MADRID', '10/09/1976', 12);

/* t) Comprovar si tots els canvis s’han realitzat correctament a la taula i tancar la sessió de
treball i tornar a entrar. Comprovar si està el registre que s’ha donat d’alta a l’apartat anterior.*/
SELECT * FROM fitxa;
/* Per tancar sessio utilitzo el \q i per tornar a inicia sessio faig un psql -U agenda */

/* u). Està el registre? En cas negatiu,*/
/* a. Perque no es troba?: ja que no vem fer el commit abans de tancar sesio i no es van aplicar els cambis */
/* b. Torna a inserir-lo i desa el registre permanentment. */

/* No esta el registre */
BEGIN;
INSERT INTO fitxa VALUES (98987765, 'PEDRO', 'RUIZ RUIZ', 'SOL, 43', '916564332', 'MADRID', '10/09/1976', 12);
COMMIT;
