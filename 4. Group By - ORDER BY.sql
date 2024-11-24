 -- Group By
 
   Select *
FROM employee_demographics
;

   Select gender, AVG(age), MAX(age), MIN(age), COUNT(age)
FROM employee_demographics
GROUP BY gender
;

Select occupation, salary
FROM employee_salary
GROUP BY occupation, salary
;

 -- ORDER BY
 Select *
FROM employee_demographics
ORDER By gender, age DESC
;
 