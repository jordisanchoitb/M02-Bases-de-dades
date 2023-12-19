/*Exercici 1. (0,75 punts)
L'empresa de vendes ara també vol oferir serveis de reparacions. Necessitem crear una nova
taula a la base de dades "training" per fer el seguiment dels serveis. La nova taula es diu "servei"
i conté els següents camps: id_servei, descripcio, data_servei, id_venedor, id_client i preu.
Tria tu els tipus de dades que creguis més convenient per cada camp. Has de tenir en compte que
la taula ha de tenir una clau primària, que tots els camps han de ser obligatoris i que el camp
id_venedor fa referència a la taula "repventas", i que el camp id_client fa referència a la taula
"clientes".*/
Create TABLE servei (
    id_servei smallint NOT NULL,
    descripcio varchar(50) NOT NULL,
    data_servei date NOT NULL,
    id_venedor smallint NOT NULL,
    id_client smallint NOT NULL,
    preu numeric NOT NULL,

        CONSTRAINT PK_Soci_ID PRIMARY KEY (id_servei),
        CONSTRAINT FK_Venedor_ID FOREIGN KEY (id_venedor) REFERENCES repventas(num_empl),
        CONSTRAINT FK_Client_ID FOREIGN KEY (id_client) REFERENCES clientes(num_clie)
);


/*Exercici 2. (0,25 punts)
Afegeix un nou camp a la taula "servei" anomenat "temps" per guardar el número d'hores que
dura la reparació. Per defecte ha de ser una hora i ha de ser obligatori.*/
ALTER TABLE servei add temps numeric not null default 1;


/*Exercici 3. (0,25 punts)
Afegeix un nou camp a la taula "servei" que emmagatzemi el preu per hora de la reparació.
Aquest camp s'ha dir preu_hora ha de ser NUMERIC(15), obligatori i només ha d'acceptar els
valors 25,35,45 i 60.*/
ALTER TABLE servei add preu_hora NUMERIC(15) not null;
ALTER TABLE servei add CONSTRAINT chk_values_preuhora CHECK (preu_hora IN (25,35,45,60));

/*Exercici 4. (0,25 punts)
Modifica el nom del camp "preu", s'ha de dir "total" i ha de ser tipus NUMERIC(20) i obligatori.*/
ALTER TABLE servei RENAME COLUMN preu TO total;
ALTER TABLE servei alter column total set DATA TYPE NUMERIC(20);
ALTER TABLE servei alter column total set not null;


/*Exercici 5. (0,25 punts)
Afegeix una restricció a la taula "repventas" que l'edat dels venedors no sigui inferior a 18 anys
ni superior a 65.*/
ALTER TABLE repventas add CONSTRAINT chk_age CHECK (edad between 18 and 65);


/*Exercici 6. (0,25 punts)
Elimina el camp "titulo" de la taula "repventas".*/
ALTER TABLE repventas drop titulo;


/*Exercici 7. (0,25 punts)
Crea una seqüència perquè el camp identificador de la taula "servei" es pugui
autoincrementar. Que comenci per 10, que incrementi 5 i el valor màxim sigui 80000000. La
seqüència s’ha d’anomenar id_servei_seq.*/
CREATE SEQUENCE id_servei_seq
INCREMENT 5
START WITH 10
MAXVALUE 80000000;


/*Exercici 8. (0,5 punts)
Intenta inserir els següents registres a la taula "servei". Utilitza la seqüencia creada en
l’exercici anterior. Si a l’introduir les dades et dona errors, explica l’error que et dona i no
insereixis el registre. Comprova tots els valors inserits. La informació que ha d’intentar
inserir és la següent.

Reparació toner 2020-03-11 102 2112 45 2 135
Reparacio fresadora 2021-08-02 106 2121 55 4 220
Reparacio calefacció 2022-10-05 101 3224 35 2 70
Reparació envasadora 2019-03-04 108 2107 25 25
*/

insert into servei (id_servei, descripcio, data_servei, id_venedor, id_client, preu_hora, temps, total)
values (NEXTVAL('id_servei_seq'), 'Reparació toner', '2020-03-11', 102, 2112, 45, 2, 135);

insert into servei (id_servei, descripcio, data_servei, id_venedor, id_client, preu_hora, temps, total)
values (NEXTVAL('id_servei_seq'), 'Reparacio fresadora', '2021-08-02', 106, 2121, 55, 4, 220);
/* Dona error al fer aquest insert ja que el preu hora no esta dins
del rang espeficicat en el check posat enteriorment */

insert into servei (id_servei, descripcio, data_servei, id_venedor, id_client, preu_hora, temps, total)
values (NEXTVAL('id_servei_seq'), 'Reparacio calefacció', '2022-10-05', 101, 3224, 35, 2, 70);
/* Dona error ja que el client amb el numero 3224 no existeix a la taula clientes */

insert into servei (id_servei, descripcio, data_servei, id_venedor, id_client, preu_hora, total)
values (NEXTVAL('id_servei_seq'), 'Reparació envasadora', '2019-03-04', 108, 2107, 25, 25);


