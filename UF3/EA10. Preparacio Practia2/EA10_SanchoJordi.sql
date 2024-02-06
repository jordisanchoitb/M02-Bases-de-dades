/* Exercici 1 Crea un procediment que esborrarà els dos empleats més nous d’un departament que introduirem per pantalla.
Per fer aquest procediment has de tenir en compte:
Has de realitzar una funció on has de comprovar que el nom del departament existeix.
Per fer l’apartat anterior, has de fer servir les excepcions.
Hauràs de cridar les funció dins el procediment.
Quan s’executi el procediment mostrarà el següent missatge: "L`empleat FIRST_NAME, LAST_NAME, amb
id EMPLOYEE_ID serà eliminat.*/

CREATE OR REPLACE FUNCTION func_existeix_departament(par_nom_departament departments.department_name%TYPE)
RETURNS BOOLEAN AS $$
DECLARE
    reg_departament departments%ROWTYPE;
BEGIN
    SELECT * INTO reg_departament FROM departments WHERE department_name = par_nom_departament;
    RETURN TRUE;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN FALSE;
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Error desconegut: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE proc_esborra_empleats_nous(par_nom_departament departments.department_name%TYPE)
AS $$
DECLARE
    reg_empleats employees%ROWTYPE;
    curs_empleats CURSOR FOR SELECT * 
    FROM employees WHERE 
    department_id = (SELECT department_id FROM departments 
    WHERE department_name = par_nom_departament) 
    ORDER BY hire_date DESC limit 2;
BEGIN
    IF func_existeix_departament(par_nom_departament) THEN
        OPEN curs_empleats;
        LOOP
            FETCH curs_empleats INTO reg_empleats;
            EXIT WHEN NOT FOUND;
            RAISE NOTICE 'L''empleat %, %, amb id % sera eliminat', reg_empleats.first_name, reg_empleats.last_name, reg_empleats.employee_id;
            DELETE FROM employees WHERE employee_id = reg_empleats.employee_id;
        END LOOP;
        CLOSE curs_empleats;
    ELSE
        RAISE EXCEPTION 'El departament % no existeix', par_nom_departament;
    END IF;
END;
$$ LANGUAGE plpgsql;

/* Exerici 2 Volem crear un trigger que cada vegada que es realitzin canvis a la taula locations en el camp de city han de
quedar enregistrats. El pasos a seguir són: Crea la taula anomenada canvis_locations on registrarem els nous valors */
CREATE OR REPLACE TABLE canvis_locations (
    id INT GERERATED ALWAYS AS IDENTITY,
    location_id NUMERIC (11)  NOT NULL ,
    city_old VARCHAR(30) NOT NULL,
    city_new VARCHAR(30) NOT NULL,
    changed_on TIMESTAMP(6) NOT NULL 
);

/* Crea una funció de trigger anomenada func_registrar_canvis_loc() i el seu trigger corresponent anomenat
trig_registrar_canvis_loc que comprovi si el nou nom de la ciutat (city) és diferent de l’antic nom de ciutat, i si
és així, que faci un insert amb els valors corresponents a la taula canvis_locations. */

CREATE OR REPLACE FUNCTION func_registra_canvis_loc() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.city <> OLD.city THEN
        INSERT INTO canvis_locations (location_id, city_old, city_new, changed_on) 
            VALUES (NEW.location_id, OLD.city, NEW.city, now());
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trig_registra_canvis_loc
AFTER UPDATE ON locations
FOR EACH ROW
EXECUTE PROCEDURE func_registra_canvis_loc();

/* Crea també una funció anomenada func_registrar_canvis() que executarà el trigger anomenat
trig_gravar_operacions de tipus statement-level i que s'executarà després de les sentències UPDATE. La
funció executada per aquest trigger guardarà les següents dades de l'execució a la taula canvis.*/
CREATE OR REPLACE TABLE canvis (
    id serial,
    timestamp_ TIMESTAMP WITH TIME ZONE default now(),
    nom_trigger text,
    tipus_trigger text,
    nivell_trigger text,
    ordre text
);

CREATE OR REPLACE FUNCTION func_registrar_canvis() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO canvis (nom_trigger, tipus_trigger, nivell_trigger, ordre) 
        VALUES (TG_NAME, TG_WHEN, TG_LEVEL, TG_OP);
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trig_registrar_canvis
AFTER UPDATE ON employees
FOR EACH STATEMENT
EXECUTE PROCEDURE func_registrar_canvis();

