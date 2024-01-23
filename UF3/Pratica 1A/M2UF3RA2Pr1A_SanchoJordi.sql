/*Exercici 1 (1 punt)
Crea una funció anomenada func_info_ven que li passem l'identificador d'un venedor com a paràmetre i retorni
0 si la quota és inferior a les vendes, en cas contrari ha de mostrar 1, però si el venedor ha estat contractat l'any
1988 ha de retornar 2. Programa un bloc anònim per demanar a l'usuari l’identificador del venedor i cridar la
funció func_info_ven i mostrar el resultat. La funció ha d'utilitzar una variable RECORD i l'estructura de
control de flux CASE.
Prova la funció executant les sentències:
SELECT func_info_ven ('109');
SELECT func_info_ven ('104');
SELECT func_info_ven ('107');*/

CREATE OR REPLACE FUNCTION func_info_ven(par_id_venedor repventas.num_empl%TYPE) RETURNS NUMERIC AS $$
DECLARE
    vrepventas record;
    vnumber numeric;
BEGIN
    select * into vrepventas from repventas where num_empl = par_id_venedor;
    Case
        WHEN vrepventas.contrato BETWEEN '1-1-1988' and '31-12-1988' then
            vnumber = 2;
        WHEN vrepventas.cuota < vrepventas.ventas then
            vnumber = 0;
        ELSE
            vnumber = 1;
    end case;
    return vnumber;
end;
$$ LANGUAGE plpgsql;

DO $$
DECLARE
    var_repventas_id repventas.num_empl%TYPE = :repventas_id;
    var_result numeric;
BEGIN
    var_result = func_info_ven(var_repventas_id);
    Raise notice 'El resultat es %', var_result;
END;
$$ LANGUAGE plpgsql;

/*Exercici 2 (1 punt)
Crea una funció anomenada func_num_clients que li passem un identificador de venedor com a paràmetre
i retorni el número de clients que te assignats. Has d'utilitzar el tipus de dades %TYPE pel paràmetre. En un
bloc anònim s'ha de demanar a l'usuari el id del venedor, cridar la funció func_num_clients per passar-li com a
paràmetre el id del venedor introduit per l'usuari i mostrar el resultat amb un missatge que digui "El venedor
amb id <X> té <Y> clients assignats.*/

CREATE OR REPLACE FUNCTION func_num_clients(par_id_venedor repventas.num_empl%TYPE) RETURNS NUMERIC AS $$
DECLARE
    vnumberclie numeric;
BEGIN
    select count(*) into vnumberclie from clientes where rep_clie = par_id_venedor;
    return vnumberclie;
end;
$$ LANGUAGE plpgsql;

DO $$
DECLARE
    var_repventas_id repventas.num_empl%TYPE = :repventas_id;
BEGIN
    raise notice 'El venedor amb id % té % clients assignats.', var_repventas_id, func_info_ven(var_repventas_id);
END;
$$ LANGUAGE plpgsql;

/*Exercici 3 (2 punts)
Crea un procediment anomenat proc_baixa_ven que utilitzarem per donar de baixa el venedor que se li passa
l'identificador per paràmetre i reassigni tots els seus clients al venedor que tingui menys clients assignats (si hi
ha empat, a qualsevol d'ells).
En comptes d'eliminar fisicament el venedor de la base de dades, modificarem el seu camp 'titulo' que ara tindrà
el valor 'Baixa'.
Per escollir el venedor a qui reassignarem els clients podem fer una consulta que compti el número de clients de
cada venedor, ordeni per número de clients i limiti els resultats a 1 amb LIMIT 1.
Crea un bloc anònim que demani l'identificador del venedor a l'usuari i cridi el procediment proc_baixa_ven.*/

CREATE OR REPLACE PROCEDURE proc_baixa_ven(par_id_venedor repventas.num_empl%TYPE) AS $$
DECLARE
    vnumberclie numeric;
    vrepventasmensclie repventas.num_empl%type;
