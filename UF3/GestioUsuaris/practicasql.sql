/* Activitat 1 */
/* Confidencialitat:

Un exemple concret de violació de la confidencialitat en un sistema informàtic en un entorn hospitalari podria ser l'accés no autoritzat a les dades mèdiques dels pacients per part d'una persona que no està autoritzada a veure aquesta informació. Això podria ser causat per una fallada en les mesures de seguretat del sistema, com ara contrasenyes febles o una gestió inadequada dels permisos d'accés. Aquesta violació de la confidencialitat podria posar en perill la privacitat dels pacients i potencialment exposar la seva informació mèdica sensible a persones no autoritzades.


Integritat:

Un exemple de violació de la integritat en un sistema informàtic en un entorn hospitalari podria ser la modificació no autoritzada de les dades mèdiques dels pacients. Això podria ser causat per un accés no autoritzat al sistema o per una explotació de les vulnerabilitats del sistema. Si algú modifica les dades mèdiques d'un pacient sense autorització, això podria tenir conseqüències greus per al pacient, com ara un diagnòstic o un tractament incorrecte. Per garantir la integritat de les dades, és important implementar mesures de seguretat adequades, com ara controls d'accés i registres d'auditoria.


Disponibilitat:

Un exemple de violació de la disponibilitat en un sistema informàtic en un entorn hospitalari podria ser un atac de denegació de servei (DoS) que afecta el sistema. Un atac de DoS té com a objectiu sobrecarregar el sistema amb una gran quantitat de trànsit o sol·licituds, de manera que els usuaris legítims no puguin accedir als serveis o recursos del sistema. Això podria afectar negativament l'atenció als pacients i el funcionament general de l'hospital. Per protegir la disponibilitat del sistema, és important implementar mesures de seguretat, com ara firewalls i sistemes de detecció d'intrusions, per prevenir o mitigar aquests tipus d'atacs.

 */

 /* Activitat 2 */
 /* Un laboratori ens encarrega desenvolupar una base de dades en postgreSQL per gestionar la informació  que genera. 
La informació (aplicacions i usuaris de l’empresa) es centralitzarà en una base de dades corporativa: PostgreSQL.
Primerament, cal un usuari administrador, que serà un informàtic, que crearà la estructura de la base de dades, els rols i definirà els permisos inicials dels usuaris.


Aquesta activitat s’ha de realitzar des de terminal de comandes. Heu de presentar captures de pantalla on es vegi la base de dades sobre la que treballeu i l’usuari amb el que esteu connectats, juntament amb les instruccions del que es demana a l'enunciat i el resultat d’execució de les mateixes.

Per exemple, si treballeu des del terminal de comandes:



Algunes instruccions que us resultaran molt útils fent l'activitat per terminal de comandes:


\d → Veure totes les taules de l’esquema
\dt nom_taula → descripció breu de la taula
\d nom_taula → descripció ampliada de la taula amb els seus camps
\dt → llista taules
\dn → Veure tots els esquemes
\l → veure les bases de dades disponibles
\du → llista rols
\c bbdd user → connectar a la bbdd amb l'usuari user
\dp taula → llista permisos
SELECT * FROM pg_user → veure tots els usuaris
SELECT current_user → Veure quin usuari està actualment connectat a la base de dades
SELECT current_schema  → Veure l’esquema on estàs ubicat

La base de dades amb la qual treballarem, tal com hem comentat, s'utilitza per organitzar la informació que es genera en un laboratori. Aquest laboratori disposa també de varis consultoris on es realitzen les visites als pacients i les extraccions de les mostres, i disposa d'un laboratori per fer les analítiques o tests de les mostres que s'extreuen dels pacients. La part admistrativa del centre organitza les visites i el personal, i també gestiona els pagaments als proveidors dels reactius. 

Les taules de la base de dades les distribuirem en 3 esquemes diferents: «administracio», «clinica» i «laboratori». 

A l'esquema administracio hi ha les taules PERSONA, PACIENT, METGE, TECNIC i PROVEIDOR. A l'esquema clinica les taules CONSULTORI i VISITA, i a l'esquema laboratori hi ha les taules MOSTRA, REACTIU i TEST.
La taula PERSONA és la taula "pare" amb els atributs comuns de les taules "filles" PACIENT ,METGE i TÈCNIC que cada una té els seus atributs específics. 
Volem enregistrar en quins consultoris es realitzen les visites, i la taula VISITA es genera d'una relació ternària entre les taules METGE, PACIENT i CONSULTORI. Aquesta taula recull els identificadors de les taules METGE, PACIENT i CONSULTORI, la data de la visita, el preu de la visita i la ruta o enllaç on es troba l'informe que fa el metge de cada visita. 
La taula MOSTRA és una entitat dèbil de l'entitat PACIENT, i per tant la clau primària estàra formada pels camps identificador de la mostra i l’identificador de pacient, i també tindrà altres atributs com tipus de mostra i la data d'extracció de la mostra.
La taula TEST és on es guarden les analítiques realitzades a les mostres i que realitza un determinat tècnic. Per realitzar una analítica es necessita un determinat reactiu, així que aquesta taula TEST es genera d'una relació ternària entre les taules MOSTRA, TÈCNIC i REACTIU, i recull els identificadors de les taules MOSTRA, TÈCNIC i REACTIU, la data de l'analítica, el seu preu i la ruta o enllaç on es troba el resultat de l'analítica. Suposarem que cada reactiu només té un sol proveïdor, però que un proveïdor pot proporcionar varis reactius i per tant a la taula REACTIU hi guardarem l'identificador del proveïdor.

El model relacional de la base de dades és el següent:
administracio.PERSONA(dni,nom,cognom1,cognom2,data_naix,telefon,mail)
administracio.PACIENT(dni_pacient,nss,genere)
administracio.METGE(dni_metge,especialitat)
administracio.TECNIC(dni_tecnic,data_inici)
administracio.PROVEIDOR(cif,nom,telefon,mail)
clinica.CONSULTORI(codi_cons,ubicacio,superficie)
clinica.VISITA(codi_visita,dni_pacient,dni_metge,codi_cons,data_visita,preu)
laboratori.MOSTRA(codi_mostra,dni_pacient,tipus,data_extr)
laboratori.REACTIU(codi_reac,nom,preu,cif_prov,preu)
laboratori.TEST(codi_test,codi_mostra,dni_pacient,dni_tecnic,codi_reac,resultat,data_resultat,preu)

Les claus primàries estan subratllades i les claus foranes estan en cursiva. Hi claus primàries que també són foranes com és el cas de «dni_pacient» perquè es relaciona amb la clau primària de la taula PERSONA.

Aquesta Base de dades es considera un prototip i no considera totes les casuístiques d'una empresa real d'aquesta mena. 
*/
/*2.1 – Realitzeu els següents punts per tal de poder començar a treballar amb la base de dades fent servir l'usuari administrador que tingueu per defecte. 

Creeu la base de dades amb el nom: labelvostrenom, on substituireu «elvostrenom» per el vostre nom de pila i la primera inicial del cognom. Per exemple: labjoanc.
Creeu l'usuari adminlab amb privilegis de ‘superuser’ per a crear nous rols/papers. A més s'haurà de poder validar i haurà de tenir el password 'admin24' encriptat.
Feu a adminlab propietari de labelvostrenom.
Assigneu tots els privilegis a l'usuari adminlab sobre la base de dades. Aquest usuari crearà l'estructura de la base de dades, els rols i els permisos als usuaris.
 */
