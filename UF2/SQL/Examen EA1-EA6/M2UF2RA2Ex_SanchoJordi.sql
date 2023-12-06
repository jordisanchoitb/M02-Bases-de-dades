/* 
Crear la base de dades amb el usuari biblio

CREATE DATABASE biblio;
CREATE USER biblio WITH SUPERUSER CREATEROLE ENCRYPTED PASSWORD 'biblio';
ALTER DATABASE biblio OWNER TO biblio;
GRANT ALL PRIVILEGES ON DATABASE biblio TO biblio;
*/

/* Exercici 1. (1,5 punts)
Escriu les sentències necessàries per crear les taules SOCI, PRESTEC i LLIBRE a la base de
dades biblio. tenint en compte les restriccions indicades. */

CREATE TABLE soci (
    idsoci SERIAL NOT NULL,
    nom VARCHAR(30),
    cognoms VARCHAR(50),
    dni VARCHAR(9) NOT NULL UNIQUE,
    telefon NUMERIC(9) NOT NULL UNIQUE,
    email VARCHAR(35) NOT NULL UNIQUE,

        CONSTRAINT PK_Soci_ID PRIMARY KEY (idsoci)
);

CREATE TABLE llibre (
    idllibre NUMERIC(15) NOT NULL,
    isbn VARCHAR(25) NOT NULL UNIQUE,
    titul VARCHAR(70),
    autor VARCHAR(60),

        CONSTRAINT PK_Llibre_ID PRIMARY KEY (idllibre)
);

CREATE TABLE prestec (
    idprestec NUMERIC(35) NOT NULL,
    idllibre NUMERIC(15),
    dataPres DATE,
    dataRet DATE,
    idsoci INTEGER,
    estat CHAR(1),
    penalitzacio NUMERIC(10) NOT NULL DEFAULT 1,
        
        CONSTRAINT PK_Prestec_ID PRIMARY KEY (idprestec),
        CONSTRAINT FK_Llibre_ID FOREIGN KEY (idllibre) REFERENCES llibre(idllibre),
        CONSTRAINT FK_Soci_ID FOREIGN KEY (idsoci) REFERENCES soci(idsoci),
        CONSTRAINT CHK_Penalitzacio CHECK (penalitzacio > 0),
        CONSTRAINT CHK_Estat CHECK (estat IN ('R', 'P'))

);


/* Exercici 2. (0,25 punts)
Elimina la columna email de la taula soci i comprova l’estructura de la taula soci. */

ALTER TABLE soci DROP COLUMN email;

/* /d soci per comprovar l'estructura de soci*/


/* Exercici 3. (0,25 punts)
Torna a afegir la columma email a la taula soci amb el tipus de dades VARCHAR(40) i
comprova l’estructura de la taula soci. */

ALTER TABLE soci ADD COLUMN email VARCHAR(40);

/* /d soci per comprovar l'estructura de soci*/


/* Exercici 4. (0,25 punts)
Canvia el nom de la restricció que obliga que el camp penalitzacio ha de ser més gran que 0. Ara
es diu penalty_ck. Comprova si s’ha realitzat el canvi de nom. */

ALTER TABLE prestec RENAME CONSTRAINT CHK_Penalitzacio TO penalty_ck;

/* Per compravar el canvi de nom ho fem amb \d prestec */

/* Exercici 5. (0,25 punts)
Canvia el tipus de dades del camp idsoci de la taula prestec. El nou tipus de dades d’aquest camp
ha de ser NUMERIC(15). Si no es pot fer el canvi explica perquè. */

ALTER TABLE prestec ALTER COLUMN idsoci SET DATA TYPE NUMERIC(15);

/* [2023-10-31 09:34:01] [42804] ERROR: la restricción de llave foránea «fk_soci_id» no puede ser implementada
[2023-10-31 09:34:01] Detail: Las columnas llave «idsoci» y «idsoci» son de tipos incompatibles: numeric y integer*/

/* El canvi no es pot fer ja que esta referenciada a una altre taula i son inconpatibles i no es pot fer el camvi*/


