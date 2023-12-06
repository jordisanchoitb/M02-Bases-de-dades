/* 1. Mostra el nom de l’empleat, el nom del departament on treballa i l'id del seu cap. Fes servir
primer JOIN i USING i després o resols amb JOIN ON.*/

select e.first_name, d.department_name, e.manager_id
from employees e
join departments d USING (department_id);

select e.first_name, d.department_name, e.manager_id
from employees e
join departments d ON (d.department_id=e.department_id);



/* 2. Mostra la ciutat i el nom del departament de la localització 1400 (LOCATION_ID=1400).
Primer ho resols fent servir JOIN ON i després fent servir JOIN USING.*/

select l.city, d.department_name
from locations l
join departments d ON (l.location_id = d.location_id)
where l.location_id = 1400;

select l.city, d.department_name
from locations l
join departments d USING (location_id) 
where l.location_id = 1400;


/*3. Mostra el cognom i la data de contractació de qualsevol empleat contractat després de
l’empleat Davies. Fes servir JOIN.*/

select e.last_name, e.hire_date
from employees e
join employees e2 ON (e.hire_date > e2.hire_date)
where e2.last_name = 'Davies';


/*4. Mostra el nom i cognom dels empleats, el nom del departament on treballen i el nom de la
ciutat on es troba el departament. Fes servir primer JOIN i USING i després o resols amb
JOIN ON.*/

select e.first_name, e.last_name, d.department_name, l.city
from employees e
join departments d USING (department_id)
join locations l USING (location_id);

select e.first_name, e.last_name, d.department_name, l.city
from employees e
join departments d ON (e.department_id = d.department_id)
join locations l ON (d.location_id = l.location_id);


/* 5. Mostra l'id del departament i el cognom de l’empleat de tots els empleats que treballin al
mateix departament que un empleat donat. Assignar a cada columna una etiqueta adequada.
Fes servir JOIN. */

select e.department_id as "Id del departament" , e2.last_name as "Cognom empleat"
from employees e
join employees e2 ON (e.department_id = e2.department_id)
where e.employee_id = 100;


