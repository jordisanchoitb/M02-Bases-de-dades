/* 1. Crea una consulta per mostrar el cognom i el salari dels empleats que guanyen més de
12.000. */

SELECT LAST_NAME from EMPLOYEES WHERE SALARY > 12000;

/* 2. Crea una consulta per a mostrar el cognom de l’empleat i el número de departament
d’empleat amb id 176. */

SELECT LAST_NAME, department_id from EMPLOYEES where employee_id = 176;

/* 3. Crea una consulta per a mostrar el cognom i el número de departament de tots els
empleats que els seus salari no estiguin dins del rang 5000 i 12000. */
SELECT LAST_NAME, department_id from EMPLOYEES where not(salary > 5000 and salary < 12000);

/* 4. Crea una consulta per mostrar el cognom de l’empleat, l’identificador del càrrec (JOB:ID) i
la data de contractació dels empleats contractats entre el 20 de febrer de 1998 i l'1 de maig de
1998. Ordenar la consulta en ordre ascendent per data de contractació. */
SELECT LAST_NAME, job_id, hire_date from employees where hire_date between '20/02/1998' and '1/05/1998' order by hire_date ASC;

/* 5. Crea una consulta per mostrar el cognom i el número de departament de tots els empleats
dels departaments 20 i 50, ordena per ordre alfabètic per cognom. */
SELECT last_name, department_id FROM employees WHERE department_id IN (20, 50) ORDER BY last_name ASC;


/* 6. Crea una consulta per mostrar el cognom i la data de contractació de tots els empleats
contractats l'any 1998. */
SELECT last_name, hire_date FROM employees WHERE hire_date BETWEEN '1998-01-01' AND '1998-12-31';


/* 7. Crea una consulta per mostrar el cognom i el càrrec (JOB_ID) de tots els empleats que no
tenen director assignat. */
SELECT last_name, job_id FROM employees WHERE MANAGER_ID IS NULL;

/* 8. Crea una consulta per a mostrar el cognom, el salari i la comissió de tots els empleats que
tenen comissions. Ordenar les dades en ordre descendent de salaris i comissions. */
SELECT last_name, salary, commission_pct FROM employees WHERE commission_pct IS NOT NULL ORDER BY salary DESC, commission_pct DESC;

/* 9. Crea una consulta per mostrar el cognom de tots els empleats que tingui una a como tercera
lletra (en aquest camp cognom). */
SELECT last_name FROM employees WHERE last_name LIKE '__a%';

/* 10. Crea una consulta per mostrar el cognom de tots els empleats que tinguin una a i una e (en
aquest camp cognom). */
SELECT last_name FROM employees WHERE last_name LIKE '%a%' AND last_name LIKE '%e%';

/* 11. Crea una consulta per a mostrar el cognom, el càrrec (JOB_ID) i el salari de tots els
empleats on els càrrecs siguin representants de vendes (AC_ACCOUNT) o encarregats de
stock (AD_ASST) i els salaris no siguin iguals a 2500, 3500 ni 7000. */
SELECT last_name, job_id, salary FROM employees WHERE (job_id = 'AC_ACCOUNT' OR job_id = 'AD_ASST') AND salary NOT IN (2500, 3500, 7000);