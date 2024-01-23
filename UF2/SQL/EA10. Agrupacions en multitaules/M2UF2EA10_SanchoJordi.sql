/* 1. Mostra per cada cap (manager_id), la suma dels salaris dels seus empleats, però només, per
aquells casos en els quals la mitja del salari dels seus empleats sigui més gran que 3000.*/

select manager_id, sum(salary) as sum_salary from employees group by manager_id having AVG(salary) > 3000;

/* 2. Mostra per cada cap (manager_id) quants empleats tenen al seu carrec i quin és el salari
màxim, però només per aquells caps amb més de 6 empleats al seu càrrec. */

select manager_id, count(employee_id) as num_empleats, sum(salary) as sum_max from employees group by manager_id having  count(employee_id) > 6;

/* 3. Fes al mateix que a la consulta anterior, però només per aquells caps que tinguin com a
id_manager_id 100, 121 o 122. Ordena els resultats per manager_id. */

select employees.manager_id, COUNT(employee_id) as num_empleats, SUM(salary) as sum_max from employees where manager_id in (100, 121, 122) group by manager_id having count(employee_id) > 6 order by manager_id;

/* 4. Calcular el nombre empleats que realitzen cada ofici a cada departament.
Les dades que es visualitzen són: codi del departament, ofici i nombre empleats. */

select e.department_id, j.job_title, COUNT(e.employee_id) as num_empleats from jobs j, employees e where e.job_id = j.job_id group by e.department_id, j.job_title, e.job_id;


/* 5. Mostra el nom del departament i el número d'emplets que té cada departament. */ 

SELECT d.department_name, count(e.employee_id) as sum_empleats from departments d, employees e where d.department_id=e.department_id group by e.department_id, d.department_name;

/* 6. Mostra el número d'empletas del departamant de 'SALES'.*/ 

SELECT d.department_name, count(e.employee_id) as sum_empleats from departments d, employees e where d.department_id=e.department_id and department_name='Sales' group by e.department_id, d.department_name;

/* 7. Mostra quants departaments diferents hi ha a Seattle. */

select l.city ,count(department_id) from departments d, locations l where l.location_id=d.location_id and l.city='Seattle' group by l.location_id, l.city;