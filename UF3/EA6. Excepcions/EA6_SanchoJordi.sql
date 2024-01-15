/* Exercici 1. Programar un procediment anomenat proc_alta_dept que insereixi les dades d’un
departament a la taula corresponent. Aquestes dades les ha d’introduir l’usuari per teclat en un bloc anònim
PL/pgSQL que cridarà el procediment. Abans d’inserir el departament, en el bloc anònim s’ha de comprovar si
existeix o no el departament a la base de dades utilitzant la funció func_comprovar_dept descrita en
Exemples4. Excepcions. Si el departament ja existeix es mostra un missatge a l’usuari i no es dona d’alta el
departament. Programem també les funcions func_comprovar_mng i func_comprovar_loc per
comprovar també previament si existeix el mànager i la localització. En aquest cas el departament no s’inserterà
si el mànager o la localització no existeixen a les taules corresponents i es mostrarà el missatge corresponent
a l’usuari. Inclou el JOC DE PROVES que has utilitzat per provar el codi.*/

CREATE OR REPLACE FUNCTION func_comprovar_dept (p_dept_id NUMERIC) RETURNS BOOLEAN AS $$
DECLARE
    v_dept_id NUMERIC;
BEGIN
    SELECT department_id INTO STRICT v_dept_id FROM departments WHERE department_id = p_dept_id;
    RETURN TRUE;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN FALSE;
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error General';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION func_comprovar_mng (p_mng_id NUMERIC) RETURNS BOOLEAN AS $$
DECLARE
    v_mng_id NUMERIC;
BEGIN
    SELECT employee_id INTO STRICT v_mng_id FROM employees WHERE employee_id = p_mng_id;
    RETURN TRUE;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN FALSE;
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error General';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION func_comprovar_loc (p_loc_id NUMERIC) RETURNS BOOLEAN AS $$
DECLARE
    v_loc_id NUMERIC;
BEGIN
    SELECT location_id INTO STRICT v_loc_id FROM locations WHERE location_id = p_loc_id;
    RETURN TRUE;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN FALSE;
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error General';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE proc_alta_dept (p_dept_id NUMERIC, p_dept_name VARCHAR(30), p_mng_id NUMERIC, p_loc_id NUMERIC) AS $$
BEGIN
    IF func_comprovar_dept(p_dept_id) THEN
        RAISE EXCEPTION 'El departament ja existeix';
    ELSIF func_comprovar_mng(p_mng_id) = FALSE THEN
        RAISE EXCEPTION 'El mànager no existeix';
    ELSIF func_comprovar_loc(p_loc_id) = FALSE THEN
        RAISE EXCEPTION 'La localització no existeix';
    ELSE
        INSERT INTO departments VALUES (p_dept_id, p_dept_name, p_mng_id, p_loc_id);
        RAISE NOTICE 'Departament inserit correctament';
    END IF;
END;
$$ LANGUAGE plpgsql;

DO $$
DECLARE
    v_dept_id NUMERIC =: vdept_id;
    v_dept_name VARCHAR(30) =: vdept_name;
    v_mng_id NUMERIC =: vmng_id;
    v_loc_id NUMERIC =: vloc_id;
BEGIN
    CALL proc_alta_dept(v_dept_id, v_dept_name, v_mng_id, v_loc_id);
END;
$$ LANGUAGE plpgsql;

/* Joc de proves */
/*
vdept_id = 50
vdept_name = 'IT'
vmng_id = 1700
vloc_id = 100
Em salta la exepcio de que el departamen ja existeix ja que hi ha un departament amb la id 50

vdept_id = 500
vdept_name = 'IT'
vmng_id = 1700
vloc_id = 100
Em salta la exepcio de que no existeix el manager

vdept_id = 500
vdept_name = 'IT'
vmng_id = 205
vloc_id = 1701
Em salta la exepcio de que no existeix la localitzacio

vdept_id = 500
vdept_name = 'PROVA'
vmng_id = 100
vloc_id = 1000
Inserit correctament
*/

/*Exercici 2. Realitzar un programa que pregunti a l’usuari el codi de l’empleat per tal de retornar el nom de
l’empleat. El nom de l’empleat ho retornarà una funció que es crearà anomenada func_nom_emp. A aquesta
funció se li passarà per paràmetre el codi de l’empleat que l’usuari ha introduït per teclat. S’ha de controlar els
errors al bloc anònim utilitzant el SQLSTATE i incloure el JOC DE PROVES que has utilitzat.*/

CREATE OR REPLACE FUNCTION func_nom_emp (p_emp_id NUMERIC) RETURNS VARCHAR(25) AS $$
DECLARE
	v_emp_name VARCHAR(25);
BEGIN
	SELECT first_name INTO STRICT v_emp_name FROM employees WHERE employee_id = p_emp_id;
	RETURN v_emp_name;
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		RAISE EXCEPTION 'No existeix cap empleat amb aquesta id';
	WHEN OTHERS THEN
		RAISE EXCEPTION 'Error General';
