-- DATA CLEANING


SELECT *
FROM layoffs;

-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null Values or blank values
-- 4. Remove Any Columns that are unnecessary


-- STAGE 1 - Make sure a copy of the raw data is created - this is where I did this. 

CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT *
FROM layoffs_staging;

INSERT layoffs_staging
SELECT *
FROM layoffs;

-- STAGE 2 Looking for duplicates  - Below is where I did this by looking at all the data 
-- first by selecting all, then by creating a new data set layoffs_staging2 and deleting the duplicates
SELECT *,
ROW_NUMBER () OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging;

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER () OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, 
country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

SELECT *
FROM layoffs_staging
WHERE company = 'Casper';


WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER () OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, 
country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
DELETE
FROM duplicate_cte
WHERE row_num > 1;


CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


SELECT *
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER () OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, 
country, funds_raised_millions) AS row_num
FROM layoffs_staging;


DELETE
FROM layoffs_staging2
WHERE row_num > 1;

-- Here is where I ran into an error with MySQL where I couldn't delete due to the default system
-- quickly did a search on the net and fixed it.

SET SQL_SAFE_UPDATES = 0;

DELETE
FROM layoffs_staging2
WHERE row_num > 1;

SELECT *
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE company = 'Casper';

-- Standardizing Data

-- started by triming the data

SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

 -- then standardized data that is pretty much the name into the same name

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT industry
FROM layoffs_staging2
;

UPDATE layoffs_staging2
SET industry ='Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- UPDATED DATE from initial TEXT version - look up other forms of updating dates if needed

SELECT `date`
FROM layoffs_staging2;


UPDATE layoffs_staging2
SET `date` = str_to_date(`date`, '%m/%d/%Y')
;

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- Looked for NULL values in total laid off and percentege laid off

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Looked for null values in the industry

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';

-- Identified around 4 companies

SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';


-- The next step allows to create to a JOIN where one side the industry shows NULL or '' 
-- and the other side shows the populated industry - i.g. Airbnb - travel
-- HOWEVER - one must first update '' into NULL. 
-- A JOIN can used when you need to afirm and deny to test two hypothesis


-- PART - 1 POPULATING MISSING VALUES WIHT EXISTING VALUES OF THE SAME VARIABLE

SELECT *
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

-- THIS IS HOW YOU SET ONE VARIABLE THAT IS BLANK INTO NULL

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

-- NEXT we update the missing values into existing values

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL;

-- DELETED total_laid_off NULL AND percentage_laid_off NULL for exploratory data analysis

SELECT *
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- DELETED extra unnecessary columns - e.g. row_num

SELECT *
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;