/*Exercici 9. (0,5 punts)
Afegir una nova oficina de la ciutat de "San Francisco", regió oest, el director ha de ser
"Larry Fitch", les vendes 0, l'objectiu ha de ser la mitja de l'objectiu de les oficines de l'oest i
l'identificador de l'oficina ha de ser el següent valor després del valor més alt. Utilitza
consultes a les taules corresponents si cal obtenir el valor que necessita determinat camp de la
taula "oficinas".*/

insert into oficinas (oficina, ciudad, region, dir, objetivo, ventas) VALUES ((select max(oficina)+1 from oficinas),'San Francisco','regio oest',(select num_empl from repventas where nombre = 'Larry Fitch'),(select avg(objetivo) from oficinas where lower(region) = 'oeste'), 0);

/* Select utilitzats per el insert enterior */
select max(oficina)+1 from oficinas;
select avg(objetivo) from oficinas where lower(region) = 'oeste';
select num_empl from repventas where nombre = 'Larry Fitch';


/*Exercici 10. (0,5 punts)
Crea una nova taula que s'anomeni "ven_servei" que contingui el nom i l'edat de tots els
venedors, i si els venedors han fet algun servei, mostra també la descripció, la data i el preu
total del servei. Aquesta taula s'ha de crear a partir d'una consulta a la base de dades
"training".*/



/*Exercici 11. (0,5 punts)
Crea una vista anomenada "oficina_est" que contingui únicament les dades de les oficines de
la regió Est .*/
CREATE VIEW oficina_est AS
(SELECT * FROM oficinas where lower(region) = 'este');



/*Exercici 12. (0,5 punts)
Crea una vista de nom "rep_oeste" que mostri totes les dades dels venedors de la regió Oest.*/
CREATE VIEW rep_oeste AS
(SELECT * FROM repventas rep
    join oficinas ofi on (ofi.oficina = rep.oficina_rep)
        where lower(region) = 'este' );


/*Exercici 13. (0,5 punts)
Crea una vista de nom "clients_vip" mostri únicament aquells clients que la suma
dels imports de les seves comandes superin 40000. Mostra totes les dades d'aquests clients.
Utilitza una subconsulta correlacionada.*/
CREATE VIEW clients_vip AS
(SELECT * FROM clientes c
    where 40000 < ALL (select sum(importe) from pedidos group by clie));


/*Exercici 14. (0,5 punts)
Crea una vista de nom "pedidos_sue" que contingui únicament les comandes fetes per clients
assignats al venedor ‘Sue’. Utilitza subconsultes.*/
CREATE VIEW pedidos_sue AS
(SELECT * FROM pedidos p
    where rep = (Select num_empl from repventas where nombre = 'Sue Smith'));


/*Exercici 15. (0,5 punts)
Crea una vista de nom "com_per_ven" que conté les següents dades de les comandes de cada
venedor: nom_venedor, quantitat_comandes, import_total, import_minim, import_maxim,
import_promig.*/
CREATE VIEW com_per_ven AS
(SELECT rep.nombre,
        sum(importe), min(importe), max(importe), avg(importe) from pedidos ped,
                                repventas rep group by rep.num_empl);


/*Exercici 16. (0,5 punts)
Incrementa en 2000 (suma 2000) el límit de crèdit de qualsevol client que ha fet una comanda
d'import superior a 15000.*/

UPDATE clientes set limite_credito = (limite_credito+2000) where num_clie in (select clie from pedidos where importe > 15000);

/*Exercici 17. (0,5 punts)
Reassigna tots els clients atesos pels empleats 105, 106, 107, a l'empleat 102.*/
UPDATE clientes set rep_clie = (102) where rep_clie in (105,106,107);



/*Exercici 18. (0,5 punts)
Assigna una quota de 150000 a tots aquells venedors que actualment no tenen quota.*/
UPDATE repventas set cuota = (150000) where cuota is null;


/*Exercici 19. (0,5 punts)
Elimina tots els clients dels venedors: Adams, Jones i Roberts.*/
delete from clientes where rep_clie in (select num_empl from repventas where nombre in ('Adams','Jones','Roberts'));


/*Exercici 20. (0,5 punts)
Elimina totes les comandes gestionades per 'Sue Smith'.*/
delete from pedidos where rep = (select num_empl from repventas where nombre = 'Sue Smith');


/*Exercici 21. (0,5 punts)
Elimina els venedors els quals la suma total dels imports de les comandes que gestiona és
menor que el 2% de la seva quota.*/
delete from repventas where num_empl in
                            (select rep from pedidos where importe <
                                                           (select cuota*0.2 from repventas));


/*Exercici 22. (0,75 punts)
Crea una taula anomenada "productos_sin_pedidos" omplerta amb totes les dades d'aquells
productes que no han tingut mai cap comanda. A continuació elimina de la taula "productos"
aquells productes que estan en aquesta nova taula. Utilitza el test d'existència per crear la
nova taula.*