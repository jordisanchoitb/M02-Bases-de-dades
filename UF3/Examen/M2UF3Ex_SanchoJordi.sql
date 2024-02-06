/* Activitat 1 BBDD cemed*/

CREATE TYPE test_type1 AS (
    codi_test NUMERIC(20),
    codi_mostra NUMERIC(20),
    dni_pacient NUMERIC(9)
);

CREATE TYPE test_type2 AS (
    codi_test NUMERIC(20),
    dni_tecnic NUMERIC(9),
    codi_reac NUMERIC(20)
);

CREATE FUNCTION func_test_sel(par_data_resultat DATE) RETURNS test_type1 AS $$
DECLARE
    test test_type1;
    c_test CURSOR FOR
        SELECT codi_test, codi_mostra, dni_pacient
        FROM test t WHERE t.data_resultat = par_data_resultat;
BEGIN
    OPEN c_test;
    LOOP
        FETCH c_test INTO test;
        EXIT WHEN NOT FOUND;
        RETURN test;
    END LOOP;
    CLOSE c_test;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION func_test_sel(par_preu DECIMAL(8,2)) RETURNS test_type2 AS $$
DECLARE
    test test_type2;
    c_test CURSOR FOR
        SELECT codi_test, dni_tecnic, codi_reac
        FROM test t WHERE t.preu > par_preu;
BEGIN
    OPEN c_test;
    LOOP
        FETCH c_test INTO test;
        EXIT WHEN NOT FOUND;
        RETURN test;
    END LOOP;
    CLOSE c_test;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM func_test_sel('2015-05-23');
SELECT * FROM func_test_sel(125);

/* Exercici 2 BBDD cemed*/

CREATE OR REPLACE FUNCTION func_nivell_cons(p_consultori consultori.ubicacio%type) RETURNS VARCHAR(20) AS $$
DECLARE
    nivell numeric;
    c_visites CURSOR FOR 
    SELECT COUNT(*) 
    FROM visita 
    WHERE codi_cons = (SELECT codi_cons 
                        FROM consultori 
                        WHERE ubicacio = func_nivell_cons.p_consultori);
BEGIN
    OPEN c_visites;
    LOOP
        FETCH c_visites INTO nivell;
        EXIT WHEN NOT FOUND;
        IF nivell IS NULL THEN
            RAISE EXCEPTION 'No existeix el consultori';
        ELSIF nivell = 0 THEN
            RAISE EXCEPTION 'No sha realitzat cap visita en aquest consultori';
        END IF;
        IF nivell < 3 THEN
            RETURN 'El consultori te poca ocupacio';
        ELSIF nivell >= 3 AND nivell <= 4 THEN
            RETURN 'El consultori te una ocupacio normal';
        ELSE
            RETURN 'El consultori te una ocupacio alta';
        END IF;
    END LOOP;
    CLOSE c_visites;
END;
$$ LANGUAGE plpgsql;

SELECT func_nivell_cons('pis 4 porta 3');
SELECT * from func_nivell_cons('pis 2 porta 10');

/* Exercici 3 BBDD cemed*/

CREATE OR REPLACE PROCEDURE proc_info_pacients(p_dni_metge metge.dni_metge%type) AS $$
DECLARE
    v_info RECORD;
    v_dni_metge metge.dni_metge%type;
    c_pacients CURSOR FOR
        SELECT DISTINCT p.nom, p.cognom1
        FROM persona p, pacient pa, visita v
        WHERE p.dni = pa.dni_pacient AND pa.dni_pacient = v.dni_pacient AND v.dni_metge = proc_info_pacients.p_dni_metge;
BEGIN
    SELECT dni_metge INTO STRICT v_dni_metge from metge where dni_metge = p_dni_metge;
    FOR v_info IN c_pacients LOOP
        RAISE NOTICE 'Nom: %, Cognom: %', v_info.nom, v_info.cognom1;
    END LOOP;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE EXCEPTION 'No existeix el metge';
END;
$$ LANGUAGE plpgsql;

CALL proc_info_pacients(30995635);
CALL proc_info_pacients(30995999);

INSERT INTO persona VALUES (82344561,'Sara','Rius','Clavell','1967-11-15','654811345','srius@mail.cat');

INSERT INTO metge VALUES (82344561,'Dermatoleg');

CALL proc_info_pacients(82344561);

/*Exercici 4 BBDD cemed*/

CREATE OR REPLACE PROCEDURE proc_act_mostra(p_cognom1 persona.cognom1%type, p_data_extraccio mostra.data_extr%type) AS $$
DECLARE
    v_dni_pacient mostra.dni_pacient%type;
    v_data_extraccio mostra.data_extr%type;
    c_mostra CURSOR FOR
        SELECT p.dni_pacient, data_extr
        FROM mostra m, pacient p, persona per
        WHERE m.dni_pacient = p.dni_pacient AND cognom1 = p_cognom1;
