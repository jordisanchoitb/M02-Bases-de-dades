/*Exercici 1. Realitzar un procediment anomenat proc_baixa_emp que dongui de baixa un empleat, i
que tingui com a paràmetre l'id de l'empleat. S'ha de programar un bloc anònim que cridi el
procediment i se li passi com a paràmetre l'id de l'empleat que l'usuari introdueixi pel teclat.*/

create or replace procedure proc_baixa_emp (par_id_emp employees.employee_id%type)
AS $$
BEGIN
    DELETE FROM employees WHERE employee_id=par_id_emp;
END
$$ LANGUAGE plpgsql;

do $$
    declare
            v_numberid numeric = :"Donem la id de l'empleat que vols eliminar";
    begin
        CALL proc_baixa_emp(v_numberid);
    end;
$$;

/*Exercici 2. Realitzar un programa que contingui una funció que retorni quants empleats hi ha a un
departament. L'id del departament es passarà com a paràmetre de la funció. La funció s’anomenarà
func_num_emp i es cridarà des d’un bloc anònim o principal. El paràmetre que se li passa a la
funció se li preguntarà a l’usuari i per tant, s’ha d’introduir pel teclat.*/

CREATE OR REPLACE FUNCTION func_num_emp (par_id_dept departments.department_id%type) RETURNS numeric AS $$
    DECLARE
        resultat numeric;
    BEGIN
        SELECT COUNT(*) INTO resultat FROM employees WHERE department_id=par_id_dept;
        RETURN resultat;
    END;
$$ LANGUAGE plpgsql;

do $$
    declare
        v_numberid numeric = :"Donem la id del departament";
    begin
        select func_num_emp(v_numberid);
    end;
$$;

/*Exercici 3. Realitzar un programa que contingui una funció anomenada func_cost_dept que retorni la
suma total dels salaris dels empleats d’un departament en concret. La funció es cridarà des d’un bloc
anònim o principal. El paràmetre que se li passa a la funció és l’id del departament i se li preguntarà a
l’usuari, i per tant, s’ha d’introduir pel teclat.*/

CREATE OR REPLACE FUNCTION func_cost_dept (par_id_dept departments.department_id%type) RETURNS numeric AS $$
    DECLARE
        resultat numeric;
    BEGIN
        SELECT SUM(salary) INTO resultat FROM employees WHERE department_id=par_id_dept;
        RETURN resultat;
    END;
$$ LANGUAGE plpgsql;

do $$
    declare
        v_numberid numeric = :"Donem la id del departament";
    begin
        select func_cost_dept(v_numberid);
    end;
$$;


/*Exercici 4. Realitzar un procediment anomenat proc_mod_com que modifiqui el valor de la comissió
d’un empleat que s’introdueixi l'id per teclat.
Per a modificar aquesta comissió hem de tenir en compte que:
• Si el salari és menor a 3000, la nova comissió és 0.1.
• Si el salari està entre 3000 i 7000, la nova comissió és 0.15.
• Si el salari és més gran que 7000, la nova comissió és 0.2.
S'ha de programar un bloc anònim que cridi el procediment*/

CREATE OR REPLACE PROCEDURE proc_mod_com (par_id_emp employees.employee_id%type) AS $$
    DECLARE
        v_salary employees.salary%type;
        v_commission employees.commission_pct%type;
    BEGIN
        SELECT salary INTO v_salary FROM employees WHERE employee_id=par_id_emp;
        IF v_salary < 3000 THEN
            v_commission = 0.1;
        ELSIF v_salary >= 3000 AND v_salary <= 7000 THEN
            v_commission = 0.15;
        ELSE
            v_commission = 0.2;
        END IF;
        UPDATE employees SET commission_pct=v_commission WHERE employee_id=par_id_emp;
    END;
$$ LANGUAGE plpgsql;

do $$
    declare
        v_numberid numeric = :"Donem la id de l'empleat";
    begin
        CALL proc_mod_com(v_numberid);
    end;
$$;

