

/*Exercici 1. Crea un bloc anònim que ha d'imprimir el cognom de l'empleat en majúscules amb codi
número 104 de la taula (EMPLOYEES), on has de declarar una variable de tipus last_name.*/

do $$
    declare
        apellido employees.last_name%type;
    begin
        select last_name into apellido
        from employees
        where employee_id = 104;

        raise notice 'El cognom del empleat 104 es: %', upper(apellido);
    end;
$$;


/*Exercici 2. Crea un bloc anònim que ha d'imprimir el cognom de l'empleat en majúscules
del id de l’empleat introdueixi per pantalla. .*/

do $$
    declare
        apellido employees.last_name%type;
    begin
        select last_name into apellido
        from employees
        where employee_id = :inputuser;

        raise notice 'El cognom del empleat 104 es: %', upper(apellido);
    end;
$$;

/*Exercici 3. Crea un bloc anònim amb variables PL/SQL que mostri el salari de
l'empleat amb id=120, has de declarar una variable de tipus salary.*/

do $$
    declare
        empleatsalari employees.salary%type;
    begin
        select salary into empleatsalari
        from employees
        where employee_id = 120;

        raise notice 'El salari del empleat numero 120 es: %', empleatsalari;
    end;
$$;


/*Exercici 4. Crea un bloc anònim amb una variable PL/SQL que imprimeixi el salari més alt dels
treballadors que treballen al departament 'SALES'.*/

do $$
    declare
        maxsalari employees.salary%type;
    begin
        select max(salary) into maxsalari
        from employees emp
        join departments dep on emp.department_id = dep.department_id
        where upper(department_name) = 'SALES';

        raise notice 'El salari mes al del departament de Sales es: %', maxsalari;
    end;
$$


/*Exercici 5. Crea un bloc anònim amb tres variables de tipus NUMBER. Aquestes variables
han de tenir un valor inicial de 15, 40 i 35 respectivament.
El bloc ha de sumar aquestes tres variables i mostrar per pantalla
‘LA SUMA TOTAL ÉS: (la suma de les variables)’.*/

do $$
    declare
        number1 numeric(2) = 15;
        number2 numeric(2) = 40;
        number3 numeric(2) = 35;
    begin
        raise notice 'LA SUMA TOTAL ÉS: %', number1+number2+number3;
    end;
$$

