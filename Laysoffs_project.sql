-- DATA CLEANIN
SELECT count(*) FROM layoffs;
SELECT * FROM layoffs;

# Q1 REMOVE DUPLICATES

-- LETS CREATE A SECOND TABLE

CREATE TABLE layoffs_1 LIKE layoffs;
 INSERT layoffs_1
 SELECT * FROM layoffs;
 
 SELECT * ,
 ROW_NUMBER () OVER( PARTITION BY
 company, location, industry, total_laid_off, 'date', stage, country, funds_raised_millions)
 FROM layoffs_1;
 
 WITH dublicate_cte AS
 (
 SELECT * ,
 ROW_NUMBER () OVER( PARTITION BY
 company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions)
 AS row_num
 FROM layoffs_1 )
 SELECT * 
 FROM dublicate_cte 
 WHERE row_num >1;
 
 
 CREATE TABLE `layoffs_2` (
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

SELECT * FROM layoffs_2;

INSERT INTO layoffs_2
SELECT * ,
 ROW_NUMBER () OVER( PARTITION BY
 company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions)
 AS row_num
 FROM layoffs_1 ;

DELETE
 FROM layoffs_2
WHERE row_num > 1;

SELECT * FROM layoffs_2;

#Q2 STANDARDIZING DATA

SELECT company, TRIM(company)
FROM layoffs_2;

update layoffs_2
SET company = TRIM(company);

SELECT *
FROM layoffs_2
WHERE industry LIKE 'Crypto%';

update layoffs_2
SET industry = 'crypto'
WHERE industry LIKE 'crypto%';

SELECT DISTINCT industry
FROM layoffs_2
ORDER BY 1;

SELECT DISTINCT location FROM layoffs_2;

SELECT DISTINCT country, TRIM(country)
from layoffs_2;

UPDATE layoffs_2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country like 'united state%';

SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')AS date
FROM layoffs_2;

UPDATE layoffs_2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_2
MODIFY COLUMN `date` DATE;

#Q3 NULL VALUES OR BLANK VALUES

SELECT * FROM layoffs_2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT * FROM layoffs_2
WHERE industry IS NULL 
OR industry = '';

SELECT * FROM layoffs_2
WHERE company = 'airbnb';

SELECT t1.industry, t2.industry
FROM layoffs_2 t1
JOIN layoffs_2 t2
on t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

UPDATE layoffs_2 t1
JOIN layoffs_2 t2
   ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

UPDATE layoffs_2 
SET industry = null
WHERE industry = '';

SELECT * 
FROM layoffs_2;

DELETE
FROM layoffs_2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

#Q4 REMOVE ANY COLUMNS OR ROWS
ALTER TABLE layoffs_2
DROP COLUMN row_num;