CREATE DATABASE labjordis;
CREATE USER adminlab WITH SUPERUSER CREATEROLE ENCRYPTED PASSWORD 'admin24';
ALTER DATABASE labjordis OWNER TO adminlab;
GRANT ALL PRIVILEGES ON DATABASE labjordis TO adminlab;

-- comando para saber que usuario esta conectado
SELECT current_user;
-- comando para saber en que base de datos estamos
SELECT current_database;


/* 2.2 – Realitzeu els següents punts per tal de crear els diferents esquemes */
/*Sortiu del client PostgreSQL i connecteu-vos a la BBDD que heu creat amb l'usuari adminlab.
Comproveu quin usuari està connectat
Creeu tres esquemes anomenats administracio, clinica i laboratori.
Feu una consulta per comprovar tots els esquemes de la BBDD. 
Comproveu en quin esquema esteu situats.
 */

\c labjordis adminlab
SELECT current_user;
CREATE SCHEMA administracio;
CREATE SCHEMA clinica;
CREATE SCHEMA laboratori;
\dn
SELECT current_schema;

/*2.3 – Realitzeu els següents punts per tal de crear les taules en el seu esquema corresponent */
/*Comproveu amb quin usuari esteu connectats. Ha de ser l'usuari adminlab. 
Situeu-vos a l'esquema administracio.
Creeu les taules PERSONA,PACIENT, METGE, TECNIC i PROVEIDOR dins de l’esquema administracio. Trobareu el codi de creació de les taules a continuació.
Situeu-vos a l'esquema laboratori i creeu les taules MOSTRA, REACTIU i TEST. Trobareu el codi de creació de les taules a continuació.
A l'esquema public (el que ve per defecte), creeu les taules CONSULTORI i VISITA. Trobareu el codi de creació de les taules a continuació.
Les taules CONSULTORI i VISITA es troben ara a l'esquema public, però volem que estiguin a l'esquema clinica. Reubiqueu aquestes dues taules a l'esquema clinica.
Comproveu que les taules CONSULTORI i VISITA es troben a l'esquema clinica.
*/

