/* Exercici 1. Programar un bloc anònim que mostri les següents dades de tots els empleats: codi, nom, salari,
comissió i data d’alta. Si la comissió és nula s’ha de mostrar 0. Aquest exercici s’ha de fer amb la clàusula:
a) OPEN, FETCH, CLOSE i utilitzar una variable tipus %ROWTYPE
b) FOR ... IN ...*/

-- Exercici a
DO $$
DECLARE
    c_empleats CURSOR FOR
        SELECT * FROM employees;
    vr_empleats employees%ROWTYPE;
BEGIN
    OPEN c_empleats;
    LOOP
        FETCH c_empleats INTO vr_empleats;
        EXIT WHEN not found;
        IF vr_empleats.commission_pct IS NULL THEN
            vr_empleats.commission_pct := 0;
        END IF;
        RAISE NOTICE 'Codi: % ', vr_empleats.employee_id;
        RAISE NOTICE 'Nom: % ', vr_empleats.first_name;
        RAISE NOTICE 'Salari: % ', vr_empleats.salary;
        RAISE NOTICE 'Comissió: % ', vr_empleats.commission_pct;
        RAISE NOTICE 'Data d alta: %', vr_empleats.hire_date;
        RAISE NOTICE ' ';
    END LOOP;
    CLOSE c_empleats;
END;
$$ LANGUAGE plpgsql;

-- Exercici b
DO $$
DECLARE
    c_empleats CURSOR FOR
        SELECT * FROM employees;
BEGIN
    FOR vr_empleats IN c_empleats LOOP
        IF vr_empleats.commission_pct IS NULL THEN
            vr_empleats.commission_pct := 0;
        END IF;
        RAISE NOTICE 'Codi: % ', vr_empleats.employee_id;
        RAISE NOTICE 'Nom: % ', vr_empleats.first_name;
        RAISE NOTICE 'Salari: % ', vr_empleats.salary;
        RAISE NOTICE 'Comissió: % ', vr_empleats.commission_pct;
        RAISE NOTICE 'Data d alta: %', vr_empleats.hire_date;
        RAISE NOTICE ' ';
    END LOOP;
END;
$$ LANGUAGE plpgsql;

/*Exercici 2. Programar un bloc anònim que mostri els empleats que tinguin el salari més gran al valor que
s’introdueix per teclat. S’ha de controlar mitjançant una funció anomenada func_control_neg si el salari
que s’introdueix per teclat és negatiu o no. En cas de que no sigui negatiu s’ha de mostrar el codi, nom i salari
de cada empleat, en cas contrari s’ha d’imprimir “ERROR: salari negatiu i ha de ser positiu”. Aquest exercici
s’ha de fer amb la clàusula:
a) OPEN, FETCH, CLOSE i utilitzar una variable tipus %ROWTYPE
b) FOR ... IN ...*/

CREATE OR REPLACE FUNCTION func_control_neg(i_number NUMERIC) RETURNS BOOLEAN AS $$
BEGIN
    IF i_number < 0 THEN
        RAISE NOTICE 'ERROR: salari negatiu i ha de ser positiu';
        RETURN FALSE;
    ELSE
        RETURN TRUE;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Exercici a
DO $$
DECLARE
    var_salari NUMERIC = :vsalari;
    c_empleats CURSOR FOR
        SELECT * FROM employees WHERE salary > var_salari;
    var_empleats employees%ROWTYPE;
BEGIN
    IF func_control_neg(var_salari) THEN
        OPEN c_empleats;
        LOOP
            FETCH c_empleats INTO var_empleats;
            EXIT WHEN not found;
            RAISE NOTICE 'Codi: % ', var_empleats.employee_id;
            RAISE NOTICE 'Nom: % ', var_empleats.first_name;
            RAISE NOTICE 'Salari: % ', var_empleats.salary;
            RAISE NOTICE ' ';
        END LOOP;
        CLOSE c_empleats;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Exercici b
DO $$
DECLARE
    var_salari NUMERIC = :vsalari;
    c_empleats CURSOR FOR
        SELECT * FROM employees WHERE salary > var_salari;
BEGIN
    IF func_control_neg(var_salari) THEN
        FOR var_empleats IN c_empleats LOOP
            RAISE NOTICE 'Codi: % ', var_empleats.employee_id;
            RAISE NOTICE 'Nom: % ', var_empleats.first_name;
            RAISE NOTICE 'Salari: % ', var_empleats.salary;
            RAISE NOTICE ' ';
        END LOOP;
    END IF;
