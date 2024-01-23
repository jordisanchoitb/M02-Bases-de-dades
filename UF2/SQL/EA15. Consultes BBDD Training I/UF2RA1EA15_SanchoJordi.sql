-- 1. Mostra el nom dels venedors que tinguin una quota igual o inferior al objectiu de la oficina
-- de vendes d'Atlanta. (Utilitza la subconsulta).
-- El resultat mostra 9 files

SELECT nombre
FROM repventas
WHERE cuota <= (SELECT objetivo FROM oficinas WHERE ciudad = 'Atlanta');

-- 2. Mostra Tots els clients, identificador i nom de l'empresa, que han estat atesos per (que han
-- fet comanda amb) Bill Adams. (Utilitza només subconsultes).
-- El resultat mostra 2 files.

SELECT num_clie, empresa
FROM clientes
WHERE num_clie IN (SELECT clie FROM pedidos WHERE rep = (SELECT num_empl FROM repventas WHERE nombre = 'Bill Adams'));

-- 3. Mostra els noms dels venedors i les seves quotes dels venedors amb quotes que siguin
-- iguals o superiors a l'objectiu de la seva oficina de vendes. Fes-ho primer amb una
-- subconsulta i després amb un JOIN.
-- El resultat mostra 2 files

-- Subconsulta:
SELECT nombre, cuota
FROM repventas
WHERE cuota >= (SELECT objetivo FROM oficinas WHERE oficina_rep = num_empl);

-- JOIN:
SELECT r.nombre, r.cuota
FROM repventas r
JOIN oficinas o ON r.num_empl = o.oficina_rep
WHERE r.cuota >= o.objetivo;


-- 4. Mostrar l'identificador de l'oficina i la ciutat de les oficines on l'objectiu de vendes de
-- l'oficina excedeix la suma de quotes dels venedors d'aquella oficina. (Utilitza la subconsulta).
-- El resultat mostra 2 files

SELECT oficina, ciudad
FROM oficinas
WHERE objetivo > (SELECT SUM(cuota) FROM repventas WHERE oficina_rep = oficina);



-- 5. Mostra l'identificador del fabricant com a "Fabricant", l'identificador del profucte com a
-- "codi Producte", la descripció i les existèncie dels productes del fabricant amb identificador
-- "aci" que les existències superen les existències del producte amb identificador de producte
-- "41004". (Utilitza la subconsulta).
-- El resultat mostra 3 files

SELECT 'Fabricante' as identificador, id_producto as "Código Producto", descripcion, existencias
FROM productos
WHERE id_fab = 'aci'
    AND existencias > (SELECT existencias FROM productos WHERE id_producto = '41004');



-- 6. Mostra l’identificador d’empleat i el nom dels venedors que han acceptat una comanda que
-- representa més del 10% de la seva quota. Fes-ho primer amb una subconsulta i després amb
-- un consluta multitaula (sense el JOIN).
-- El resultat mostra 3 files

-- Subconsulta:
SELECT num_empl, nombre
FROM repventas
WHERE num_empl IN (SELECT rep FROM pedidos WHERE importe > 0.1 * cuota);

-- Consulta Multitabla:
SELECT r.num_empl, r.nombre
FROM repventas r, pedidos p
WHERE r.num_empl = p.rep AND p.importe > 0.1 * r.cuota;


-- 7. Mostra el nom i l'edat de totes les persones de l'equip de vendes que no dirigeixen una
-- oficina. Utilitza el test d'existència.
-- El resultat mostra 6 files

SELECT nombre, edad
FROM repventas
WHERE NOT EXISTS (
    SELECT 1
    FROM oficinas
    WHERE director = repventas.num_empl
);