SELECT current_user;
SET search_path TO administracio;
SELECT current_schema;

CREATE TABLE IF NOT EXISTS PERSONA (
 dni  NUMERIC(9) NOT NULL,
 nom     VARCHAR(20) NOT NULL,
 cognom1 VARCHAR(20) NOT NULL,
 cognom2 VARCHAR(20) NOT NULL,
 data_naix DATE NOT NULL,
 telefon VARCHAR (15) UNIQUE,
 mail VARCHAR(45),
 CONSTRAINT PK_PERS PRIMARY KEY (dni) 
  );

CREATE TABLE IF NOT EXISTS PACIENT (
 dni_pacient NUMERIC(9) NOT NULL,
 nss  VARCHAR(12) UNIQUE NOT NULL,
 genere CHAR(1) NOT NULL,
 CONSTRAINT PK_PAC PRIMARY KEY (dni_pacient),
 CONSTRAINT FK_PAC_PERS FOREIGN KEY (dni_pacient) REFERENCES PERSONA(dni) ON UPDATE CASCADE ON DELETE CASCADE,
 CONSTRAINT CK_GEN CHECK (genere IN ('H','D'))
 );

CREATE TABLE IF NOT EXISTS METGE(
 dni_metge  NUMERIC(9) NOT NULL,
 especialitat VARCHAR(20) NOT NULL,
 CONSTRAINT PK_MET PRIMARY KEY (dni_metge),
 CONSTRAINT FK_MET_PERS FOREIGN KEY (dni_metge) REFERENCES PERSONA(dni) ON UPDATE CASCADE ON DELETE CASCADE
 );

CREATE TABLE IF NOT EXISTS TECNIC(
 dni_tecnic  NUMERIC(9) NOT NULL, 
 data_inici DATE NOT NULL,
 CONSTRAINT PK_TEC PRIMARY KEY (dni_tecnic),
 CONSTRAINT FK_TEC_PERS FOREIGN KEY (dni_tecnic) REFERENCES PERSONA(dni) ON UPDATE CASCADE ON DELETE CASCADE
 );

CREATE TABLE IF NOT EXISTS PROVEIDOR (
 cif  VARCHAR(10) NOT NULL,
 nom  VARCHAR(20) NOT NULL,
 telefon VARCHAR (15) UNIQUE,
 mail VARCHAR(45),
 CONSTRAINT PK_PROV PRIMARY KEY (cif) 
  );

SET search_path TO laboratori;
SELECT current_schema;

CREATE TABLE IF NOT EXISTS MOSTRA(
 codi_mostra NUMERIC(20) NOT NULL,
 dni_pacient NUMERIC(9) NOT NULL, 
 tipus CHAR(1) NOT NULL,
 data_extr DATE NOT NULL,
 CONSTRAINT PK_MOS PRIMARY KEY (codi_mostra,dni_pacient),
 CONSTRAINT FK_MOS_PAC FOREIGN KEY (dni_pacient) REFERENCES administracio.PACIENT (dni_pacient) ON UPDATE CASCADE ON DELETE CASCADE, 
 CONSTRAINT CK_TIP CHECK (tipus IN ('S','O','F','P','M'))
  );

