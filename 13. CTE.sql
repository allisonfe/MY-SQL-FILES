-- CTEs


WITH CTE_example (gender, AVG_sal, MAX_sal, MIN_sal, COUNT_sal) AS
(
Select gender, AVG(salary) avg_sal, 
MAX(salary) max_sal, 
MIN(salary) min_sal, 
COUNT(salary) count_sal
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
)
SELECT *
FROM CTE_example
;


SELECT AVG(avg_sal)
FROM(
Select gender, AVG(salary) avg_sal, 
MAX(salary) max_sal, 
MIN(salary) min_sal, 
COUNT(salary) count_sal
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
) example_subquery
;



WITH CTE_example AS
(
Select employee_id, gender, birth_date
FROM employee_demographics dem
WHERE birth_date > '1985-01-01'
),
CTE_Example2 AS
(
SELECT employee_id, salary
FROM employee_salary
WHERE salary > 50000
)
SELECT*
FROM CTE_example
JOIN CTE_example2
	ON CTE_example.employee_id = CTE_example2.employee_id
;