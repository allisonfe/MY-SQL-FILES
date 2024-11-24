-- WHERE Clause

Select *
FROM employee_salary
WHERE first_name =  'Leslie'
;


Select *
FROM employee_salary
WHERE salary <= 50000
;

Select *
FROM employee_demographics
WHERE gender != 'female'
;

Select *
FROM employee_demographics
WHERE birth_date > '1985-01-01'
;

 -- AND OR NOT -- Logical Operators
 
 Select *
FROM employee_demographics
WHERE birth_date > '1985-01-01'
OR NOT gender = 'male'
;

 Select *
FROM employee_demographics
WHERE (first_name = 'Leslie' AND age = 44) OR age > 55
;

 -- LIKE STATEMENT
 -- % and _
  Select *
FROM employee_demographics
WHERE birth_date LIKE '1989%'
;

  Select *
FROM employee_demographics
WHERE first_name LIKE 'a__%'
;