CREATE TABLE IF NOT EXISTS REACTIU(
 codi_reac NUMERIC(20) NOT NULL,
 nom VARCHAR(20) NOT NULL,
 cif_prov  VARCHAR(10) NOT NULL,
 preu DECIMAL(8,2),
 CONSTRAINT PK_REAC PRIMARY KEY (codi_reac),
 CONSTRAINT FK_REAC_PROV FOREIGN KEY (cif_prov) REFERENCES administracio.PROVEIDOR (cif) ON UPDATE CASCADE ON DELETE CASCADE
 );

CREATE TABLE IF NOT EXISTS TEST(
 codi_test NUMERIC(20) NOT NULL,
 codi_mostra NUMERIC(20) NOT NULL,
 dni_pacient NUMERIC(9) NOT NULL, 
 dni_tecnic  NUMERIC(9)NOT NULL, 
 codi_reac NUMERIC(20) NOT NULL,
 resultat TEXT NOT NULL,
 data_resultat DATE NOT NULL,
 preu DECIMAL(8,2),
 CONSTRAINT PK_TEST PRIMARY KEY (codi_test),
 CONSTRAINT FK_TEST_MOS FOREIGN KEY (codi_mostra,dni_pacient) REFERENCES MOSTRA (codi_mostra,dni_pacient) ON UPDATE CASCADE ON DELETE CASCADE,
 CONSTRAINT FK_TEST_TEC FOREIGN KEY (dni_tecnic) REFERENCES administracio.TECNIC (dni_tecnic) ON UPDATE CASCADE ON DELETE CASCADE,
 CONSTRAINT FK_TEST_REAC FOREIGN KEY (codi_reac) REFERENCES REACTIU (codi_reac) ON UPDATE CASCADE ON DELETE CASCADE
 );

SET search_path TO public;
SELECT current_schema;

CREATE TABLE IF NOT EXISTS CONSULTORI (
 codi_cons NUMERIC(9) NOT NULL,
 ubicacio VARCHAR(20) NOT NULL,
 superficie NUMERIC(10) NOT NULL,
 CONSTRAINT PK_CON PRIMARY KEY (codi_cons) 
  );

CREATE TABLE IF NOT EXISTS VISITA(
 codi_visita NUMERIC(20) NOT NULL,
 dni_pacient NUMERIC(9) NOT NULL,
 dni_metge  NUMERIC(9) NOT NULL,
 codi_cons NUMERIC(9) NOT NULL,
 informe TEXT NOT NULL,
 data_visita DATE NOT NULL,
 preu DECIMAL(8,2),
 CONSTRAINT PK_VIS PRIMARY KEY (codi_visita),
 CONSTRAINT FK_VIS_PAC FOREIGN KEY (dni_pacient) REFERENCES administracio.PACIENT (dni_pacient) ON UPDATE CASCADE ON DELETE CASCADE,
 CONSTRAINT FK_VIS_MET FOREIGN KEY (dni_metge) REFERENCES administracio.METGE (dni_metge) ON UPDATE CASCADE ON DELETE CASCADE,
 CONSTRAINT FK_VIS_CON FOREIGN KEY (codi_cons) REFERENCES CONSULTORI (codi_cons) ON UPDATE CASCADE ON DELETE CASCADE
 );

ALTER TABLE CONSULTORI SET SCHEMA clinica;
ALTER TABLE VISITA SET SCHEMA clinica;

/* 2.4 – Després de crear els objectes esquemes i taules, l’usuari adminlab és l'encarregat també de crear l’estructura d'usuaris i permisos per a què puguin treballar els diferents departaments de centre mèdic.
	Si no hi esteu connectat Connecteu amb l'usuari adminlab i creeu els rols següents amb els permisos indicats.	

Creeu 4 rols anomenats gerent, administratiu, metge i tecnic amb els privilegis següents sobre els esquemes anteriors. Verifiqueu la creació de rols i els privilegis. */

