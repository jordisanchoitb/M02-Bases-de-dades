/*Exercici 1. Programar un trigger anomenat trig_nom_departament_notnull que s’activarà quan el nom
del departament sigui null al donar d’alta un nou departament a la taula DEPARTMENTS. Si es dispara el trigger
s’ha de mostrar el missatge d’error: 'El nom del departament no pot ser nul'. Escriu el joc de
proves que has fet per provar el trigger.*/
CREATE OR REPLACE FUNCTION func_trig_nom_departament_notnull() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.department_name IS NULL THEN
        RAISE EXCEPTION 'El nom del departament no pot ser nul';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trig_nom_departament_notnull
BEFORE INSERT ON departments
FOR EACH ROW
EXECUTE PROCEDURE func_trig_nom_departament_notnull();

/*Joc de proves*/
/*insert correcta*/
INSERT INTO departments (department_id, department_name, manager_id, location_id) VALUES (300, NULL, 100, 1700);
/*insert que peta*/
INSERT INTO departments (department_id, department_name, manager_id, location_id) VALUES (300, 'IT', 100, 1700);



/*Exercici 2. Programar un trigger associat a la taula EMPLOYEES. El trigger s’anomenarà
trig_restriccions_emp i ha de controlar les següents situacions:
Quan inserim un nou empleat no pot tenir un salari negatiu.
Quan modifiquem les dades d’un empleat, si es modifica el camp salari, només es podrà incrementar i només si té
comissió al camp commission_pct. Mostra els missatges d’error corresponents quan es dispari el trigger i escriu el
joc de proves que has fet per provar el trigger.*/

CREATE OR REPLACE FUNCTION func_trig_restriccions_emp() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.salary < 0 THEN
        RAISE EXCEPTION 'El salari no pot ser negatiu';
    END IF;
    IF NEW.salary < OLD.salary THEN
        RAISE EXCEPTION 'El salari no pot ser inferior al que ja té';
    END IF;
    IF NEW.salary > OLD.salary THEN
        IF NEW.commission_pct IS NULL THEN
            RAISE EXCEPTION 'El salari no pot ser superior al que ja té';
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trig_restriccions_emp
BEFORE INSERT OR UPDATE ON employees
FOR EACH ROW
EXECUTE PROCEDURE func_trig_restriccions_emp();

/*Joc de proves*/
/*Aquest insert no petarà*/
INSERT INTO employees (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id) VALUES (300, 'Jordi', 'Sancho', 'jsancho', '123456789', '2019-01-01', 'IT_PROG', 1000, 0.1, 100, 90);
/*Aquest insert petarà*/
INSERT INTO employees (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id) VALUES (300, 'Jordi', 'Sancho', 'jsancho', '123456789', '2019-01-01', 'IT_PROG', 500, 0.1, 100, 90);
/*Aquest update no petarà*/
UPDATE employees SET salary = 1000 WHERE employee_id = 300;
/*Aquest update petarà*/
UPDATE employees SET salary = 500 WHERE employee_id = 300;

/*Exercici 3. Programar un trigger que comprovi que la comissió mai sigui més gran que el salari a l’hora d’inserir
un empleat. El trigger s’anomenarà trig_comissio. Mostra els missatges d’error corresponents quan es dispari el
trigger i escriu el joc de proves que has fet per provar el trigger.*/

CREATE OR REPLACE FUNCTION func_trig_comissio() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.commission_pct > NEW.salary THEN
        RAISE EXCEPTION 'La comissió no pot ser superior al salari';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trig_comissio
BEFORE INSERT OR UPDATE ON employees
FOR EACH ROW
EXECUTE PROCEDURE func_trig_comissio();

/*Joc de proves*/
/* Aquest Update no petarà*/
UPDATE employees SET commission_pct = 0.1 WHERE employee_id = 300;
/* Aquest Update petarà*/
UPDATE employees SET commission_pct = 1000 WHERE employee_id = 300;

/*Exercici 4. Programar un trigger associat a la taula EMPLOYEES que faci fallar qualsevol operació de
modificació del first_name o del codi de l’empleat o que suposi una pujada de sou superior al 10%. El trigger
s’anomenarà trig_errada_modificacio. Mostra els missatges d’error corresponents quan es dispari el
trigger i escriu el joc de proves que has fet per provar el trigger.*/

CREATE OR REPLACE FUNCTION func_trig_errada_modificacio() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.first_name <> OLD.first_name THEN
        RAISE EXCEPTION 'No es pot modificar el nom';
    END IF;
    IF NEW.employee_id <> OLD.employee_id THEN
        RAISE EXCEPTION 'No es pot modificar el codi de l''empleat';
    END IF;
    IF NEW.salary > OLD.salary*1.1 THEN
        RAISE EXCEPTION 'No es pot pujar el salari més d''un 10%';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trig_errada_modificacio
BEFORE UPDATE ON employees
FOR EACH ROW
EXECUTE PROCEDURE func_trig_errada_modificacio();

/*Joc de proves*/
UPDATE employees SET first_name = 'Jordi' WHERE employee_id = 100;
UPDATE employees SET employee_id = 300 WHERE employee_id = 100;
UPDATE employees SET salary = 1000 WHERE employee_id = 100;


/*Exercici 5. Programar un trigger anomenat trig_auditartaulaemp i que permeti auditar les operacions
d’inserció, actualització o d’esborrat de dades que es realitzaran a la taula EMPLOYEES. El resultat de
l’auditoria es guardarà a una nova taula de la base de dades anomenada RESAUDITAREMP. Les especificacions
que s’han de tenir en compte són les següents:
Crear la taula RESAUDITAREMP amb un únic camp anomenat RESULTAT VARCHAR(200).
Quan es produeixi qualsevol operació (inserció, esborrat i/o actualitzar) sobre la taula EMPLOYEES, s’inserirà
una fila en la taula RESAUDITAREMP. El contingut d’aquesta fila serà un String (cadena de caràcters) amb la
data i hora que s’ha fet l’operació sobre la taula (utilitza la funció NOW()) i el contingut de les variables
especials asociades al Trigger TG_NAME, TG_WHEN, TG_LEVEL, TG_OP . Per obtenir una sola cadena de
caràcters amb aquesta informació utilitza la funció CONCAT. Escriu el joc de proves que has fet per provar el
trigger. */

CREATE TABLE resauditaremp (
    resultat VARCHAR(200)
);

CREATE OR REPLACE FUNCTION func_trig_auditartaulaemp() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO resauditaremp VALUES (CONCAT('Data: ', NOW(), ' Trigger: ', TG_NAME, ' Nivell: ', TG_LEVEL, ' Operació: ', TG_OP));
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trig_auditartaulaemp
AFTER INSERT OR UPDATE OR DELETE ON employees
FOR EACH ROW
EXECUTE PROCEDURE func_trig_auditartaulaemp();

/*Joc de proves*/
INSERT INTO employees (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id) VALUES (300, 'Jordi', 'Sancho', 'jsancho', '123456789', '2019-01-01', 'IT_PROG', 1000, 0.1, 100, 90);
UPDATE employees SET salary = 1000 WHERE employee_id = 300;
DELETE FROM employees WHERE employee_id = 300;
SELECT * FROM resauditaremp;