BEGIN
    update repventas set titulo = 'baixa' where num_empl = par_id_venedor;
    select rep_clie into vrepventasmensclie from clientes group by num_clie order by count(num_clie) DESC limit 1;
    update clientes set rep_clie = vrepventasmensclie where rep_clie = par_id_venedor;
end;
$$ LANGUAGE plpgsql;

DO $$
DECLARE
    var_repventas_id repventas.num_empl%TYPE = :repventas_id;
BEGIN
    Call proc_baixa_ven(var_repventas_id);
END;
$$ LANGUAGE plpgsql;

/*Exercici 4 (2 punts)
Crea una funció anomenada func_total_imports que li passem un identificador de venedor com a paràmetre
i retorni la suma dels imports de les comandes que gestiona. Has d'utilitzar el tipus de dades %TYPE pel
paràmetre. En un bloc anònim s'ha de demanar a l'usuari l’identificador del venedor, cridar la funció
func_total_imports per passar-li com a paràmetre el id del venedor introduit per l'usuari.
Si l'import és menor de 20000 s'ha de mostrar el missatge "Import baix".
Si l'import és més gran o igual de 20000 i menor o igual a 50000 s'ha de mostrar el missatge "Import mitjà".
Si l'import és més de 50000 s'ha de mostrar el missatge "Import elevat".*/

CREATE OR REPLACE FUNCTION func_total_imports(par_id_venedor repventas.num_empl%TYPE) RETURNS NUMERIC AS $$
DECLARE
    vsumimport numeric;

BEGIN
    select sum(importe) into vsumimport from pedidos where rep = par_id_venedor;
    return vsumimport;
end;
$$ LANGUAGE plpgsql;

DO $$
DECLARE
    var_repventas_id pedidos.rep%TYPE = :repventas_id;
    var_Import numeric;
BEGIN
    var_Import = func_total_imports(var_repventas_id);
    if var_Import < 20000 then
        raise notice 'Import baix';
    elsif var_Import >= 20000 and var_Import <= 50000 then
        raise notice 'Import mitjà';
    elsif var_Import > 50000 then
        raise notice 'Import elevat';
    end if;
END;
$$ LANGUAGE plpgsql;


/*Exercici 5 (2 punts)
Crea un procediment anomenat proc_dades_director que se li passarà com a paràmetre l’identificador de la
oficina i mostrarà per pantalla totes les dades del director de l’oficina. Has de fer servir una variable de tipus
%ROWTYPE per guardar totes les dades del director, i el paràmetre ha de ser del tipus %TYPE.
Programa un bloc anònim per demanar a l'usuari l’identificador de la oficina i cridar el procedimet
proc_dades_director.*/

CREATE OR REPLACE PROCEDURE proc_dades_director(par_id_oficina oficinas.oficina%TYPE) AS $$
DECLARE
    var_dadesDirector repventas%rowtype;
    var_idDirector oficinas.dir%TYPE;
BEGIN
    select dir into var_idDirector from oficinas where oficina = par_id_oficina;
    select * into var_dadesDirector from repventas where num_empl = var_idDirector;
    RAISE Notice 'Las dades del director son: Id: %, Nom: %, Edad: %, OficinaRep: %, Titulo: %, Contrato: %, Director: %, Cuota: %, Ventas: %', var_dadesDirector.num_empl,var_dadesDirector.nombre, var_dadesDirector.edad, var_dadesDirector.oficina_rep, var_dadesDirector.titulo, var_dadesDirector.contrato, var_dadesDirector.director, var_dadesDirector.cuota, var_dadesDirector.ventas;
end;
$$ LANGUAGE plpgsql;

DO $$
DECLARE
    var_oficina_id oficinas.oficina%TYPE = :oficina_id;
BEGIN
    call proc_dades_director(var_oficina_id);
END;
$$ LANGUAGE plpgsql;