/* Exercici 3  Crea un procediment anomenat proc_mostrar_emp_dept, que li passaràs com a paràmetre el nom d'un
departament i mostrarà l'ID, el nom i el cognom de l'empleat més antic del departament.
El procediment mostrarà el missatge: "L`empleat més antic del (DEPARTMENT_NAME) té l`ID
(EMPLOYEE_ID)i es diu (FIRST_NAME LAST_NAME)"
Per fer aquest procediment has de tenir en compte el següent:
Has de crear una funció anomenada func_emp_mes_antic qué retornarà una variable del tipus dades_emp_type
amb l'ID, nom i cognom de l’empleat més antic del departament que li passes el nom com a paràmetre.
Aquesta funció la cridaras des del procediment proc_mostrar_emp_dept.
Has de crear també una funció anomenada func_comprv_dep que comprovarà si el departament existeix a la
taula DEPARTMENTS. Aquesta funció ha de retornar TRUE si el departament existeix i FALSE si no existeix
utilitzant una excepció. Aquesta funció la cridaras en el procediment proc_mostrar_emp_dept que llançarà
una excepció amb el missatge "El departament no existeix" en cas que retorni FALSE i que cridarà la funció
func_emp_mes_antic si retorna TRUE. Realitza el joc de proves corresponent.*/

CREATE OR REPLACE TYPE dades_emp_type AS (
    id NUMERIC (11),
    nom VARCHAR(20),
    cognom VARCHAR(25)
);

CREATE OR REPLACE FUNCTION func_emp_mes_antic(par_nom_departament departments.department_name%TYPE)
RETURNS dades_emp_type AS $$
DECLARE
    reg_empleat employees%ROWTYPE;
    reg_dades_emp dades_emp_type;
BEGIN
    SELECT * INTO reg_empleat 
    FROM employees WHERE department_id = 
    (SELECT department_id FROM departments 
    WHERE department_name = par_nom_departament) 
    ORDER BY hire_date ASC LIMIT 1;
    reg_dades_emp.id = reg_empleat.employee_id;
    reg_dades_emp.nom = reg_empleat.first_name;
    reg_dades_emp.cognom = reg_empleat.last_name;
    RETURN reg_dades_emp;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION func_comprv_dep(par_nom_departament departments.department_name%TYPE)
RETURNS BOOLEAN AS $$
DECLARE
    reg_departament departments%ROWTYPE;
BEGIN
    SELECT * INTO reg_departament FROM departments WHERE department_name = par_nom_departament;
    RETURN TRUE;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN FALSE;
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Error desconegut: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE proc_mostrar_emp_dept(par_nom_departament departments.department_name%TYPE)
AS $$
DECLARE
    reg_dades_emp dades_emp_type;
BEGIN
    IF func_comprv_dep(par_nom_departament) THEN
        reg_dades_emp := func_emp_mes_antic(par_nom_departament);
        RAISE NOTICE 'L''empleat mes antic del % te l''Id % i es diu % %', par_nom_departament, reg_dades_emp.id, reg_dades_emp.nom, reg_dades_emp.cognom;
    ELSE
        RAISE EXCEPTION 'El departament % no existeix', par_nom_departament;
    END IF;
END;
$$ LANGUAGE plpgsql;

/*joc de proves*/
CALL proc_mostrar_emp_dept('IT');

/*Exercici 4
Crea un procediment anomenat proc_residus que li passarà com a paràmetre el codi de residu i un període de temps
(dues dates) i mostrarà els noms de les empreses productores, els diferents destins i les dates d'enviament d'aquest
residu durant aquest periode.
Per fer aquest procediment has de tenir en compte:
Que el codi del residu existeixi amb una funció anomendada func_comprv_residu.
Que la data d’inici no pot ser més nova que la data de fi. Per controlar-ho realitzarem una funció anomenada
func_comprv_data.
El procediment cridarà primer la funció func_comprv_residu. Si el residu no existeix mostrarà el missatge
corresponent, i si existeix cridarà la funció func_comprv_data. Si la data d'inici és més nova que la data final
mostrarà el missatge corresponent. Si la data d'inici és més antiga que la data final llavors mostrarà per cada
enviament el missatge: "El residu amb codi (COD_RESIDU), ha sigut generat per l`empresa amb nom
(NOM_EMPRESA) i transportat al destí (NOM_DESTI) la data (DATA_ENVIAMENT).
Realitza el joc de proves corresponent.*/

CREATE OR REPLACE FUNCTION func_comprv_residu(par_cod_residu residu.cod_residu%TYPE)
RETURNS BOOLEAN AS $$
DECLARE
    reg_residu residu%ROWTYPE;
BEGIN
    SELECT * INTO reg_residu FROM residu WHERE cod_residu = par_cod_residu;
    RETURN TRUE;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN FALSE;
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Error desconegut: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION func_comprv_data(par_data_inici trasllat.data_enviament%TYPE, par_data_final trasllat.data_enviament%TYPE)
RETURNS BOOLEAN AS $$
BEGIN
    IF par_data_inici > par_data_final THEN
        RETURN FALSE;
    ELSE
        RETURN TRUE;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE proc_residus(par_cod_residu residu.cod_residu%TYPE, par_data_inici trasllat.data_enviament%TYPE, par_data_final trasllat.data_enviament%TYPE)
