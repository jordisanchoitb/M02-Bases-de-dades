/*Exercici 1. Realitzar un programa que contingui una funció que dupliqui la quantitat rebuda com a
paràmetre. La funció rebrà el nom de FUNC_DUPLICAR_QUANTITAT. S’ha de programar un bloc
principal que demani per teclat la quantitat i que cridi a la funció FUNC_DUPLICAR_QUANTITAT
passant el paràmetre corresponent.*/

CREATE OR REPLACE FUNCTION FUNC_DUPLICAR_QUANTITAT (usernumber decimal(10,2))
RETURNS decimal
AS $$
    DECLARE
        resultat DECIMAL(10, 2);
    BEGIN
        resultat = usernumber*2;
        RETURN resultat;
    END;
$$ LANGUAGE plpgsql;

select FUNC_DUPLICAR_QUANTITAT(2);


/*Exercici 2. Realitzar un programa que contingui una funció que calculi el factorial d’un número que
es passa com a paràmetre. La funció rebrà el nom de FUNC_FACTORIAL. S’ha de programar un
bloc principal que pregunti a l’usuari pel número a calcular i cridi a la funció FUNC_FACTORIAL,
passant el paràmetre corresponent.*/

CREATE OR REPLACE FUNCTION FUNC_FACTORIAL (usernumber numeric)
RETURNS numeric
AS $$
    DECLARE
        resultat numeric;
        count numeric;
    BEGIN
        resultat = 1;
        count = usernumber;
        WHILE count > 0 LOOP
            resultat = resultat * count;
            count = count - 1;
        END LOOP;
        RETURN resultat;
    END;
$$ LANGUAGE plpgsql;

select FUNC_FACTORIAL(5);



/*Exercici 3. Realitzar un procediment que s’anomeni PROC_EMP_INFO i que es passi com a paràmetre
l’Id d’un empleat i mostri el seu ID, el seu nom, el seu càrrec (job_title) i el seu salari. Has de canviar els
nom de les columnes perquè sigui (codi_empleat, nom_empleat, càrrec, salari). Per realitzar aquest
exercici has de fer servir una variable de tipus %rowtype. S’ha de programar un bloc principal que
pregunti a l’usuari pel ID de l’empleat i cridi al procediment PROC_EMP_INFO, passant el paràmetre
corresponent.*/

CREATE OR REPLACE PROCEDURE PROC_EMP_INFO(empleatid numeric)
AS $$
DECLARE
    resultat employees%rowtype;
    jobtitle varchar(35);
BEGIN
    SELECT * INTO resultat FROM employees WHERE employee_id = empleatid;
    SELECT job_title INTO jobtitle FROM jobs WHERE job_id=resultat.job_id;
    RAISE NOTICE 'codi_empleat: %, nom_empleat: %, carrec: %, salari: %',
                 resultat.employee_id, resultat.first_name, jobtitle, resultat.salary;
END
$$ LANGUAGE plpgsql;

do $$
    declare
        numberid numeric = :"Donem la id de l'empleat";
    begin
        CALL PROC_EMP_INFO(numberid);
    end;
$$;


/*Exercici 4. Realitzar un programa que contingui un procediment anomenat PROC_ALTA_JOB que doni
d’alta un nou ofici (JOB) a la taula jobs. Totes les dades del nou ofici s’han de passat com com a
paràmetre. S’ha de programar un bloc principal que pregunti a l’usuari totes les dades del nou ofici i cridi
el procediment PROC_ALTA_JOB. Abans d’inserir s’ha de comprovar que el valor màxim i mínim del
salari no sigui negatiu i a més, que el salari mínim sigui més petit que el salari màxim. Mostra els
missatges d’error corresponents.*/

CREATE OR REPLACE PROCEDURE PROC_ALTA_JOB(jobid varchar(10), jobtitle varchar(35), minsalary numeric, maxsalary numeric)
AS $$
BEGIN
    insert into jobs values (jobid, jobtitle, minsalary, maxsalary);
END
$$ LANGUAGE plpgsql;

do $$
    DECLARE
        jobid varchar(10) := :'Donem el id del job (Posa la id entre cometes simples '')';
        jobtitle varchar(35) := :'Donem el titol del job (Posa el titol entre cometes simples '')';
        minsalary numeric := :'Donem el salari minim del job';
        maxsalary numeric := :'Donem el salari maxim del job';
    begin
        if minsalary < 0 OR maxsalary < 0 then
            raise notice 'El numero del salari no pot ser negatiu';
        else
            if minsalary > maxsalary then
                raise notice 'El salari minim no pot ser mes gran que el salari maxim';
            else
                CALL PROC_ALTA_JOB(jobid, jobtitle, minsalary, maxsalary);
            end if;
        end if;
    end;
$$;


