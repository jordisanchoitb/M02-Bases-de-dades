/* Exercici 1. Programar un bloc anònim que mostri el codi i el cognom dels empleats del departament que
s’introdueix el codi per teclat. Aquest exercici s’ha de fer amb un CURSORS AMB PARÀMETRES, i el paràmetre
que s’ha de passar és el codi de departament que l’usuari introdueixi per teclat. Aquest exercici s’ha de fer amb la
clàusula OPEN, FETCH, CLOSE i utilitzar una variable tipus registre.*/
DO $$
DECLARE
    var_departament_id departments.department_id%TYPE = :departament_id;
    curs_emps CURSOR FOR
        SELECT *
        FROM employees
        WHERE department_id = var_departament_id;
    var_empleats RECORD;
BEGIN
    OPEN curs_emps;
    LOOP
        FETCH curs_emps INTO var_empleats;
        EXIT WHEN NOT FOUND;
        RAISE NOTICE 'El codi de l''empleat es % i el cognom es %', var_empleats.employee_id, var_empleats.last_name;
    END LOOP;
    CLOSE curs_emps;
END;
$$ LANGUAGE plpgsql;

/*Exercici 2. Programar el mateix bloc anònim que l’exercici anterior però utilitza una funció anomenada
func_comp_dep per comprovar si es departament existeix i gestionant els possibles errors amb excepcions. Si el
departament existeix s’obre el cursor amb paràmetres per obtenir els empleats del departament, i si no existeix es
mostra el missatge 'El departament no existeix!'. Gestiona el cursor amb la clàusula FOR.*/
CREATE OR REPLACE FUNCTION func_comp_dep(par_departament_id departments.department_id%TYPE) RETURNS BOOLEAN AS $$
DECLARE
    var_departament_id departments.department_id%TYPE = par_departament_id;
BEGIN
    SELECT department_id
    FROM departments
    WHERE department_id = var_departament_id;
    RETURN TRUE;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE EXCEPTION 'El departament no existeix!';
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error general';
END;
$$ LANGUAGE plpgsql;

DO $$
DECLARE
    var_departament_id departments.department_id%TYPE = :departament_id;
    curs_emps CURSOR FOR
        SELECT *
        FROM employees
        WHERE department_id = var_departament_id;
    var_empleats RECORD;
BEGIN
    IF func_comp_dep(var_departament_id) THEN
        FOR var_empleats IN curs_emps LOOP
            RAISE NOTICE 'El codi de l''empleat es % i el cognom es %', var_empleats.employee_id, var_empleats.last_name;
        END LOOP;
    END IF;
END;
$$ LANGUAGE plpgsql;

/*Exercici 3. Programa una funció anomenada func_emps_dep que retorni tota la informació dels empleats del
departament que passem el codi per teclat. Busca en els exemples publicats al Classroom com fer-ho utilitzant
SETOF i RETURN NEXT, o bé SETOF i RETURN QUERY.*/
-- Utilizando RETURN NEXT
CREATE OR REPLACE FUNCTION func_emps_dep(par_departament_id departments.department_id%TYPE) RETURNS SETOF employees AS $$
DECLARE
    var_departament_id departments.department_id%TYPE = par_departament_id;
    var_empleats employees%ROWTYPE;
BEGIN
    FOR var_empleats IN SELECT *
        FROM employees
        WHERE department_id = var_departament_id LOOP
        RETURN NEXT var_empleats;
    END LOOP;
    RETURN;
END;
$$ LANGUAGE plpgsql;

-- Utilizando RETURN QUERY
CREATE OR REPLACE FUNCTION func_emps_dep(par_departament_id departments.department_id%TYPE) RETURNS SETOF employees AS $$
DECLARE
    var_departament_id departments.department_id%TYPE = par_departament_id;
BEGIN
    RETURN QUERY SELECT *
        FROM employees
        WHERE department_id = var_departament_id;
END;
$$ LANGUAGE plpgsql;