AS $$
DECLARE
    reg_trasllat trasllat%ROWTYPE;
    reg_empresa empresaproductora%ROWTYPE;
    reg_desti desti%ROWTYPE;
    curs_trasllats CURSOR FOR 
    SELECT * FROM trasllat WHERE 
    cod_residu = par_cod_residu AND data_enviament BETWEEN par_data_inici AND par_data_final;
BEGIN
    IF func_comprv_residu(par_cod_residu) THEN
        IF func_comprv_data(par_data_inici, par_data_final) THEN
            OPEN curs_trasllats;
            LOOP
                FETCH curs_trasllats INTO reg_trasllat;
                EXIT WHEN NOT FOUND;
                SELECT * INTO reg_empresa FROM empresaproductora WHERE nif_empresa = reg_trasllat.nif_empresa;
                SELECT * INTO reg_desti FROM desti WHERE cod_desti = reg_trasllat.cod_desti;
                RAISE NOTICE 'El residu amb codi %, ha sigut generat per l''empresa amb nom % i transportat al desti % la data %', reg_trasllat.cod_residu, reg_empresa.nom_empresa, reg_desti.nom_desti, reg_trasllat.data_enviament;
            END LOOP;
            CLOSE curs_trasllats;
        ELSE
            RAISE EXCEPTION 'La data d''inici no pot ser mes nova que la data final';
        END IF;
    ELSE
        RAISE EXCEPTION 'El residu amb codi % no existeix', par_cod_residu;
    END IF;
END;
$$ LANGUAGE plpgsql;

/*joc de proves*/
CALL proc_residus(1, '2019-01-01', '2020-01-01');


/*Exercici 5
Crea un trigger anomenat trig_res_update que llançarà una excepció cada vegada que actualitzem la quantitat de
residu de la taula residu.
a. Si la quantitat de residu és més petita que l’actual, haurà de sortir un missatge que indiqui "La quantitat nova
no pot ser més petita que la quantitat actual". Aquest missatge fa referència a una excepció.
b. Has de crear un funció de trigger anomenada func_res_update que llançarà l’excepció.
c. El trigger és de tipus BEFORE i row-level per l'operació UPDATE.
d. Escriu el joc de proves per comprovar el funcionament del trigger.*/
CREATE OR REPLACE FUNCTION func_res_update() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.quantitat_residu < OLD.quantitat_residu THEN
        RAISE EXCEPTION 'La quantitat nova no pot ser mes petita que la quantitat actual';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trig_res_update
BEFORE UPDATE ON residu
FOR EACH ROW
EXECUTE PROCEDURE func_res_update();

/*joc de proves*/
UPDATE residu SET quantitat_residu = 1 WHERE cod_residu = 1;


/*Exercici 6
Crea un sol trigger que controli les operacions d'INSERT, UPDATE i DELETE a la taula
EMPRESAPRODUCTORA.
Si es dona d'alta un nova empresa i el nom és null es mostra el missatge "El nom de l'empresa no pot ser null" i no es
fa la inserció.
Si s'intenta actualitzar la ciutat de l'empresa amb un nom diferent es mostra el missatge "No es pot canviar el nom de
la ciutat"
i s'impedeix la actualització, i si s'intenta eliminar un registre es mostra el missatge "No està permés eliminar cap
registre. Realitza el joc de proves corresponent.*/
CREATE OR REPLACE FUNCTION func_empresaproductora() RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        IF NEW.nom_empresa IS NULL THEN
            RAISE EXCEPTION 'El nom de l''empresa no pot ser null';
        END IF;
    ELSIF TG_OP = 'UPDATE' THEN
        IF NEW.ciutat_empresa <> OLD.ciutat_empresa THEN
            RAISE EXCEPTION 'No es pot canviar el nom de la ciutat';
        END IF;
    ELSIF TG_OP = 'DELETE' THEN
        RAISE EXCEPTION 'No esta permés eliminar cap registre';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trig_empresaproductora
BEFORE INSERT OR UPDATE OR DELETE ON empresaproductora
FOR EACH ROW
EXECUTE PROCEDURE func_empresaproductora();

/*joc de proves*/
INSERT INTO empresaproductora (nif_empresa, nom_empresa, ciutat_empresa, activitat, aa_empresa) VALUES ('12345678A', null, 'ciutat1', 'activitat1', 'aa1');
INSERT INTO empresaproductora (nif_empresa, nom_empresa, ciutat_empresa, activitat, aa_empresa) VALUES ('12345678A', null, 'ciutat1', 'activitat1', 'aa1');
UPDATE empresaproductora SET ciutat_empresa = 'ciutat2' WHERE nif_empresa = '12345678A';
DELETE FROM empresaproductora WHERE nif_empresa = '12345678A';


