/* Exercici 1 (3 punts). BBDD residus
Programa un bloc anònim que demani per teclat una ciutat i que imprimeixi el nom i el NIF de totes les
empreses transportistes que han realitzat algun trasllat cap a aquesta ciutat, o sigui que el destí del residu sigui
aquesta ciutat.
- Si la ciutat no existeix, s'ha de gestionar l'excepció sense utilitzar el bloc EXCEPTION
- Si la ciutat existeix, s’ha de mostrar el següent missatge: 'L`empresa transportista amb nom
<NOM_EMPTRANSPORT> i <NIF_EMPTRANSPORT> ha portat residus a la ciutat <CIUTAT_DESTI>
-Fes servir un cursor amb paràmetres i les clàusules OPEN, FETCH, CLOSE i utilitza una variable tipus
%ROWTYPE
- Fes els jocs de proves corresponents*/

DO $$
DECLARE
    v_ciutat_desti VARCHAR(30);
    v_nif_emptransport VARCHAR(12);
    v_nom_emptransport VARCHAR(120);
    vr_emptransport EmpresaTransportista%ROWTYPE;
    curs_emptransport CURSOR (par_ciutat_desti VARCHAR(30)) FOR
        SELECT nif_emptransport, nom_emptransport
        FROM EmpresaTransportista
        WHERE nif_emptransport IN (
            SELECT nif_emptransport
            FROM Trasllat_EmpresaTransport
            WHERE cod_desti IN (
                SELECT cod_desti
                FROM Desti
                WHERE ciutat_desti = par_ciutat_desti
            )
        );

BEGIN
    v_ciutat_desti := :v_ciutat_desti;
    if UPPER(v_ciutat_desti) NOT IN (
        SELECT ciutat_desti
        FROM Desti
    ) THEN
        RAISE EXCEPTION 'Error: la ciutat no existeix';
    END IF;
    OPEN curs_emptransport(UPPER(v_ciutat_desti));
    LOOP
        FETCH curs_emptransport INTO vr_emptransport;
        EXIT WHEN NOT FOUND;
        v_nif_emptransport := vr_emptransport.nif_emptransport;
        v_nom_emptransport := vr_emptransport.nom_emptransport;
        RAISE NOTICE 'L`empresa transportista amb nom % i % ha portat residus a la ciutat %', v_nom_emptransport, v_nif_emptransport, v_ciutat_desti;
    END LOOP;
    CLOSE curs_emptransport;
END $$;

/* Joc de proves */
/* En el meu programa dona igual si la ciutat esta escrita en minuscules o mayusculas ja que ho aceptara 
mentres el nom sigui exacta ja he utilitzat la funcio UPPER ja que totes les ciutats estan escritas en mayusculas*/
/*
v_ciutat_desti = 'BARCELONA'
m'ha donat correcta mostranme tota l'informacio*/

/* v_ciutat_desti = 'Japo'
m'ha donat error dien que la ciutat no existeix*/

/*Exercici 2 (3,5 punts). BBDD residus
Revisa els camps de la taula "RESIDU_CONSTITUENT". En aquesta taula es guarda la quantitat de residu-
constituent per cada empresa productora. Fes un programa PLPGSQL que modifiqui el camp QUANTITAT de la taula
"RESIDU_CONSTITUENT" del codi del residu que introduïm per teclat. També introduirem per teclat una número
que sumarem a la quantitat del residu per cada empresa productora.
Observacions:
- Has de crear una funció anomenada func_comprv_res que comprovarà si el codi del residu existeix a la taula
RESIDU_CONSTITUENT. Aquesta funció ha de retornar TRUE si el codi del residu existeix i FALSE si no existeix
utilitzant el bloc d’excepcions. Per evitar que la consulta retorni més d’una fila i salti l’excepció
TOO_MANY_ROWS limita el resultat de la consulta a la taula RESIDU_CONSTITUENT amb el LIMIT 1.
- Controla que la quantitat que s'introdueix per teclat no sigui negativa utilitzant una funció anomenada
func_comprv_quant.
- Crea un procediment anomenat proc_mod_quant que tingui com a paràmetres el codi del residu i la quantitat
que sumarem a la quantitat existent utilitzant el cursor. Aquest procediment primer comprovarà si el codi del residu
existeix, si no existeix es mostra el missatge corresponent, i si existeix es comprova si la quantitat que sumarem és
negativa, si és negativa es mostra el missatge corresponent, i si és positiva es realitzen les actualitzacions utilitzant un
cursor amb les clàusules FOR – IN ---.
-S’ha d’utilitzar una variable per guardar la nova quantitat i es farà servir en les sentències de modificació.
-La sortida s'ha de mostrar de la forma següent:
-La quantitat del residu 2030 amb constituent 9916 de l`empresa A-12000038
s`ha modificat. L`anterior quantitat era 27 i ara la quantitat és 32
-La quantitat del residu 2030 amb constituent 9916 de l`empresa A-12000057
s`ha modificat. L`anterior quantitat era 32 i ara la quantitat és 37
-La quantitat del residu 2030 amb constituent 9916 de l`empresa A-12000077
s`ha modificat. L`anterior quantitat era 118 i ara la quantitat és 123
........
- Fes el joc de proves fent crides directament al procediment passant el paràmetres. */

