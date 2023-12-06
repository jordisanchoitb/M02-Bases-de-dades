/*Exercici 1 (1 punt) BBDD hr
Mostra els nom del departament que comenci per ‘R’ que no tingui empleats.
Fes servir un test
d’existència amb consulta correlacionada.
El resultat mostra 2 files*/

Select department_name from departments d, employees e
where d.department_name like 'R%' and e.department_id IS null;

/*Exercici 2 (1,5 punts) BBDD hr
Mostra el nom i cognom de l'empleat i el nom del departament i el nom de la ciutat
on està situat el departament. Mostra també el nom dels departaments que no
tenen empleats i les ciutats on no hi ha departaments.
El resultat mostra 138 files*/

select first_name, last_name, department_name, city from employees em
right join departments d on em.department_id = d.department_id
right join locations l on d.location_id = l.location_id;


/*Exercici 3 (1,5 punts) BBDD hr
Mostra el identificador del departament i el nom i el cognom dels empleats
que tenen el salari més alt del seu departament.
El resultat mostra 11 files*/ /*Revisar */

select em.department_id, first_name, last_name from employees em
join departments d on em.department_id = d.department_id
where salary in (Select max(salary) from employees);



/*Exercici 4 (1,5 punts) BBDD residus
Mostra els noms de les empreses transportistes i la suma de les despeses reanomenades com "cost total" per
cada empresa de transport de residus que hagin realitzats trasllats l’any 2016 (data_enviament). Mostra només
les empreses que la suma de les despeses sigui més gran que 118000 i ordena els resultats per la suma de la
despesa de forma descendent.
El resultat mostra 6 files*/

select em.nom_emptransport, sum(cost) as "cost total" from empresatransportista em
join trasllat_empresatransport te on em.nif_emptransport = te.nif_emptransport
where data_enviament between '1/1/2016' and '12/31/2016'
group by em.nom_emptransport
having 118000 < sum(cost)
order by sum(cost) desc;

/*Exercici 5 (2 punts) BBDD residus
Mostra el nom i la ciutat de destí que més residus ha rebut.
Mostra també la quantitat total de residus traslladats.
El resultat mostra 1 fila*/

Select nom_desti, ciutat_desti, sum(quantitat_trasllat) from desti d
join trasllat t on d.cod_desti = t.cod_desti
group by d.cod_desti
having sum(quantitat_trasllat) > 7300;


/*Exercici 6 (2,5 punts) BBDD residus
Mostra el nom i el NIF de l’empresa productora que menys quantitat dels residus que tenen un nivell de toxicitat
més alt ha generat. Mostra també la toxicitat i la quantitat del residu. Utilitza subconsultes.
El resultat mostra 1 fila*/

select nom_empresa, emp.nif_empresa, toxicitat, quantitat_residu from empresaproductora emp
join residu r on emp.nif_empresa = r.nif_empresa
where toxicitat = (select max(toxicitat) from residu) and quantitat_residu = 12