/* Exercici 6. (0,25 punts)
Afegeix una nova restricció a la taula prestec per controlar que la data de retorn ha de ser
superior a la data del préstec. */

ALTER TABLE prestec ADD CONSTRAINT CHK_DATERETORN CHECK (dataRet > dataPres);

/* Exercici 7. (0,5 punts)
Insereix 5 socis a la taula soci amb dades inventades. Tots els camps han de tenir un valor, i
comprova que s’han insertat correctament. */

INSERT INTO soci VALUES (1,'jordi','sancho garcia','76584534O',814515435,'sanhojordi@gmail.com');
INSERT INTO soci VALUES (2,'pera','ramirez lacruz','68484534D',325412354,'ramirezpera@gmail.com');
INSERT INTO soci VALUES (3,'lucas','santiago deluque','76593394H',824354748,'santiagolucas@gmail.com');
INSERT INTO soci VALUES (4,'adria','sanchez perez','42384534R',314583543,'sanchezadria@gmail.com');
INSERT INTO soci VALUES (5,'adrian','villodres fernandez','76565434A',716543241,'villodresadria@gmail.com');

SELECT * FROM soci

/* Exercici 8. (0,75 punts)
Introdueix les següents dades a la taula llibre. Si a l’introduir les dades et dona errors, explica
el motiu de l’error que et dona i no insereixis el registre. Comprova quins són els registres
que s’han inserit. */

INSERT INTO llibre VALUES (2121213,'0-7645-2641-22','Preludi de la fundació','Isaac Asimov');
INSERT INTO llibre VALUES (2124215,'0-7645-2481-1','Estranger','Albert Camus');
INSERT INTO llibre VALUES (2123217,'0-7645-2633-3','Jo Claudi','Robert Graves');
INSERT INTO llibre VALUES (2121213,'0-7645-2641-3','Ulises','James Joyce');
INSERT INTO llibre VALUES (2126219,'0-7645-34641-11','Els miserables','Victor Hugo');
INSERT INTO llibre VALUES (21292110,'0-8445-2641-45','Rayuela','Julio Cortázar');
INSERT INTO llibre VALUES (21212124,'0-7645-2633-3','El vell i el mar','Ernest Hemingway');
INSERT INTO llibre VALUES (212123234,NULL,'La taronja mecànica','Anthony Burgess');

/* el quart insert dona aquest error degut a que la clau primaria es repateix */
/* [23505] ERROR: llave duplicada viola restricción de unicidad «pk_llibre_id» Detail: Ya existe la llave (idllibre)=(2121213). */


/* el sete insert dona error ja que es repateix el ISBN en un llibre enterior */
/*[23505] ERROR: llave duplicada viola restricción de unicidad «llibre_isbn_key» Detail: Ya existe la llave (isbn)=(0-7645-2633-3). */

/* el insert numero 8 dona error ja que el ISBN esta buit */
/* [23502] ERROR: el valor null para la columna «isbn» viola la restricción not null Detail: La fila que falla contiene (212123234, null, La taronja mecànica, Anthony Burgess). */

/* Per comprobar els registres que son inserit posem */
SELECT * FROM llibre;

/* Exercici 9. (0,25 punts)
Crea una seqüència perquè el camp idprestec de la taula prestec es pugui autoincrementar.
Que comenci per 10, que incrementi 5 i el valor màxim sigui 9000000. La seqüència s’ha
d’anomenar idprestec_seq. */

CREATE SEQUENCE idprestec_seq
INCREMENT 5
START WITH 10
MAXVALUE 9000000;

/* Exercici 10. (0,75 punts)
Intenta inserir els següents registres a la taula prestec. Utilitza la seqüencia creada en
l’exercici anterior. Si a l’introduir les dades et dona errors, explica l’error que et dona i no
insereixis el registre. La informació que ha d’intentar inserir és la següent: */

