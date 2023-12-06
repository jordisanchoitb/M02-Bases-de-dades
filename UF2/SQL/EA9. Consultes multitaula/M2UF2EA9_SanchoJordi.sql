/* 1. Mostra totes les dades dels empleats que el seu lloc de feina sigui Sales Manager. */
SELECT employees.* from employees, job_history where employees.job_id=job_history.job_id and job_history.job_id='SA_MAN';

/* 2. Mostra els departaments que tinguin empleats que hagin finalitzat el seu contracte a l'any
1998. */
SELECT departments.* FROM departments, job_history WHERE end_date BETWEEN '1/1/1998' AND '12/31/1998' AND job_history.department_id=departments.department_id;

/* 3. Mostra els noms dels departaments en els que hi treballin empleats amb noms que
comencen per la lletra A. */
SELECT DISTINCT department_name FROM departments,employees WHERE first_name Like 'A%';

/* 4. Mostra el nom del departament, el nom i el cognom dels empleats que el seu departament
no sigui IT. */

SELECT department_name,first_name,last_name FROM departments,employees WHERE department_name = 'IT';

/* 5. Mostra totes les dades dels departaments que es troben a Seattle. */

Select d.* from departments d, locations l where d.location_id = l.location_id and l.city='Seattle';


/* 6. Mostra el nom, el cognom i el nom del departament dels empleats que treballen a Seattle.*/

Select e.first_name,e.last_name,d.department_name from employees e,departments d,locations l where e.department_id = d.department_id and d.location_id = l.location_id and city='Seattle';

/* 7. Mostra el nom del departament i totes les dades dels empleats que no treballen en el
departament de Marketing ni el de vendes (Sales). */

select d.department_name, e.* from employees e, departments d where  d.department_id=e.department_id and (department_name != 'Marketing' and department_name != 'Sales');

/* 8. Mostra els noms de tots els departaments i la ciutat i país on estiguin ubicats.*/

select d.department_name, c.country_name, l.city from countries c, departments d, locations l where  d.location_id=l.location_id and l.country_id = c.country_id;

/* 9. Mostra els noms dels països (country_name) i el nom del continent (region_name) d'Àsia i
Europa. */

select country_name, region_name from countries c, regions r where c.region_id=r.region_id and (r.region_name='Europe' or r.region_name='Asia');

/* 10. Mostra el cognom i el job_id dels empleats que tinguin el mateix ofici que el seu cap i
mostra el nom del cap. */

select e.last_name, d.first_name,e.job_id  from employees e, employees d where e.department_id=d.department_id and d.employee_id=e.manager_id and d.job_id=e.job_id;

/* 11. Mostra el cognom dels empleats que tinguin el mateix ofici que el seu cap, el nom del cap
i mostra també el nom de l'ofici (job_title). */

select e.last_name, d.first_name, j.job_title  from employees e, employees d, jobs j where e.department_id=d.department_id and d.employee_id=e.manager_id and d.job_id=e.job_id and e.job_id=j.job_id;