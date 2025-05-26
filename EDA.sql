-- Exploratory Data Analysis
-- Here we are jsut going to explore the data and find trends or patterns or anything interesting like outliers
-- normally when you start the EDA process you have some idea of what you're looking for
-- with this info we are just going to look around and see what we find!

-- 1. View all records from the layoff table
SELECT * FROM layoff_table01;

-- 2. Get the maximum values of total_laid_off and percentage_laid_off
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoff_table01;

-- 3. Find records where 100% of employees were laid off, sorted by number of layoffs in descending order
SELECT *
FROM layoff_table01
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

-- 4. Find records where 100% of employees were laid off, sorted by funds raised in descending order
SELECT *
FROM layoff_table01
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- 5. Total layoffs per company, sorted by total layoffs in descending order
SELECT company, SUM(total_laid_off)
FROM layoff_table01
GROUP BY company
ORDER BY 2 DESC;

-- 6. Find the earliest and latest layoff dates in the data
SELECT MAX(`date`) AS max_date, MIN(`date`) AS min_date
FROM layoff_table01;

-- 7. Total layoffs per industry, sorted by total layoffs in descending order
SELECT industry, SUM(total_laid_off)
FROM layoff_table01
GROUP BY industry
ORDER BY 2 DESC;

-- 8. Total layoffs per country, sorted by total layoffs in descending order
SELECT country, SUM(total_laid_off)
FROM layoff_table01
GROUP BY country
ORDER BY 2 DESC;

-- 9. Total layoffs per day, sorted by date
SELECT `date`, SUM(total_laid_off)
FROM layoff_table01
GROUP BY `date`
ORDER BY 1;

-- 10. Total layoffs per year, sorted by year
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoff_table01
GROUP BY YEAR(`date`)
ORDER BY 1;

-- 11. Total layoffs per company stage (e.g., startup, public), sorted by total layoffs descending
SELECT stage, SUM(total_laid_off)
FROM layoff_table01
GROUP BY stage
ORDER BY 2 DESC;

-- 12. Monthly layoffs (YYYY-MM format), sorted by month
SELECT SUBSTRING(`date`, 1, 7) AS `month`, SUM(total_laid_off)
FROM layoff_table01
WHERE `date` IS NOT NULL
GROUP BY `month`
ORDER BY 1;

-- 13. Rolling total of layoffs by month
WITH rolling_total AS (
  SELECT SUBSTRING(`date`, 1, 7) AS `month`, SUM(total_laid_off) AS `off`
  FROM layoff_table01
  WHERE `date` IS NOT NULL
  GROUP BY `month`
  ORDER BY 1
)
SELECT `month`, `off`,
  SUM(`off`) OVER (ORDER BY `month`) AS rolling_total
FROM rolling_total;

-- 14. (Repeat) Total layoffs per company, sorted by total layoffs descending
SELECT company, SUM(total_laid_off)
FROM layoff_table01
GROUP BY company
ORDER BY 2 DESC;

-- 15. Yearly layoffs per company, sorted by total layoffs descending
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoff_table01
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

-- 16. Top 5 companies with highest layoffs per year using CTE and dense_rank
WITH company_year (company, `year`, total_laid_off) AS (
  SELECT company, YEAR(`date`), SUM(total_laid_off)
  FROM layoff_table01
  GROUP BY company, YEAR(`date`)
), company_year_ranking AS (
  SELECT *,
    DENSE_RANK() OVER (PARTITION BY `year` ORDER BY total_laid_off DESC) AS `rank`
  FROM company_year
  WHERE `year` IS NOT NULL
  ORDER BY `rank`
)
SELECT * 
FROM company_year_ranking
WHERE `rank` <= 5;