BEGIN
    OPEN c_mostra;
    LOOP
        FETCH c_mostra INTO v_dni_pacient, v_data_extraccio;
        EXIT WHEN NOT FOUND;
        IF v_dni_pacient IS NULL THEN
            RAISE EXCEPTION 'No existeix el pacient';
        ELSIF p_data_extraccio < '2001-01-01' THEN
            RAISE EXCEPTION 'La data no pot ser anterior al 1 de gener del 2001';
        ELSIF p_data_extraccio > '2021-12-31' THEN
            RAISE EXCEPTION 'La data no pot ser posterior al 31 de desembre del 2021';
        ELSE
            UPDATE mostra SET data_extr = p_data_extraccio WHERE dni_pacient = v_dni_pacient;
        END IF;
    END LOOP;
    CLOSE c_mostra;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE EXCEPTION 'No existeix el pacient';
END;
$$ LANGUAGE plpgsql;

CALL proc_act_mostra('Rocafort', '1998-01-01');
CALL proc_act_mostra('Barranco', '2001-01-01');
CALL proc_act_mostra('Rocafort', '2002-01-01');


/* Exercici 5 BBDD cemed*/
CREATE OR REPLACE FUNCTION func_control_vista() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.data_visita > CURRENT_DATE THEN
        RAISE EXCEPTION 'La data de la visita no pot ser posterior a la data actual';
    ELSIF OLD.preu <> NEW.preu THEN
        RAISE EXCEPTION 'No es pot modificar el preu de la vista amb codi %', OLD.codi_visita;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trig_control_vista 
BEFORE INSERT OR UPDATE ON visita 
FOR EACH ROW 
EXECUTE PROCEDURE func_control_vista();

INSERT INTO visita VALUES (003843295776,38702444,30995635,000032,'https://www.cemedioc.cat/informes/pdfs/003843295776.pdf','2024-01.06', 125);

UPDATE visita SET preu = 130 WHERE codi_visita = 00079990991;

/* Exercici 6 BBDD cemed*/

CREATE TABLE IF NOT EXISTS reactius_log (
    codi_reac NUMERIC(20) ,
    usuari VARCHAR(20) ,
    hora_modificacio TIMESTAMP ,
    operacio VARCHAR(20)
);

CREATE OR REPLACE FUNCTION func_ops_reactius_log() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO reactius_log VALUES (OLD.codi_reac, session_user, CURRENT_TIMESTAMP, TG_OP);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trig_audit_reactius
AFTER INSERT OR UPDATE OR DELETE ON reactiu
FOR EACH ROW
EXECUTE PROCEDURE func_ops_reactius_log();

INSERT INTO reactiu VALUES (88445556783015, 'EagleTaqPlus', 'B86910650', 145.4);

UPDATE reactiu SET preu = 42.3 WHERE codi_reac = 7799467889003033;

DELETE FROM reactiu WHERE codi_reac = 468678899922104;

SELECT * FROM reactius_log;

/* Exercici 7 BBDD training*/
CREATE OR REPLACE VIEW vista_clients_bill AS
SELECT c.num_clie, c.empresa, c.limite_credito
FROM clientes c, repventas r
WHERE c.rep_clie = r.num_empl AND r.nombre = 'Bill Adams';

CREATE OR REPLACE RULE vista_clients_bill_insert AS ON INSERT TO vista_clients_bill DO INSTEAD
INSERT INTO clientes VALUES (NEW.num_clie, NEW.empresa, (SELECT num_empl FROM repventas WHERE nombre = 'Bill Adams'), NEW.limite_credito);

CREATE OR REPLACE RULE vista_clients_bill_delete AS ON DELETE TO vista_clients_bill DO INSTEAD
DELETE FROM clientes WHERE num_clie = OLD.num_clie;

CREATE OR REPLACE RULE vista_clients_bill_update AS ON UPDATE TO vista_clients_bill DO INSTEAD
UPDATE clientes SET num_clie = NEW.num_clie, empresa = NEW.empresa, rep_clie = (SELECT num_empl FROM repventas WHERE nombre = 'Bill Adams'), limite_credito = NEW.limite_credito WHERE num_clie = OLD.num_clie;

-- Joc de proves
INSERT INTO vista_clients_bill VALUES (9999, 'Cemed', 1000);
UPDATE vista_clients_bill SET empresa = 'Patata' WHERE num_clie = 9999;
DELETE FROM vista_clients_bill WHERE num_clie = 9999;