/*Exercici 6 (2 punts)
Crea les següents funcions. En totes les funcions s'han de passar com a paràmetres l'identificador d'un producte i
l'identificador del fabricant.
- Una funció anomenada func_num_venedors que retorni el número de venedors que han venut aquest
producte.
- Una funció anomenada func_num_clients que retorni el número de clients que han comprat el producte.
- Una funció anomenada func_mitja_imports que retorni la mitjana de l'import de les comandes d'aquest
producte.
- Una funció anomenada func_min_quantitat que retorni la quantitat mínima que s'ha demanat del producte en
una sola comanda.
- Una funció anomenada func_max_quantitat que retorni la quantitat màxima que s'ha demanat del producte en
una sola comanda.
Crea un nou tipus de dades TYPE anomenat info_producte creat pel programador que utilitzarem per guardar
els valors que retornin les 5 funcions.
En un bloc anònim s'ha de demanar a l'usuari l'identificador d'un producte i l'identificador del fabricant, guardar
la informació en dues variables PL/SQL, cridar les funcions que els hi passarem les variables com a paràmetre,
guardar els valors que retornen les funcions en una variable del tipus creat info_producte i després utilitzar
aquesta variable composta per mostrar tota la informació a l’usuari. */

CREATE OR REPLACE FUNCTION func_num_venedors(par_id_fab productos.id_fab%TYPE, par_id_producta productos.id_producto%type) RETURNS NUMERIC AS $$
DECLARE
    vcountvenedors numeric;
BEGIN
    select count(*) into vcountvenedors from pedidos where fab = par_id_fab and producto = par_id_producta;
    return vcountvenedors;
end;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION func_num_clients(par_id_fab productos.id_fab%TYPE, par_id_producta productos.id_producto%type) RETURNS NUMERIC AS $$
DECLARE
    vcountclie numeric;
BEGIN
    select count(*) into vcountclie from pedidos where fab = par_id_fab and producto = par_id_producta;
    return vcountclie;
end;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION func_mitja_imports(par_id_fab productos.id_fab%TYPE, par_id_producta productos.id_producto%type) RETURNS NUMERIC AS $$
DECLARE
    vcountpedidos numeric;
    vcountimporte numeric;
    mediana numeric;
BEGIN
    select count(*) into vcountpedidos from pedidos where fab = par_id_fab and producto = par_id_producta;
    select sum(importe) into vcountimporte from pedidos where fab = par_id_fab and producto = par_id_producta;
    mediana = round(vcountimporte/vcountpedidos);
    return mediana;
end;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION func_min_quantitat(par_id_fab productos.id_fab%TYPE, par_id_producta productos.id_producto%type) RETURNS NUMERIC AS $$
DECLARE
    vquantitat numeric;
BEGIN
    select min(cant) into vquantitat from pedidos;
    return vquantitat;
end;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION func_max_quantitat(par_id_fab productos.id_fab%TYPE, par_id_producta productos.id_producto%type) RETURNS NUMERIC AS $$
DECLARE
    vquantitat numeric;
BEGIN
    select max(cant) into vquantitat from pedidos;
    return vquantitat;
end;
$$ LANGUAGE plpgsql;

create type info_producte as (
    numeroVenedors numeric,
    numeroClients numeric,
    Mitja_imports numeric,
    Minima_Quantitat numeric,
    Maxima_Quantitat numeric
);

DO $$
DECLARE
    var_id_fab pedidos.fab%TYPE = :vIdFabricant;
    var_id_producta pedidos.producto%TYPE = :vIdProducto;
    var_dades info_producte;
BEGIN
    var_dades.numeroVenedors = func_num_venedors(var_id_fab,var_id_producta);
    var_dades.numeroClients = func_num_clients(var_id_fab,var_id_producta);
    var_dades.Mitja_imports = func_mitja_imports(var_id_fab,var_id_producta);
    var_dades.Minima_Quantitat = func_min_quantitat(var_id_fab,var_id_producta);
    var_dades.Maxima_Quantitat = func_max_quantitat(var_id_fab,var_id_producta);

    raise notice 'Els resultats son: NVenedors: %, NClients: %, ImportMitja: %, QuantitatMin: %, QuantitatMax: %', var_dades.numeroVenedors, var_dades.numeroClients, var_dades.Mitja_imports, var_dades.Minima_Quantitat, var_dades.Maxima_Quantitat;
END;
$$ LANGUAGE plpgsql;

