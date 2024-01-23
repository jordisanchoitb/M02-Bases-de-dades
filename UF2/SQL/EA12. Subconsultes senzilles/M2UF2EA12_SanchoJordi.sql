/* 1. Mostra els noms dels oficis (job_title) dels empleats que treballen al departament 80.*/

select job_title
from jobs
where job_id IN (
    select job_id
    from employees
    where department_id = 80
);


/*2. Mostra els noms de departaments que tinguin empleats.*/

select department_name
from departments
where department_id IN (
    select DISTINCT department_id
    from employees
);


/*3. Mostra els cognoms els empleats que tenen un salari inferior al salari mitjà dels empleats*/
/*que són representants de vendes (job_id=’SA_MAN’).*/

select last_name
from employees
where salary < (
    select AVG(salary)
    from employees
    where job_id = 'SA_MAN'
);


/*4. Mostra els noms països que estan al mateix continent que Argentina.*/

select country_name
from countries
where region_id = (
    select region_id
    from countries
    where country_name = 'Argentina'
);


/*5. Mostra el noms i els cognoms de tots els empleats amb el mateix ofici que David Austin.*/

select first_name, last_name
from employees
where job_id = (
    select job_id
    from employees
    where first_name = 'David' AND last_name = 'Austin'
);


/*6. Mostra els noms dels països d'Àsia o Europa.*/

select country_name
from countries
where region_id IN (
    select region_id
    from regions
    where region_name IN ('Asia', 'Europe')
);


/*7. Mostra els cognoms dels empleats que el seu nom comença per H i el seu salari
és més gran que algun empleat del departament 100.*/

select last_name
from employees
where first_name LIKE 'H%' AND salary > ANY (
    select salary
    from employees
    where department_id = 100
);


/*8. Mostra els cognoms d'aquells empleats que no treballen al departament de Marketing ni al
de vendes. */

select last_name
from employees
where department_id NOT IN (
    select department_id
    from departments
    where department_name IN ('Marketing', 'Sales')
);