INSERT INTO prestec VALUES (NEXTVAL('idprestec_seq'),2121213,'2016-04-04','2016-11-06',4,'R');
INSERT INTO prestec VALUES (NEXTVAL('idprestec_seq'),2123217,'2017-01-29','2017-05-28',3,'R',2);
INSERT INTO prestec VALUES (NEXTVAL('idprestec_seq'),21331216,'2021-08-19','2021-12-08',1,'R',3);
INSERT INTO prestec VALUES (NEXTVAL('idprestec_seq'),21292110,'2019-09-25','2019-12-24',2,'P');
INSERT INTO prestec VALUES (NEXTVAL('idprestec_seq'),2123217,'2017-03-14','2017-03-11',2,'R',2);
INSERT INTO prestec VALUES (NEXTVAL('idprestec_seq'),2124215,'2019-08-14','2020-01-05',1,'S');
INSERT INTO prestec VALUES (NEXTVAL('idprestec_seq'),2123217,'2017-01-02','01-02-2017',9,'R',3);

/* El tercer insert peta perque la idllibre no es trova en la taula de llibre */
/* [23503] ERROR: inserción o actualización en la tabla «prestec» viola la llave foránea «fk_llibre_id» Detail: La llave (idllibre)=(21331216) no está presente en la tabla «llibre». */ 

/* El cinque insert peta ja que la data de prestec es mes gran que la de retorn */
/* [23514] ERROR: el nuevo registro para la relación «prestec» viola la restricción 
«check» «chk_dateretorn» Detail: La fila que falla contiene (30, 2123217, 2017-03-14, 2017-03-11, 2, R, 2). */

/* El sise insert falla ja que en la columne estat sol pot contrindre les lletres P i R i aquesta te una S */
/* [23514] ERROR: el nuevo registro para la relación «prestec» viola la restricción «check» 
«chk_estat» Detail: La fila que falla contiene (35, 2124215, 2019-08-14, 2020-01-05, 1, S, 1). */

/* El sete insert peta ja que no hi ha ningun soci amb la id 9 */
/* [23503] ERROR: inserción o actualización en la tabla «prestec» viola la llave foránea «fk_soci_id» Detail: La llave (idsoci)=(9) no está presente en la tabla «soci». */

/* Exercici 11. (0,5 punts)
Actualitza els valors del camp estat de la taula prestec de tots els préstecs que la penalització
sigui igual a 1. L’estat de tots aquests préstecs ha de ser R. Comprova que l’actualització s’ha
realitzat correctament. */

UPDATE prestec SET estat='R' WHERE penalitzacio=1;

/* Per comprovar els canvis fem */
SELECT * FROM prestec;


 /* Exercici 12. (0,5 punts)
Elimina el llibre que el codi del llibre sigui igual a 2126219 */

DELETE FROM llibre WHERE idllibre=2126219;


/* Exercici 13. (0,25 punts)
Intenta eliminar la taula soci. Ho pots fer? En cas negatiu explica perquè. Torna-la a crear
afegint les 5 files inicials si l’has pogut eliminar. */

DROP TABLE soci;

/* [2BP01] ERROR: no se puede eliminar tabla soci porque otros objetos dependen de él Detail: restricción «fk_soci_id» en tabla prestec 
depende de tabla soci Hint: Use DROP ... CASCADE para eliminar además los objetos dependientes. */

/* No es pot eliminar ja que el camp idsoci esta referenciada amb una altre taula */


/* Exercici 14. (0,25 punts)
Intenta eliminar tot els valors de la taula soci. Ho pots fer? En cas negatiu explica perquè. */

DELETE FROM soci;

/* [23503] ERROR: update o delete en «soci» viola la 
llave foránea «fk_soci_id» en la tabla «prestec» Detail: La llave (idsoci)=(2) todavía es referida desde la tabla «prestec». */

/* No hem deixa eliminar res ja que els valors que hi han estan referenciats a una altre taula */


/* Exercici 15. (0,25 punts)
Crea una vista anomenada titolsllibres amb el títol i autor del tots els llibres.
Comprova el contingut de la vista creada. */

CREATE VIEW titolsllibres AS
(SELECT titul,autor FROM llibre);

/* Ho comprovem amb la seguent comanda*/
SELECT * FROM titolsllibres;

/* Exercici 16. (0,5 punts)
Crea una vista anomenada socisambprestec amb el nom, cognoms i telèfon dels socis que
tinguin préstecs retornats. Comprova el contingut de la vista creada. */ 

