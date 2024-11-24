-- Exploratory Data Analysis

SELECT *
FROM layoffs_staging2;

-- Looking at max total laid off and max percentage

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;


SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- Looking at company sum of layoff - Amazon had the most - Monese had the least

SELECT company, SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- Looking at the between which dates - 2020-03-11 to 2023-03-06

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

-- Looking at country with higher sum of layoff - US is at the top

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT *
FROM layoffs_staging2;

-- Looking at the dates with higher to lower layoffs

SELECT `date`, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY `date`
ORDER BY 2 DESC;

-- Looking at the year with higher and lower sum of layoff- 2022 had the highest

SELECT year(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY year(`date`)
ORDER BY 2 DESC;

-- Looking at the company stage - Post- IPO had the most - total of 204132

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

SELECT company, SUM(percentage_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- Substring takes the specific month with this code (`date`,6,2) + SUM of the total layoffs
-- January had the most layoffs with 92037

-- The function SUBSTRING(date, 1, 7) extracts a substring from the date column, 
-- starting from position 1 and taking the next 7 characters. 
-- It picks the year and month because of the way dates are typically stored in SQL in the standard YYYY-MM-DD format.
-- It also includes the separators e.g. -

SELECT substring(`date`,1,7) AS `MONTH`, SUM(Total_laid_off)
FROM layoffs_staging2
WHERE substring(`date`,1,7) IS NOT NULL
GROUP BY substring(`date`,1,7) 
ORDER BY 1 ASC;

-- Here I added a rolling total by Year and Month 

WITH Rolling_Total AS 
(
SELECT substring(`date`,1,7) AS `MONTH`, SUM(Total_laid_off) AS total_off
FROM layoffs_staging2
WHERE substring(`date`,1,7) IS NOT NULL
GROUP BY substring(`date`,1,7) 
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off
, SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC
;

WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS
(SELECT *, 
DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5
;



SELECT location, country, substring(`date`,1,7) AS `month`, SUM(total_laid_off)
FROM layoffs_staging2
GROUP by location, country, `month`
ORDER BY 3 DESC
;

WITH Location_year AS 
(
SELECT DISTINCT location, 
country, 
substring(`date`,1,7) AS `month`, 
SUM(total_laid_off) AS total_off
FROM layoffs_staging2
GROUP by location, country, `month`
), Location_year_Rank AS
(SELECT *, 
DENSE_RANK() OVER (PARTITION BY `month` ORDER BY total_off DESC) AS Ranking
FROM Location_Year
WHERE `month` IS NOT NULL
AND total_off IS NOT NULL
)
SELECT *
FROM Location_year_Rank
;

SELECT industry, country, 
YEAR(`date`) AS `month`,
SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry, country, `month`
;

WITH industry_year AS
(
SELECT industry, country, 
YEAR(`date`) AS `month`,
SUM(total_laid_off) AS total_off
FROM layoffs_staging2
GROUP BY industry, country, `month`
), industry_year_rank AS
(SELECT *, 
DENSE_RANK() OVER (PARTITION BY `month` ORDER BY total_off DESC) AS Ranking
FROM industry_Year
WHERE `month` IS NOT NULL
AND total_off IS NOT NULL
)
SELECT * 
FROM industry_year_rank
WHERE ranking <= 5;










