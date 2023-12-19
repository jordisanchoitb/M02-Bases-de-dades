/*Exercici 1 (2 punts)
Programar un bloc anònim PL/SQL que demani a l’usuari dos números. Aquests dos números se’ls assigna a
dos variables PL/SQL. Els dos números han de ser positius, en cas contrari s’ha de donar a l’usuari el missatge
d'error corresponent. S’ha de realitzar una operació amb aquest números: multiplicar el primer número per si
mateix les vegades que indiqui el segon número. El resultat s’ha d’assignar a una variable PL/SQL i després
mostrar-lo a l’usuari utilitzant la variable. Has d’utilitzar una estructura de control de fluxe.*/

do $$
    DECLARE
        vnum1 NUMERIC = :'Donem un numero';
        vnum2 NUMERIC = :'Donem un altre numero';
        var_resultat numeric=1;
    begin
        if vnum1 < 0 or vnum2 < 0 then
            RAISE NOTICE 'El dos numeros tenen que ser positius';
        else
            for i in 1..vnum2 loop
                var_resultat = var_resultat * vnum1;
            end loop;
            RAISE NOTICE 'El resultat es: %', var_resultat;
        end if;
    end
$$;

/*Exercici 2 (2 punts)
Programar un bloc anònim PL/SQ que sigui capaç de calcular l’àrea d’una circumferència. S'ha de tenir el
compte que:
a) El radi serà introduït per l’usuari
b) La formula per calcular l’àrea d’una circumferència és la següent : Àrea = r2 * π (π= 3.1416)
c) S'ha de controlar que el número introduït sigui positiu amb una funció que s’anomenarà func_checkP.
Si el número no és positiu hem de retornar l’error: “Recorda que el número ha de ser positiu!!!”
d) El cálcul de l'Àrea el farà una altra funció anomenda func_calculArea que utilitzarà la funció
func_checkP per comprovar que el radi sigui positiu. Si el radi introduït és positiu es calcularà l’Àrea i
es retornarà el seu valor, si el radi no és positu el valor que retornarà la funció func_calculArea serà 0.
e) El bloc anònim demanarà el radi a l'usuari, cridarà la funció func_calculArea i mostrarà el següent
missatge per pantalla “Àrea de la circumferència de radi <r> és <a>”, on <r> és el valor introduït per
l’usuari i <a> el valor que hem calculat. Aquest missatge només es mostrarà en cas que el valor que
torni la funció func_calculArea sigui més gran que 0.
f) S'ha d'utilitzar una variable PL/SQL constant per guardar el valor de π, una variable PL/SQL per
guardar el radi introduit per l'usuari, una variable PL/SQL per guardar el càlcul del Àrea.*/

CREATE OR REPLACE FUNCTION func_checkP (par_number numeric) RETURNS boolean AS $$
    BEGIN
        if par_number < 0 then
            raise notice 'Recorda que el número ha de ser positiu!!!';
            return false;
        end if;
        return true;
    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION func_calculArea (par_radi numeric) RETURNS numeric AS $$
    DECLARE
        var_Pi CONSTANT numeric = 3.1416;
    BEGIN
        if func_checkP(par_radi) then
            return (par_radi * par_radi) * var_Pi;
        else
            return 0;
        end if;
    END;
$$ LANGUAGE plpgsql;


do $$
    DECLARE
        vradi NUMERIC = :'Donem el radi que vols calcular';
        var_resultat numeric;
    begin
        var_resultat = func_calculArea(vradi);
        raise notice 'Àrea de la circumferència de radi % és %”', vradi, var_resultat;
    end
$$;

/*Exercici 3 (2 punts)
Crea un funció anomenada func_nom_manager a la qual és passarà el deparment_id com a paràmetre que serà
de tipus %TYPE i retornarà el nom del manager. Has de fer servir una variable també de tipus %TYPE per
guardar el nom del mànager. Programa una del bloc anònim per demanar a l'usuari el deparment_id, cridar la
funció func_nom_manager i imprimir per pantalla el nom del mánager.*/

CREATE OR REPLACE FUNCTION func_nom_manager (par_deparment_id departments.department_id%type) RETURNS varchar AS $$
    DECLARE
        var_nommanager employees.first_name%type;
        var_idmanager departments.manager_id%type;
    BEGIN
        select manager_id into var_idmanager from departments where department_id = par_deparment_id;
        select first_name into var_nommanager from employees where employee_id = var_idmanager;
        return var_nommanager;
    END;
$$ LANGUAGE plpgsql;

do $$
    DECLARE
        vidDepartment NUMERIC = :'Donem la id del departament';
        var_resultat employees.first_name%type;
    begin
        var_resultat = func_nom_manager(vidDepartment);
        raise notice 'El nom del manager es %”', var_resultat;
    end
$$;
/*Exercici 4 (2 punts)
Crea un procediment anomentat proc_dades_empl que mostri per pantalla el nom, cognom, el nom del departament
al qual pertany, i el codi identificador de la localitat on està el departament d’un empleat que un usuari introdueixi el
codi per teclat des d'un bloc anònim. Fes servir una variable tipus registre o un variable TYPE creada pel
programador.*/

create or replace procedure proc_dades_empl (par_id_emp employees.employee_id%type)
AS $$
DECLARE
    var_empleat record;
BEGIN
    select first_name, last_name, department_name, location_id into var_empleat from employees emp
        join departments d on d.department_id = emp.department_id where employee_id = par_id_emp;

    raise notice 'Nom: %, Cognom: %, NomDepartament: %, IdLocalitat: %', var_empleat.first_name, var_empleat.last_name, var_empleat.department_name, var_empleat.location_id;
END
$$ LANGUAGE plpgsql;

do $$
    declare
            v_numberid numeric = :"Donem la id de l'empleat";
    begin
        CALL proc_dades_empl(v_numberid);
    end;
$$;


/*Exercici 5 (2 punts)
Crea un procediment anomenat proc_alta_pais que serveixi per introduir un pais nou. Has de demanar les dades per
teclat i cridar el procediment des d’un bloc anònim. Els paràmetres que passaràs al procediment són "country_id",
"country_name" i "region_name" de tipus %TYPE. Com que per insertar un pais necessites el "region_id", en el
mateix procediment primer hauràs d'obtenir el region_id consultant la taula REGIONS i utilitzant el paràmetre per
"region_name". Després de la inserció, fes un select per recuperar la nova fila insertada i imprimeix el nom del país
insertat fent servir una variable %ROWTYPE.
Per provar si funciona correctament el procediment, l’usuari ha d’introduir per teclat les següents dades:
country_id: 'XN '
country_name: 'Xina'
region_name: 'Asia'*/

create or replace procedure proc_alta_pais (par_country_id countries.country_id%type, par_country_name countries.country_name%type, par_region_name regions.region_name%type)
AS $$
DECLARE
    var_resultat countries%rowtype;
    var_regionid regions.region_id%type;
BEGIN
    select region_id into var_regionid from regions where region_name=par_region_name;
    insert into countries values (par_country_id, par_country_name, var_regionid);
    select * into var_resultat from countries where country_id = par_country_id;
    raise notice 'El pais % esta insertada correctament', var_resultat.country_name;
END
$$ LANGUAGE plpgsql;

do $$
    declare
            v_countryid countries.country_id%type = :"Donem la nova id de pais que vols insertar";
            v_countryname countries.country_name%type = :"Donem el nom del pais que vols insertar";
            v_regionname regions.region_name%type = :"Donem el nom de la regio en la que estara";
    begin
        CALL proc_alta_pais(v_countryid,v_countryname,v_regionname);
    end;
$$;