CREATE VIEW socisambprestec AS
(SELECT soci.nom,soci.cognoms,soci.telefon,prestec.estat FROM soci,prestec WHERE prestec.estat='R');

/* Ho comprovem amb la seguent comanda*/
SELECT * FROM socisambprestec;

/* Exercici 17. (0,25 punts)
Crea un índex únic anomenat llibre_idx sobre el camp isbn de la taula llibre i comprova que
s’ha creat correctament. */

CREATE INDEX llibre_idx ON llibre(isbn);

/* \d llibre per comprovar que s'ha creat correctament*/

/* Exercici 18. (0,25 punts)
Crea un índex anomenat soci_idx sobre el camp cognoms de la taula soci i comprova que
s’ha creat correctament. */

CREATE INDEX soci_idx ON soci(cognoms);
/* \d llibre per comprovar que s'ha creat correctament*/


/* Exercici 19. (0,75 punt)
Actualitza el codi del llibre amb idllibre igual a 2121213. El nou codi és 3121213. Si no es
pot modificar explica perquè i realitza els canvis que siguin necessaris a l‘estructura de les
taules perquè aquest valor es pugui actualitzar. Comprova que realment s'ha pogut actualitzar. */

UPDATE llibre SET idllibre=3121213 WHERE idllibre=2121213;

/* [23503] ERROR: update o delete en «llibre» viola la llave foránea «fk_llibre_id» en la tabla «prestec» Detail: La llave (idllibre)=(2121213) todavía es referida desde la tabla «prestec». */
/* No el puc borra ja que esta referenciat a una altre taula */

UPDATE llibre SET idllibre=3121213 WHERE idllibre=2121213 CASCADE;

/* Exercici 20. (1,5 punts)
Exercici de transaccions. Suposem que inicialment la taula llibre esta buida. Tenint en
compte les següents sentències respon les preguntes:
T1: INSERT INTO llibre VALUES (‘40’, ’12345678’, ’Introducció a Oracle’, ’Jordi
Gómez’);

a) En quin estat està la taula i perquè?
Doncs ha efegit un insert a la taula llibre

T2: SELECT * FROM llibre;
T3: DELETE FROM llibre WHERE idllibre=’40’;
T4: ROLLBACK;

b) En quin estat està la taula i perquè?
Doncs a eliminat el llibre amb la id 40 ja que a fet un rollback al principi del tot

T5: INSERT INTO llibre VALUES (‘50’, ’12345679’, ’Introducció a Oracle II’, ’Jordi
Gómez’);

T6: COMMIT;
c) En quin estat està la taula i perquè?
A insertat un valor a la taula llibres i la fet permanent gracies al COMMIT;

T7: SELECT * FROM soci;
T8: DELETE FROM llibre WHERE idllibre=’50’;
T9: ROLLBACK;
d) en quin estat està la taula i perquè?
Segueix estant el llibre ja que a fet un rollback

T10: SELECT * FROM soci;
T11: INSERT INTO llibre VALUES (‘60’, ’12345680’, ’Programació avançada’,
’Francesc’);
T12: INSERT INTO llibre VALUES (‘70’, ’12345681’, ’Programació avançada II’, ’
Francesc’);
T13: SAVEPOINT intA;
e) En quin estat està la taula i perquè?
a inserit dos valors mes a la taula i un safepoint que es diu intA

T14: INSERT INTO llibre VALUES (‘70’, ’12345681’, ’Programació avançada II’, ’
Francesc’);
T15: ROLLBACK TO intA;
f) En quin estat està la taula i perquè?
El ultim valor colocat a la taula no s'ha fet ja que a fet rollback abans de tot

T16: UPDATE llibre SET autor=’Belen’ WHERE isbn=’12345680’;
T17: COMMIT;
g) En quin estat està la taula i perquè?
ha camviat el valor de autor de el llibre amb el isbn 12345680 i a fet permanent els camvis

T18: ROLLBACK TO intA;
h) En quin estat està la taula i perquè?*/
/*Es queda igual ja que a fet permanent els camvis abans llabors els savepoint ja no serveix de res */