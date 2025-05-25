## -- Data Cleaning

select * 
from first_data.layoffs;

-- now when we are data cleaning we usually follow a few steps
-- 1. check for duplicates and remove any
-- 2. standardize data and fix errors
-- 3. Look at null values and see what 
-- 4. remove any columns and rows that are not necessary - few ways

create table layoff_table
like layoffs;

select * from layoff_table;

insert layoff_table
select * 
from layoffs;

select * ,
row_number() over(partition by company, industry, total_laid_off, percentage_laid_off, `date`) as row_num
from layoff_table;

with duplicate_cte as (
select * ,
row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoff_table
)
select *
from duplicate_cte
where row_num >1 ;

select * from layoff_table
where company='Casper';

with duplicate_cte as (
select * ,
row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoff_table
)
delete
from duplicate_cte
where row_num >1 ;

-- 1. check for duplicates and remove any

-- Create Table

CREATE TABLE `layoff_table01` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select * from layoff_table01;

-- Insert Value
 
insert into layoff_table01
select * ,
row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoff_table;

-- Select Condition

select * 
from layoff_table01
where row_num >1 ;

-- Delete
delete 
from layoff_table01
where row_num >1 ;

select * 
from layoff_table01;

-- 2. standardize data and fix errors

select company , trim(company)
from layoff_table01;

-- Update  
update layoff_table01
set company =trim(company);

select distinct industry
from layoff_table01
order by 1;

select *
from layoff_table01
where industry like 'crypto%';

-- update crypto%

update layoff_table01
set industry='crypto'
where industry like 'crypto%';

select distinct industry
from layoff_table01;

select distinct location
from layoff_table01
order by 1;

select distinct country
from layoff_table01
order by 1;

-- update layoff_table01
-- set country='United States'
-- where country like 'United States%';

-- Trailing for Update

update layoff_table01
set country=trim(trailing '.' from country)
where country like 'United States%';

select *
from layoff_table01;

-- fixed the date format

select `date`,
str_to_date(`date`,'%m/%d/%Y')
from layoff_table01;

-- update the date format

update layoff_table01
set `date`=str_to_date(`date`,'%m/%d/%Y');

select `date`
from layoff_table01;

-- update data type

alter table layoff_table01
modify column `date` date;

select *
from layoff_table01;

-- 3. Look at null values and see what

select *
from layoff_table01
where total_laid_off is null
and percentage_laid_off is null;

update layoff_table01
set industry= null
where industry = '';

select *
from layoff_table01
where industry is null
or industry='';

select *
from layoff_table01
where company = 'Airbnb';

select *
from layoff_table01 t1
	join layoff_table01 t2
    on t1.company=t2.company
	and t1.location=t2.location
where (t1.industry is null or t1.industry ='')
	and t2.industry is not null;

select t1.industry,t2.industry
from layoff_table01 t1
	join layoff_table01 t2
    on t1.company=t2.company 
where (t1.industry is null or t1.industry ='')
	and t2.industry is not null;
    
update layoff_table01 t1
	join layoff_table01 t2
	on t1.company=t2.company
set t1.industry=t2.industry
where t1.industry is null
	and t2.industry is not null;
    
select *
from layoff_table01;

-- 4. remove any columns and rows we need to

select *
from layoff_table01
where total_laid_off is null
and percentage_laid_off is null;

delete
from layoff_table01
where total_laid_off is null
and percentage_laid_off is null;

alter table layoff_table01
drop column row_num;

select *
from layoff_table01;
