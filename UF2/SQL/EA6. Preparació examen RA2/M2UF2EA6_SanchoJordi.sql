/* 
Crear la base de dades amb el usuari shop

CREATE DATABASE shop;
CREATE USER shop WITH SUPERUSER CREATEROLE ENCRYPTED PASSWORD 'shop';
ALTER DATABASE shop OWNER TO shop;
GRANT ALL PRIVILEGES ON DATABASE shop TO shop;
*/

/* Exercici 1: Realitza les següents tasques: */

/* a) (1,5 punts). Escriu les sentències necessàries per crear les taules ORDERF, PRODUCT i
ORDER_DETAILS en la base de dades shop. tenint en compte les restriccions indicades en
l’estructura de la base de dades. */

CREATE TABLE orderf (
    order_id NUMERIC(12), /* falta posar NOT NULL*/
    order_date DATE,
    shipped_date DATE,
    ship_address VARCHAR(50) NOT NULL,
    ship_city VARCHAR(20),
    ship_region VARCHAR(20),

        CONSTRAINT PK_ORDER_ID PRIMARY KEY (order_id),
        CONSTRAINT CHK_Region CHECK (ship_region IN ('USA', 'EUROPA', 'ASIA', 'AMERICA', 'RUSIA')),
        CONSTRAINT CHK_Shipped_Date CHECK (shipped_date > order_date)
);

CREATE TABLE product (
    product_id NUMERIC(12),
    product_name VARCHAR(50) NOT NULL,
    unitprice DOUBLE PRECISION NOT NULL,
    unitstock NUMERIC(3) NOT NULL,
    unitonorder NUMERIC(3) NOT NULL DEFAULT 1,

        CONSTRAINT PK_PRODUCT_ID PRIMARY KEY (product_id)
);

CREATE TABLE order_details (
    order_id NUMERIC(12) NOT NULL,
    product_id NUMERIC(12) NOT NULL,
    quantity NUMERIC(3) NOT NULL,
    discount NUMERIC(3) ,

        CONSTRAINT PK_PRODUCT_AND_ORDER_ID PRIMARY KEY (order_id,product_id),
        CONSTRAINT FK_Order_ID FOREIGN KEY (order_id) REFERENCES orderf(order_id),
        CONSTRAINT FK_Product_ID FOREIGN KEY (product_id) REFERENCES product(product_id)

);

/* b) (0,25 punts). Comprova que les 3 taules s'han creat correctament amb la comanda que mostra
la definició de les taules amb els camps de les taules, tipus de dades, etc. */

/* Les comandes que utilitzarem per veura si s'han creat correctament son les seguents */

/* \d orderf */
/* \d product */
/* \d order_details */

/* c) (0,5 punts). Una vegada creades les taules, ens hem adonat que hi ha un error a la taula
ORDERF. Hem de modificar dos camps.
ship_city VARCHAR(40),
ship_region VARCHAR(40))
Escriu el codi per realitzar aquests canvis i comprova que s'han modificat correctament. */

ALTER TABLE orderf 
ALTER COLUMN ship_city SET DATA TYPE VARCHAR(40);

ALTER TABLE orderf 
ALTER COLUMN ship_region SET DATA TYPE VARCHAR(40);


/* Per comprovar si s'han fet els camvis posem \d orderf */

/* d) (0,75 punts). Crea una seqüència perquè el camp product_id es pugui autoincrementar.
Que comenci per 1, que incrementi 1 i el valor màxim sigui 99999. */

CREATE SEQUENCE PRODUCTID_SEQ
INCREMENT 1
START WITH 1
MAXVALUE 99999;

/* e) (0,75 punts). Introdueix les següents dades a la taula PRODUCT. Utilitza la seqüencia
creada en l’exercici anterior i comprova que s’han inserit correctament els valors. */

INSERT INTO product VALUES (NEXTVAL('PRODUCTID_SEQ'),'nikkon ds90',67.09,75,1);
INSERT INTO product VALUES (NEXTVAL('PRODUCTID_SEQ'),'canon t90',82.82,92,1);
INSERT INTO product VALUES (NEXTVAL('PRODUCTID_SEQ'),'dell inspirion',182.78,56,2);
INSERT INTO product VALUES (NEXTVAL('PRODUCTID_SEQ'),'ipad air',482.83,34,2);
INSERT INTO product VALUES (NEXTVAL('PRODUCTID_SEQ'),'microsoft surface',93.84,92,2);
INSERT INTO product VALUES (NEXTVAL('PRODUCTID_SEQ'),'nexus 6',133.88,16);
INSERT INTO product VALUES (NEXTVAL('PRODUCTID_SEQ'),'thinkpad t365',341.02,22);

SELECT * FROM product;

/* f) (0,75 punts). Intenta inserir els següents registres a la taula ORDERF. La informació que
ha de contenir la taula és la següent: */

