/* 1. Mostra els departaments que el salari mitja dels seus treballadors és major o igual que la
mitja de tots els salaris.*/
Select d.* from departments d
join employees e on d.department_id = e.department_id
group by d.department_id having avg(e.salary) >= (select avg(salary) from employees);


/* 2. Mostra el nom del departament que gasta més diners en les nòmines dels seus empleats i
quants són aquests diners.*/
SELECT department_name, sum(e.salary) as "total nomines" from departments d
join employees e on d.department_id = e.department_id
group by d.department_id
order by d.department_id desc
limit 1;

/* 3. Mostra els noms i cognoms dels empleats més antics de cada departament.*/

SELECT first_name, last_name from employees e
join departments d on e.department_id = d.department_id
where e.hire_date = (select min(hire_date) from employees where department_id = e.department_id);


/* 4. Mostra totes les dades d'aquells departaments que tinguin empleats que hagin finalitzat el
seu contracte entre el gener de l'any 1992 i el desembre de l'any 2001. */
SELECT DISTINCT d.* 
FROM departments d
JOIN employees e ON d.department_id = e.department_id
JOIN job_history jh ON e.employee_id = jh.employee_id
WHERE jh.end_date BETWEEN '1992-01-01' AND '2001-12-31';
