-- Window Function

Select gender, AVG(salary) AS avg_salary
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender;


Select dem.first_name, dem.last_name, AVG(salary) OVER(PARTITION BY GENDER)
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;
    
Select dem.first_name, dem.last_name, salary,
SUM(salary) OVER(PARTITION BY GENDER ORDER BY dem.employee_id) AS Rolling_Total
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;
    
    
Select dem.employee_id, dem.first_name, dem.last_name, salary,
ROW_NUMBER () OVER (partition by gender ORDER BY salary DESC) AS row_num,
RANK () OVER (partition by gender ORDER BY salary DESC) AS Rank_num,
DENSE_RANK () OVER (partition by gender ORDER BY salary DESC) AS dense_rank_num
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;