INSERT INTO orderf VALUES (4001,'2016-04-04','2016-11-06','93 Spohn Place','Manggekompo','ASIA');
INSERT INTO orderf VALUES (4002,'2017-01-29','2016-05-28','46 Eliot Trail','Virginia','USA');
INSERT INTO orderf VALUES (4001,'2016-08-19','2016-12-08','23 Sundown Junction','Obodivka','ASIA');
INSERT INTO orderf VALUES (4004,'2016-09-25','2016-12-24',NULL,'Nova Venécia','AMERICA');
INSERT INTO orderf VALUES (4005,'2017-03-14','2017-03-19','7 Ludington Court','Sukamaju','ASIA');
INSERT INTO orderf VALUES (4006,'2016-08-14','2016-12-05','859 Dahle Plaza',NULL,'ASIA');
INSERT INTO orderf VALUES (4007,'2017-01-02','01-02-2017','5 Fuller Center Log pri','Brezovici','EUROP');

/* El primer error que dona es la segon insert que falla la ja que la primera data es mes petita 
que la segona i hi ha una restriccio que diu que ha de ser mes gran segona data que la primera*/
/* El segon error es dona en el tercer insert que la clau primaria es repateix */
/* El tercer error es dona en el quart insert ja que hi ha una restricio que es not null y no hi ha informacio en aquella columna */



/* g) (0,75 punts) Intenta inserir els següents registres a la taula ORDER_DETAILS. La infor-
mació que ha de contenir la taula és la següent: */
INSERT INTO order_details VALUES (4001,1,5,8.73);
INSERT INTO order_details VALUES (4003,3,8,4.01);
INSERT INTO order_details VALUES (4005,601,2,3.05);
INSERT INTO order_details VALUES (4006,2,4,5.78);

/* Si a l’introduir les dades en la taula ORDER_DETAILS et dona errors, explica l’error que et dona i
no insereixis el registre. Com que el camp discount el vam crear com a NUMERIC(3) ara l’hem de
modificar i que sigui DOUBLE PRECISION. */ 

/* Hem dona dos errors que son que la clau primaria del order_id no existeix en un del insert i
 l'altre es que la altre clau primaria7 foranea no existeix en product_id */

ALTER TABLE order_details 
ALTER COLUMN discount SET DATA TYPE DOUBLE PRECISION;

/* Exercici 2. Realitza les següents tasques: */

/* a) (0,25 punts). Crea un índex per la taula ORDERF, pel camp ship_address. */

CREATE INDEX ship_addressIndex ON orderf(ship_address);

/* b) (0,5 punts). Crea un índex únic per la taula PRODUCT, pel camp product_name. */

CREATE UNIQUE INDEX product_nameIndex ON product(product_name);


/* Exercici 3. Realitza les següents tasques: */

/* a) (1 punt). Afegeix els següents camps a la taula ORDERF: */

ALTER TABLE orderf ADD cost_ship DOUBLE PRECISION DEFAULT 1500;
ALTER TABLE orderf ADD logistic_cia VARCHAR(100);
ALTER TABLE orderf ADD others VARCHAR(250);

ALTER TABLE orderf ADD CONSTRAINT CHK_logistic_cia CHECK(logistic_cia IN('UPS','MRW','Post_Office','Fedex','TNT','DHL','Moldtrans','SEUR'));

/* b) (0,5 punts). Elimina el camp others de la taula ORDERF. */

ALTER TABLE orderf DROP COLUMN others;


/* Exercici 4. Realitza les següents tasques: */

/* a) (0,5 punts). Modifica els valors del camp discount de la taula ORDER_DETAILS dels
registres que la quantitat sigui més gran que 2. El nou descompte serà 7.5. Comprova que s'ha
efectuat el canvi. */
BEGIN;

UPDATE order_details SET discount=7.5 WHERE quantity>2;

SELECT * FROM order_details

/* b) (0,25 punts) desfés els canvis que has fet en l'apartat anterior i comprova si s'han desfet. */

ROLLBACK;
SELECT * FROM order_details;

/* c) (0,5 punts) Elimina els productes que tinguin un unitstock < 30 i fes que els canvis siguin
permanents. */

DELETE FROM product WHERE unitstock<30;
COMMIT;

/* d) (1,25 punt) Elimina la comanda de la taula ORDERF amb order_id = 4006. Si no la pots

eliminar explica perquè no pots, i realitza les modificacions que siguin necessàries a les tau-
les perquè la puguis eliminar. Comprova que realment s'ha eliminat la comanda. */


DELETE FROM orderf WHERE order_id=4006;

 /* No hem deixa eliminarla ja que es una clau foranea que esta referia en una altre taula */
 /* per eliminarla tenim eliminar la referencia a l'altre taula*/