END;
$$ LANGUAGE plpgsql;

/*Exercici 3. Programar un bloc anònim que mostri les següents dades de tots els departaments: el nom, el
location_id i el nom de la ciutat on es troben. Aquest exercici s’ha de fer amb la clàusula:
a) OPEN, FETCH, CLOSE i utilitza només variables tipus %TYPE
b) FOR ... IN ...*/

-- Exercici a
DO $$
DECLARE
    c_departaments CURSOR FOR
        SELECT department_name, location_id FROM departments;
    var_departaments departments.department_name%TYPE;
    var_location_id locations.location_id%TYPE;
    var_city locations.city%TYPE;
BEGIN
    OPEN c_departaments;
    LOOP
        FETCH c_departaments INTO var_departaments, var_location_id;
        EXIT WHEN not found;
        SELECT city INTO var_city FROM locations WHERE location_id = var_location_id;
        RAISE NOTICE 'Nom: % ', var_departaments;
        RAISE NOTICE 'Location_id: % ', var_location_id;
        RAISE NOTICE 'Ciutat: % ', var_city;
        RAISE NOTICE ' ';
    END LOOP;
    CLOSE c_departaments;
END;
$$ LANGUAGE plpgsql;

-- Exercici b
DO $$
    DECLARE
        var_dep departments;
        var_dep_name departments.department_name%TYPE;
        var_loc_id departments.location_id%TYPE;
        var_city locations.city%TYPE;
        dep_cursor CURSOR FOR 
            SELECT * FROM departments;
    BEGIN
        FOR var_dep IN dep_cursor
        LOOP
            SELECT department_name INTO var_dep_name FROM departments WHERE department_id = var_dep.department_id;
            SELECT location_id INTO var_loc_id FROM departments WHERE department_id = var_dep.department_id;
            SELECT city INTO var_city FROM locations WHERE location_id = var_loc_id;
            RAISE NOTICE 'NOM: %, LOCATION ID: %, CITY: %',var_dep_name, var_loc_id, var_city;
        END LOOP;
    END;
$$ language plpgsql;

/*Exercici 4. Programar un bloc que mostri les següents dades de tots els empleats: codi i nom de l’empleat i codi i
nom del departament al que pertany. Aquest exercici s’ha de fer amb la clàusula:
a) OPEN, FETCH, CLOSE i utilitza una variable tipus RECORD.
b) FOR ... IN ...*/

-- Exercici a
DO $$
DECLARE
    c_empleats CURSOR FOR
        SELECT employee_id, first_name, department_id FROM employees;
    var_empleats RECORD;
    var_departament departments.department_name%TYPE;
BEGIN
    OPEN c_empleats;
    LOOP
        FETCH c_empleats INTO var_empleats;
        EXIT WHEN not found;
        SELECT department_name INTO var_departament FROM departments WHERE department_id = var_empleats.department_id;
        RAISE NOTICE 'Codi: % ', var_empleats.employee_id;
        RAISE NOTICE 'Nom: % ', var_empleats.first_name;
        RAISE NOTICE 'Codi departament: % ', var_empleats.department_id;
        RAISE NOTICE 'Nom departament: % ', var_departament;
        RAISE NOTICE ' ';
    END LOOP;
    CLOSE c_empleats;
END;
$$ LANGUAGE plpgsql;

-- Exercici b
DO $$
DECLARE
    c_empleats CURSOR FOR
        SELECT employee_id, first_name, department_id FROM employees;
    var_empleats RECORD;
    var_departament departments.department_name%TYPE;
BEGIN
    FOR var_empleats IN c_empleats LOOP
        SELECT department_name INTO var_departament FROM departments WHERE department_id = var_empleats.department_id;
        RAISE NOTICE 'Codi: % ', var_empleats.employee_id;
        RAISE NOTICE 'Nom: % ', var_empleats.first_name;
        RAISE NOTICE 'Codi departament: % ', var_empleats.department_id;
        RAISE NOTICE 'Nom departament: % ', var_departament;
        RAISE NOTICE ' ';
    END LOOP;
END;
$$ LANGUAGE plpgsql;