CREATE OR REPLACE FUNCTION func_comprv_res (p_cod_residu DECIMAL(6)) RETURNS BOOLEAN AS $$
DECLARE
    v_cod_residu DECIMAL(6);
BEGIN
    SELECT cod_residu INTO STRICT v_cod_residu
    FROM Residu_constituent
    WHERE cod_residu = p_cod_residu
    LIMIT 1;
    RETURN FALSE;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN TRUE;
    WHEN TOO_MANY_ROWS THEN
        RAISE EXCEPTION 'Error: retorna més files';
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error general';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION func_comprv_quant (p_quantitat DECIMAL(6)) RETURNS BOOLEAN AS $$
BEGIN
    IF p_quantitat < 0 THEN
        RETURN TRUE;
    END IF;
    RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE proc_mod_quant (p_cod_residu DECIMAL(6), p_quantitat DECIMAL(6)) AS $$
DECLARE
    v_cod_residu DECIMAL(6);
    v_info_residu RECORD;
    v_nova_quantitat DECIMAL(6);
    curs_residu_constituent CURSOR (p_cod_residu DECIMAL(6)) FOR
        SELECT nif_empresa, cod_constituent, quantitat
        FROM Residu_constituent
        WHERE cod_residu = p_cod_residu;
BEGIN
    v_cod_residu := p_cod_residu;
    IF func_comprv_res(v_cod_residu) THEN
        RAISE EXCEPTION 'Error: el codi del residu no existeix';
    END IF;
    IF func_comprv_quant(p_quantitat) THEN
        RAISE EXCEPTION 'Error: la quantitat no pot ser negativa';
    END IF;
    FOR v_info_residu IN curs_residu_constituent(v_cod_residu) LOOP
        v_nova_quantitat := v_info_residu.quantitat + p_quantitat;
        UPDATE Residu_constituent
        SET quantitat = v_nova_quantitat
        WHERE nif_empresa = v_info_residu.nif_empresa AND cod_constituent = v_info_residu.cod_constituent AND cod_residu = v_cod_residu;
        RAISE NOTICE 'La quantitat del residu % amb constituent % de l`empresa % s`ha modificat. L`anterior quantitat era % i ara la quantitat és %', v_cod_residu, v_info_residu.cod_constituent, v_info_residu.nif_empresa, v_info_residu.quantitat, v_nova_quantitat;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

/* Joc de proves */
/* call proc_mod_quant(2030, 5);
m'ha funcionat perfecta modificat la cuantitat de els que tenen el cod_residu = 2030 */
/*call proc_mod_quant(2030, -5);
fent aquest joc de proves em dona l'error de la quantitat no pot ser negativa*/
/*call proc_mod_quant(100, 5);
fet servir aquest joc de proves em dona l'error de que el codi del residu no existeix*/



/* Exercici 3 (2 punts). BBDD HR
Primer creem una nova taula anomenada MYEMPS a partir de la taula EMPLOYEES:
CREATE TABLE MYEMPS AS
SELECT * FROM EMPLOYEES;
Crear un trigger anomenat "trig_emps_dept" a la taula MYEMPS per impedir que el número de treballadors
d'un departament concret no sigui més gran de 30.
Serà necessari distingir si es tracta d'una inserció o una modificació.
• Abans d'inserir o modificar s'haurà de comptar quants treballadors té el nou departament del treballador
que es vol inserir o modificar i es guarda el resultat en una variable.
• Si es tracta d'inserir un empleat i el número de treballadors resultants del departament és més gran de
30 no es pot realitzar l'operació d'inserció o la modificació i es llança una excepció RAISE
EXCEPTION amb el missatge: 'Error: No es pot insertar l`empleat amb codi
<EMPLOYEE_ID> doncs el número de treballadors del departament
<DEPARTMENT_ID> no pot ser mes gran de 30',.

• Si es tracta de modificar el departament d'un empleat i el número de treballadors resultants de la
modificació el departament és més gran de 30 no es pot realitzar l'operació de modificació i es llança
una excepció RAISE EXCEPTION amb el missatge: 'Error: No es pot modificar
l`empleat amb codi <EMPLOYEE_ID> doncs el número de treballadors del
departament <DEPARTMENT_ID> no pot ser mes gran de 30',.
• Escriu el joc de proves que has fet per provar el trigger "trig_emps_dept".*/
CREATE TABLE MYEMPS AS
SELECT * FROM EMPLOYEES;

CREATE OR REPLACE FUNCTION trig_emps_dept() RETURNS TRIGGER AS $$
DECLARE
    v_num_emps_dept NUMERIC(6);