/* Gerent (heretable) : administracio (creacio i us), laboratori (creacio i us), clinica (creacio i us)
administratiu (heretable) : administracio (us) , laboratori (res), clinica (us)
metge (heretable) : administracio (res), laboratori (us), clinica (us) 
tecnic (heretable) : administracio (res), laboratori (creacio i us), clinica (res)*/

CREATE ROLE gerent INHERIT;
GRANT CREATE, USAGE ON SCHEMA administracio TO gerent;
GRANT CREATE, USAGE ON SCHEMA laboratori TO gerent;
GRANT CREATE, USAGE ON SCHEMA clinica TO gerent;

CREATE ROLE administratiu INHERIT;
GRANT USAGE ON SCHEMA administracio TO administratiu;
GRANT USAGE ON SCHEMA clinica TO administratiu;

CREATE ROLE metge INHERIT;
GRANT USAGE ON SCHEMA laboratori TO metge;
GRANT USAGE ON SCHEMA clinica TO metge;

CREATE ROLE tecnic INHERIT;
GRANT CREATE, USAGE ON SCHEMA laboratori TO tecnic;

// Lista los roles creados
\du

// llista els esquemes amb els seus permisos
\dn+



/* 2.5 – Assigneu als rols creats també els permisos sobre les taules.

gerent amb permisos totals a totes les taules de tots els esquemes. Poden fer operacions DML i DDL com crear vistes.
administratiu amb permisos DML de les taules dels esquemes administracio i clinica.
metge amb permisos de consulta, modificació i inserció de les taules de l'esquema clinica i laboratori peró no d'eliminació
tecnic amb permisos totals de les taules de l'esquema laboratori.
 */

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA administracio TO gerent;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA laboratori TO gerent;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA clinica TO gerent;

GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA administracio TO administratiu;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA clinica TO administratiu;

GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA clinica TO metge;
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA laboratori TO metge;

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA laboratori TO tecnic;

/* 2.6 – Creeu els usuaris següents i afegiu els privilegis corresponents per poder connectar a la base de dades:*/

/* rosa amb contrasenya “rosa22” hereta automàticament. Assigneu-li privilegis de gerent.
marta amb contrasenya “marta33” hereta automàticament. Assigneu-li privilegis de metge.
montse amb contrasenya “montse44” hereta automàticament. Assigneu-li privilegis de tecnic.
Roger amb contrasenya “roger55” hereta automàticament. Assigneu-li privilegis d’administratiu. */

CREATE USER rosa WITH PASSWORD 'rosa22' INHERIT;
GRANT gerent TO rosa;

CREATE USER marta WITH PASSWORD 'marta33' INHERIT;
GRANT metge TO marta;

CREATE USER montse WITH PASSWORD 'montse44' INHERIT;
GRANT tecnic TO montse;

CREATE USER roger WITH PASSWORD 'roger55' INHERIT;
GRANT administratiu TO roger;

/* 2.7 – Amb l’estructura de seguretat establerta, per simular el funcionament de la base de dades del centre mèdic es proposen algunes accions que han de realitzar uns rols concrets. */

/* Escriviu les sentències necessàries per a realitzar aquestes accions amb els rols/usuaris indicats, i en cas que no es pugui fer mostreu l'error que genera PostgreSQL i raoneu-ho.

Consulteu, a través del terminal de comandes, la llista de rols amb els seus atributs. Indiqueu la comanda i afegiu també la informació obtinguda. 
Desconneu-vos de la base de dades i connecteu-vos amb l’usuari roger. 
Comproveu quin usuari està connectat.
Mostreu el codi de totes les mostres. Si no les pot mostrar, expliqueu-ne el motiu. 
Mostreu totes les dades de la taula CONSULTORI. Si no les pot mostrar expliqueu-ne el motiu.
Mostreu el nom de tots els metges.
Desconnecteu-vos de la base de dades i connecteu-vos amb l’usuari marta. 
Comproveu quin usuari està connectat.
Elimineu el consultori amb el codi 34.
Mostreu els noms i els cognoms dels pacients que han sigut visitats pel metge amb dni 43995635.
 */

\du
\c labjordis roger
SELECT current_user;
SELECT codi_mostra FROM laboratori.MOSTRA;
SELECT * FROM clinica.CONSULTORI;
SELECT nom FROM administracio.PERSONA 
JOIN administracio.METGE ON administracio.PERSONA.dni = administracio.METGE.dni_metge;

