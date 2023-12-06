/* 1. Mostra el nom i cognom de tots els empleats. S'han de mostrar amb la primera lletra en
majúscula i la resta en minúscules.*/
SELECT UPPER(LEFT(first_name, 1)) || LOWER(SUBSTRING(first_name, 2)) AS first_name, 
UPPER(LEFT(last_name, 1)) || LOWER(SUBSTRING(last_name, 2)) AS last_name FROM employees;

/* 2. Mostra els empleats que han sigut contractats durant el més de maig. */
SELECT employee_id, first_name, last_name, hire_date FROM employees WHERE hire_date >= '2023-05-01' AND hire_date < '2023-06-01';

/* 3. Mostra els oficis (job_title) diferents que hi ha a la base de dades. */
SELECT DISTINCT job_title FROM jobs;

/* 4. Calcula quants empleats hi ha en cada departament. */
SELECT department_name, COUNT(*) AS num_employees FROM employees, departments GROUP BY department_name;

/* 5. Calcula quants empleats hi ha de cada tipus d'ocupació (JOB_ID). */
SELECT JOB_ID, COUNT(*) AS num_empleats FROM employees GROUP BY JOB_ID;

/* 6. Mostra el número de països que tenen cadascun dels continents que tinguin com
identificador de regió 1,2 o 3; */
SELECT COUNT(DISTINCT country_name) FROM countries WHERE region_id IN (1, 2, 3);

/* 7. Mostra per cada manager el manager_id, el nombre d'emplets que té al seu carrec i la mitja
dels salaris d'aquests empleats. */
SELECT manager_id, COUNT(*) AS num_empleats, AVG(salary) AS avg_salary FROM employees GROUP BY manager_id ORDER BY manager_id; 

/* 8. Mostra l’id del departament i el número d’empleats dels departaments amb més de 4
empleats. */
SELECT department_id, COUNT(*) AS num_employees FROM employees WHERE department_id IN ( SELECT department_id FROM employees GROUP BY department_id HAVING COUNT(*) > 4) GROUP BY department_id;