END;
$$ LANGUAGE plpgsql;

DO $$
DECLARE
	v_emp_id NUMERIC =: vemp_id;
	v_emp_name VARCHAR(25);
BEGIN
	v_emp_name := func_nom_emp(v_emp_id);
	RAISE NOTICE 'El nom de l''empleat amb id % és %', v_emp_id, v_emp_name;
END;
$$ LANGUAGE plpgsql;

/* Joc de proves */
/*
vemp_id = 100
El nom de l'empleat amb id 100 és Steven

vemp_id = 9999
No existeix cap empleat amb aquesta id
*/

/*Exercici 3. Realitzar un programa que ens comprovi si un departament existeix o no a la taula corresponent
consultant pel codi del departament. En cas d’existir el departament s’ha d’imprimir per pantalla i s’ha de comprovar
si comença o no per la lletra A. Si comença per la lletra A, després de mostrar el nom del departament, ha de mostrar
també el missatge: COMENÇA PER LA LLETRA A, i si no comença per la lletra A, ha de mostrar el missatge: NO
COMENÇA PER LA LLETRA A.
S’han de programar les següents excepcions:
• Si no hi ha dades, s’ha de retornar: “ERROR: no dades”.
• Si retorna més d’una fila: “ERROR: retorna més files”
• Qualsevol altre error: “ERROR (sense definir)”..
Inclou el JOC DE PROVES que has utilitzat.*/

CREATE OR REPLACE FUNCTION func_comprovar_dept (p_dept_id NUMERIC) RETURNS VARCHAR(30) AS $$
DECLARE
	v_dept_name VARCHAR(30);
BEGIN
	SELECT department_name INTO STRICT v_dept_name FROM departments WHERE department_id = p_dept_id;
	RETURN v_dept_name;
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		RAISE EXCEPTION 'ERROR: no dades';
	WHEN TOO_MANY_ROWS THEN
		RAISE EXCEPTION 'ERROR: retorna més files';
	WHEN OTHERS THEN
		RAISE EXCEPTION 'ERROR (sense definir)';
END;
$$ LANGUAGE plpgsql;

DO $$
DECLARE
	v_dept_id NUMERIC =: vdept_id;
	v_dept_name VARCHAR(30);
BEGIN
	v_dept_name := func_comprovar_dept(v_dept_id);
	RAISE NOTICE 'El departament amb id % és %', v_dept_id, v_dept_name;
	IF v_dept_name LIKE 'A%' THEN
		RAISE NOTICE 'COMENÇA PER LA LLETRA A';
	ELSE
		RAISE NOTICE 'NO COMENÇA PER LA LLETRA A';
	END IF;
END
$$ LANGUAGE plpgsql;

--Joc de proves
/*
vdept_id = 10
El departament amb id 10 és Administration
COMENÇA PER LA LLETRA A

vdept_id = 20
El departament amb id 20 és Marketing
NO COMENÇA PER LA LLETRA A

vdept_id = 9999
ERROR: no dades
*/


/*Exercici 4. Programa un procediment anomenat proc_loc_address per modificar l’adreça d’una localització a
la taula LOCATIONS. El bloc anònim demana a l’usuari el codi de la localització i la nova adreça i passarà aquestes
dades al procediment proc_loc_address. Abans de cridar el procediment s’ha de comprovar si el codi de la
localització existeix amb la funció func_comprovar_loc . Si no existeix es mostra un missatge a l ́usuari, i si
existeix es crida el procediment per modificar l’adreça.
Controla les excepcions corresponents i inclou el JOC DE PROVES que has utilitzat.*/

CREATE OR REPLACE FUNCTION func_comprovar_loc (p_loc_id NUMERIC) RETURNS BOOLEAN AS $$
DECLARE
	v_loc_id NUMERIC;
BEGIN
	SELECT location_id INTO STRICT v_loc_id FROM locations WHERE location_id = p_loc_id;
	RETURN TRUE;
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		RETURN FALSE;
	WHEN OTHERS THEN
		RAISE EXCEPTION 'Error General';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE proc_loc_address (p_loc_id NUMERIC, p_address VARCHAR(40)) AS $$
BEGIN
	IF func_comprovar_loc(p_loc_id) THEN
		UPDATE locations SET street_address = p_address WHERE location_id = p_loc_id;
		RAISE NOTICE 'Adreça modificada correctament';
	ELSE
		RAISE EXCEPTION 'La localització no existeix';
	END IF;
END;
$$ LANGUAGE plpgsql;

DO $$
DECLARE
	v_loc_id NUMERIC =: vloc_id;
	v_address VARCHAR(40) =: vaddress;
BEGIN
	CALL proc_loc_address(v_loc_id, v_address);
END;
$$ LANGUAGE plpgsql;

--Joc de proves
/*
vloc_id = 1000
vaddress = 'Carrer de la prova'
Adreça modificada correctament

vloc_id = 9999
vaddress = 'Carrer de la prova'
La localització no existeix
*/
