SELECT *
FROM layoffs;

-- Creating a Staging table
CREATE TABLE layoffs2
LIKE layoffs;

INSERT layoffs2
SELECT *
FROM layoffs;

SELECT *
FROM layoffs2;

-- Removing Duplicates

SELECT *,
ROW_NUMBER () OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs2;

WITH duplicates AS
(
SELECT *,
ROW_NUMBER () OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs2
)
SELECT *
FROM duplicates
WHERE row_num > 1;

CREATE TABLE `layoffs3` (
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
FROM layoffs3;

INSERT layoffs3
SELECT *,
ROW_NUMBER () OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs2;

SELECT *
FROM layoffs3
WHERE row_num >1;

DELETE
FROM layoffs3
WHERE row_num >1;

-- Standardizing the Data

SELECT DISTINCT company, TRIM(company)
FROM layoffs3;

UPDATE layoffs3
SET company = TRIM(company);

SELECT DISTINCT location
FROM layoffs3;

SELECT *
FROM layoffs3
WHERE location ='DÃ¼sseldorf';

UPDATE layoffs3
SET location = 'Düsseldorf'
WHERE location = 'DÃ¼sseldorf';

SELECT *
FROM layoffs3
WHERE location ='FlorianÃ³polis'
;

UPDATE layoffs3
SET location = 'Florianópolis'
WHERE location = 'FlorianÃ³polis';

SELECT *
FROM layoffs3
WHERE location ='MalmÃ¶';

UPDATE layoffs3
SET location = 'Malmö'
WHERE location = 'MalmÃ¶';

SELECT DISTINCT industry
FROM layoffs3;

SELECT *
FROM layoffs3
WHERE industry LIKE 'Crypto%';

UPDATE layoffs3
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT *
FROM layoffs3
WHERE industry IS NULL OR industry = '';

UPDATE layoffs3
SET industry = NULL
WHERE industry = '';

SELECT *
FROM layoffs3 AS t1
JOIN layoffs3 AS t2
	ON t1.company = t2.company AND
    t1.location = t2.location
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

UPDATE layoffs3 AS t1
JOIN layoffs3 AS t2
	ON t1.company = t2.company AND
    t1.location = t2.location
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

SELECT *
FROM layoffs3
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

DELETE FROM layoffs3
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

SELECT `date`
FROM layoffs3;

UPDATE layoffs3
SET `date`= STR_TO_DATE(`date`, '%m/%d/%Y');

SELECT *
FROM layoffs3;

SELECT DISTINCT stage
FROM layoffs3;

SELECT DISTINCT country
FROM layoffs3;

UPDATE layoffs3
SET country = 'United States'
WHERE country = 'United States.';

ALTER TABLE layoffs3
DROP COLUMN row_num;

-- Rechecking for Duplicates

SELECT *,
ROW_NUMBER () OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs3;

WITH duplicates AS
(
SELECT *,
ROW_NUMBER () OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs3
)
SELECT *
FROM duplicates
WHERE row_num > 1;

CREATE TABLE `layoffs4` (
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
FROM layoffs4;

INSERT layoffs4
SELECT *,
ROW_NUMBER () OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs3;

SELECT *
FROM layoffs4
WHERE row_num >1;

DELETE
FROM layoffs4
WHERE row_num >1;

ALTER TABLE layoffs4
DROP COLUMN row_num;

