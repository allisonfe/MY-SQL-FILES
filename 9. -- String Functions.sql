 -- String Functions
 
 SELECT length('skyfall');
 
 Select first_name, length(first_name)
 FROM employee_demographics
 ORDER BY 2;
 
 SELECT UPPER('SKY');
 SELECT LOWER('sky');
 
  Select first_name, UPPER(first_name)
 FROM employee_demographics;
 
 
 SELECT LTRIM('       sky            ');
SELECT RTRIM('       sky            ');

SELECT first_name, 
LEFT(first_name, 4),
RIGHT(first_name, 4),
SUBSTRING(first_name,3,2),
birth_date,
SUBSTRING(birth_date,6,2) AS birth_month
FROM employee_demographics;

SELECT first_name, REPLACE(first_name, 'a','z')
FROM employee_demographics;


SELECT locate('x','Alexander');

SELECT first_name, locate('An', first_name)
FROM employee_demographics;


SELECT first_name, last_name,
CONCAT(first_name, ' ', last_name)
FROM employee_demographics;