/*Exercici 4. Programar un bloc anònim que mostri els salaris dels empleats i que modifiqui tots els salaris
incrementant cada salari un 18 %. Els passos a seguir són els següents:
-Crear una nova taula anomenada EMP_NOU_SALARY que ha de contenir la mateixa estructura i registres
que la taula EMPLOYEES.
-Mitjançant un cursor anomenat curs_emps consultarem fila a fila les dades de la taula EMP_NOU_SALARY,
guardarem en una variable el nou salari incrementat un 18% el salari antic, mostrarem el cognom de cada
empleat, el seu salari antic i el salari nou de la següent manera: ‘El salari antic de l`empleat
«cognom_emplet» era «salari_antic» i el nou salari serà: «salari_nou»’ i
actualitzarem el camp SALARY amb el nou salari a la taula EMP_NOU_SALARY.
--Creació de la nova taula EMP_NOU_SALARY a partir de la taula EMPLOYEES:
CREATE TABLE EMP_NOU_SALARY AS
SELECT * FROM EMPLOYEES;*/

CREATE TABLE EMP_NOU_SALARY AS SELECT * FROM EMPLOYEES;

DO $$
DECLARE
    curs_emps CURSOR FOR
        SELECT *
        FROM EMP_NOU_SALARY;
    var_empleats EMP_NOU_SALARY%ROWTYPE;
    var_nou_salari EMP_NOU_SALARY.salary%TYPE;
BEGIN
    OPEN curs_emps;
    LOOP
        FETCH curs_emps INTO var_empleats;
        EXIT WHEN NOT FOUND;
        var_nou_salari := var_empleats.salary * 1.18;
        RAISE NOTICE 'El salari antic de l''empleat % era % i el nou salari serà: %', var_empleats.last_name, var_empleats.salary, var_nou_salari;
        UPDATE EMP_NOU_SALARY
        SET salary = var_nou_salari
        WHERE employee_id = var_empleats.employee_id;
    END LOOP;
    CLOSE curs_emps;
END;
$$ LANGUAGE plpgsql;

/*Exercici 5. Programar un bloc anònim que modifiqui totes les comissions dels empleats de la nova taula
creada en l’exercici anterior EMP_NOU_SALARY d’un departament on el codi de departament coincideix
amb el que s’introdueix per teclat. La modificació de la comissió consisteix en sumar 0.20 a la comissió antiga
en cas que la comissió no sigui nul·la. Si la comissió és nul·la la comissió s’actualitzarà a 0. En cas que el cursor
ja no tingui més files llançarem un missatge ‘El departament «codi_departament» ja no té
més empleats’. Has d’utilitzar un cursor amb paràmetres, la clàusula OPEN, FETCH, CLOSE, utilitzar una
variable tipus registre i gestionar els errors.*/
DO $$
DECLARE
    var_departament_id departments.department_id%TYPE = :departament_id;
    curs_emps CURSOR FOR
        SELECT *
        FROM EMP_NOU_SALARY
        WHERE department_id = var_departament_id;
    var_empleats EMP_NOU_SALARY RECORD;
BEGIN
    OPEN curs_emps;
    LOOP
        FETCH curs_emps INTO var_empleats;
        EXIT WHEN NOT FOUND;
        IF var_empleats.commission_pct IS NOT NULL THEN
            UPDATE EMP_NOU_SALARY
            SET commission_pct = var_empleats.commission_pct + 0.20
            WHERE employee_id = var_empleats.employee_id;
        ELSE
            UPDATE EMP_NOU_SALARY
            SET commission_pct = 0
            WHERE employee_id = var_empleats.employee_id;
        END IF;
    END LOOP;
    CLOSE curs_emps;
    RAISE NOTICE 'El departament % ja no té més empleats', var_departament_id;
END;
$$ LANGUAGE plpgsql;


/*Exercici 6. Crea una nova taula anomenada anomenada EMP_WITH_COMISS que ha de contenir la mateixa
estructura i registres que la taula EMPLOYEES . Crea un bloc anònim que utilitzi un cursor per eliminar de la
nova taula EMP_WITH_COMISS tots els empleats que no tenen comissió. Gestiona el cursor amb la clàusula
FOR. */
CREATE TABLE EMP_WITH_COMISS AS SELECT * FROM EMPLOYEES;

DO $$
DECLARE
    curs_emps CURSOR FOR
        SELECT *
        FROM EMP_WITH_COMISS
        WHERE commission_pct IS NULL;
    var_empleats EMP_WITH_COMISS%ROWTYPE;
BEGIN
    FOR var_empleats IN curs_emps LOOP
        DELETE FROM EMP_WITH_COMISS
        WHERE employee_id = var_empleats.employee_id;
    END LOOP;
END;
$$ LANGUAGE plpgsql;
