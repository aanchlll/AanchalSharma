SELECT *
FROM layoffs4;

-- Which companies had the maximum people laid off

SELECT company, MAX(total_laid_off)
FROM layoffs4
GROUP BY company
ORDER BY MAX(total_laid_off) DESC;

-- Which industries had the maximum people laid off

SELECT industry, MAX(total_laid_off)
FROM layoffs4
GROUP BY industry
ORDER BY MAX(total_laid_off) DESC;

-- Which countries had the maximum people laid off

SELECT country, MAX(total_laid_off)
FROM layoffs4
GROUP BY country
ORDER BY MAX(total_laid_off) DESC;

-- which locations in the US had the most people laid off

SELECT location, MAX(total_laid_off)
FROM layoffs4
WHERE country = 'United States'
GROUP BY location
ORDER BY MAX(total_laid_off) DESC; 

-- Which company stage had the most people laid off

SELECT stage, MAX(total_laid_off) AS total_laidoff
FROM layoffs4
GROUP BY stage
ORDER BY 2 DESC;

-- Finidng the Rolling Total of the people laid off per month

WITH Company_Year AS 
(
  SELECT company, YEAR(date) AS years, SUM(total_laid_off) AS total_laid_off
  FROM layoffs4
  GROUP BY company, YEAR(date)
)
, Company_Year_Rank AS (
  SELECT company, years, total_laid_off, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
  FROM Company_Year
)
SELECT company, years, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 3
AND years IS NOT NULL
ORDER BY years ASC, total_laid_off DESC;

SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs4
GROUP BY dates;

WITH DATE_CTE AS 
(
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs4
GROUP BY dates
ORDER BY dates ASC
)
SELECT dates, SUM(total_laid_off) OVER (ORDER BY dates ASC) as rolling_total_layoffs
FROM DATE_CTE
WHERE dates IS NOT NULL
ORDER BY dates ASC;

-- WHich companies went completely under 

SELECT company, location
FROM layoffs4
WHERE percentage_laid_off = 1;