\c labjordis marta
SELECT current_user;
DELETE FROM clinica.CONSULTORI WHERE codi_cons = 34;
SELECT nom, cognom1, cognom2 FROM administracio.PERSONA 
JOIN clinica.VISITA ON administracio.PERSONA.dni = clinica.VISITA.dni_pacient
WHERE dni_metge = 43995635;
\q

/* Activitat 3. Vistes i regles */

/* 3.1 – A l’esquema laboratori amb l'usuari adminlab, creeu, a partir de la selecció, una vista anomenada tests_2021 
amb els atributs codi_test, dni_tecnic, codi_reac, data_resultat i preu corresponents de la taula TEST. S’han de mostrar només les mostres informades l’any 2021.*/

\c labjordis adminlab
SELECT current_user;
SET search_path TO laboratori;
SELECT current_schema;
CREATE VIEW laboratori.tests_2021 AS
SELECT codi_test, dni_tecnic, codi_reac, data_resultat, preu
FROM laboratori.TEST
WHERE data_resultat BETWEEN '2021-01-01' AND '2021-12-31';

/* 3.2 – Comproveu si l’usuari montse pot consultar aquesta vista. Si no pot, expliqueu el motiu i 
assigneu els permisos necessaris per tal que la montse pugui consultar la vista. */

\c labjordis montse
SELECT current_user;
SELECT * FROM laboratori.tests_2021;

/* No pot consultar la vista ja que no te permisos per veure la taula TEST */
\c labjordis adminlab
SELECT current_user;
GRANT SELECT ON laboratori.tests_2021 TO montse;
\c labjordis montse
SELECT current_user;
SELECT * FROM laboratori.tests_2021;
\q

/* 3.3 – A l’esquema public amb l'usuari adminlab creeu una regla anomenada upd_tests_2021 que permeti modificar el preu d’un test per mitjà de la vista tests_2021 creada anteriorment. */

\c labjordis adminlab
SELECT current_user;
SET search_path TO public;
SELECT current_schema;
CREATE RULE upd_tests_2021 AS ON UPDATE TO laboratori.tests_2021 DO INSTEAD
UPDATE laboratori.TEST SET preu = new.preu WHERE codi_test = old.codi_test;


/* 3.4 – Amb l'usuari adminlab, creeu una vista que mostri els noms i cognoms dels metges que han realitzat visites al consultori amb codi_cons número 28. La vista s’anomena visites_28 i ha d’estar ubicada a l’esquema administracio. */

\c labjordis adminlab
SELECT current_user;
SET search_path TO administracio;
SELECT current_schema;
CREATE VIEW administracio.visites_28 AS
SELECT DISTINCT nom, cognom1, cognom2
FROM administracio.PERSONA
JOIN clinica.VISITA ON administracio.PERSONA.dni = clinica.VISITA.dni_metge
WHERE codi_cons = 28;

/* 3.5 – Amb l'usuari adminlab creeu una vista anomenada despesa_test que mostri el codi del test, el preu del test, el nom de reactiu utilitzat i el preu del reactiu dels tests que tenen un preu superior a 150. La vista ha d’estar ubicada a l’esquema laboratori. */

\c labjordis adminlab
SELECT current_user;
SET search_path TO laboratori;
SELECT current_schema;
CREATE VIEW laboratori.despesa_test AS
SELECT codi_test, laboratori.TEST.preu AS test_preu, nom, laboratori.REACTIU.preu AS reactiu_preu
FROM laboratori.TEST, laboratori.REACTIU
WHERE laboratori.TEST.codi_reac = laboratori.REACTIU.codi_reac AND laboratori.TEST.preu > 150;


/* 3.6 - A l’esquema public amb l'usuari adminlab creeu una regla anomenada del_despesa_test que permeti eliminar registres de la taula test per mitjà de la vista despesa_test creada anteriorment. */

\c labjordis adminlab
SELECT current_user;
SET search_path TO public;
SELECT current_schema;
CREATE RULE del_despesa_test AS ON DELETE TO laboratori.despesa_test DO INSTEAD
DELETE FROM laboratori.TEST WHERE codi_test = old.codi_test;