BEGIN
    IF TG_OP = 'INSERT' THEN
        SELECT COUNT(*) INTO STRICT v_num_emps_dept
        FROM MYEMPS
        WHERE department_id = NEW.department_id;
        IF v_num_emps_dept >= 30 THEN
            RAISE EXCEPTION 'Error: No es pot insertar l`empleat amb codi % doncs el número de treballadors del departament % no pot ser mes gran de 30', NEW.employee_id, NEW.department_id;
        END IF;
    ELSIF TG_OP = 'UPDATE' THEN
        SELECT COUNT(*) INTO STRICT v_num_emps_dept
        FROM MYEMPS
        WHERE department_id = NEW.department_id;
        IF v_num_emps_dept >= 30 THEN
            RAISE EXCEPTION 'Error: No es pot modificar l`empleat amb codi % doncs el número de treballadors del departament % no pot ser mes gran de 30', NEW.employee_id, NEW.department_id;
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trig_emps_dept
BEFORE INSERT OR UPDATE ON MYEMPS
FOR EACH ROW
EXECUTE PROCEDURE trig_emps_dept();

/* Joc de proves */
/* 
INSERT INTO MYEMPS VALUES (300, 'Jordi', 'Sancho', 'jsancho', '123456789', '01/01/2020', 'IT_PROG', 1000, 0.1, 100, 80);
Em dona l'error del trigger dient que no es pot inseri aquest empleat ja que el departament 80 te mes de 30 empleats*/

/* 
INSERT INTO MYEMPS VALUES (300, 'Jordi', 'Sancho', 'jsancho', '123456789', '01/01/2020', 'IT_PROG', 1000, 0.1, 100, 100);
Aquest insert es fa correctament ja que en el departament 100 no hi han mes de 30 empleats*/

/*
UPDATE MYEMPS SET department_id = 50 WHERE employee_id = 300;
Em dona l'error del trigger dient que no es pot modificar aquest empleat ja que el departament 50 te mes de 30 empleats*/

/*
UPDATE MYEMPS SET department_id = 90 WHERE employee_id = 300;
Aquest update es fa correctament ja que en el departament 90 no hi han mes de 30 empleats*/

/*Exercici 4 (1,5 punts). BBDD HR
Crea una taula auxiliar anomenada "BAIXAEMPS" amb la següent estructura:
CREATE TABLE BAIXAEMPS(
EMPLOYEE_ID NUMERIC(6,0) PRIMARY KEY,
MANAGER_ID NUMERIC(6,0),
SALARY NUMERIC(8,2),
DATA_BAIXA TIMESTAMP(6) NOT NULL,
USUARI TEXT NOT NULL);
Aquesta taula creada ens servirà per auditar les eliminacions de la taula empleats. Per fer-ho crea un trigger anomenat
"trig_elim_emps" que insereixi una fila a la taula "BAIXAEMPS" quan s'elimini una fila a la taula MYEMPS.
Les dades que s'insereixen a la taula "BAIXAEMPS" són les corresponents a l'empleat que s'ha de donat de baixa en
la taula MYEMPS. En el camp DATA_BAIXA es registrarà la variable data actual amb la funció NOW().
Escriu un joc de proves per provar el trigger "trig_elim_emps". Prova d'eliminar un empleat que no sigui
mànager d'altres empleats per evitar violar la regla de referència a clau forana,elimina un empleat que no es trobi com
a MANAGER_ID a la taula EMPLOYEES. Per exemple l'empleat amb codi 197, o 169. */

CREATE TABLE BAIXAEMPS(
    EMPLOYEE_ID NUMERIC(6,0) PRIMARY KEY,
    MANAGER_ID NUMERIC(6,0),
    SALARY NUMERIC(8,2),
    DATA_BAIXA TIMESTAMP(6) NOT NULL,
    USUARI TEXT NOT NULL
);

CREATE OR REPLACE FUNCTION trig_elim_emps() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO BAIXAEMPS VALUES (OLD.employee_id, OLD.manager_id, OLD.salary, NOW(), CURRENT_USER);
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trig_elim_emps
BEFORE DELETE ON MYEMPS
FOR EACH ROW
EXECUTE PROCEDURE trig_elim_emps();

/* Joc de proves */

/* 
DELETE FROM MYEMPS WHERE employee_id = 300;
s'executa perfectament i dins la taula es mostre la seguent informacio:
Employe id : 300
Manager id: 100
Salari: 1000.00
Data_Baixa: 2024-01-25 09:34:32.497315
Usuari: gmgjjybp */

/* 
DELETE FROM MYEMPS WHERE employee_id = 197;
s'exectua perfectament i dins la taula es mostre la seguent informacio:
Employe id : 197
Manager id: 124
Salari: 3000.00
Data_Baixa: 2024-01-25 09:37:38.235877
Usuari: gmgjjybp */