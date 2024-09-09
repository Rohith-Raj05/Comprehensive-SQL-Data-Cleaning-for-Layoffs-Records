-- Creating SQL Project 

select * from layoffs;

-- Removing all the duplicates 

-- first step is creating the duplicate table so that we can work on the duplicate table inorder to preserve the original data if we do any mistakes to original table

create table layoffs_dup like layoffs; 

select * from layoffs_dup ;

-- adding the data into the duplicate table

insert into layoffs_dup 
select * from layoffs;


-- creating a row number to check for the duplicate rows with combing all the colums as unique column 

select * ,	 
row_number() over(partition by company, location,industry,total_laid_off, percentage_laid_off , date, stage , country , funds_raised_millions) as row_num 
from layoffs_dup;

-- secting all the rows whose row number is greater than 1

with dup_rows as (
select * ,	 
row_number() over(partition by company, location,industry,total_laid_off, percentage_laid_off , date, stage , country , funds_raised_millions) as row_num 
from layoffs_dup
) 
select * from dup_rows
where row_num >1;

-- to delete this we can't just use the delete statements as the mysql server will not allow to use this 
-- so we will create a another table to store them and then we will delete the duplicate rows

CREATE TABLE `remove_dup_layoffs` (
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

select * from remove_dup_layoffs;

-- insert the values of the dup rows with row_column into this table 

insert into remove_dup_layoffs
(
select * ,	 
row_number() over(partition by company, location,industry,total_laid_off, percentage_laid_off , date, stage , country , funds_raised_millions) as row_num 
from layoffs_dup
);

select * from remove_dup_layoffs;

-- selecting all the rows with row number greater than 1

select * from remove_dup_layoffs
where row_num >1;

-- deleting all the rows whose row number is greater than 1 or contains duplicates 


delete from remove_dup_layoffs
where row_num >1;


-- selecting to see if it is deleted or not

select * from remove_dup_layoffs
where row_num > 1;

select * from remove_dup_layoffs;

select distinct company from remove_dup_layoffs order by 1;

-- removing all the spaces before and after company name

select distinct company , trim(company) from remove_dup_layoffs order by 1;

-- removing spacing before company name


update remove_dup_layoffs 
set company = trim(company);

select * from remove_dup_layoffs;

select distinct industry from remove_dup_layoffs order by 1;

-- checking for industry column
select * from remove_dup_layoffs where industry like 'crypto%';

-- updating the industry column whose name is different 

update remove_dup_layoffs 
set industry = "Crypto"
where industry like 'Crypto%';

-- checking fro country name 

select distinct  country from remove_dup_layoffs order by 1;

select * from remove_dup_layoffs where country like 'united states%';

update remove_dup_layoffs 
set country = trim(trailing '.' from country)
where country like 'united states%';

select distinct country from remove_dup_layoffs order by 1;

select * from remove_dup_layoffs;

-- changing the data type of date to date from text

select date from remove_dup_layoffs;

update remove_dup_layoffs
set `date` = str_to_date(`date`, "%m/%d/%Y") ;

select date from remove_dup_layoffs;

-- altering the columns data type from text to date

alter table remove_dup_layoffs
modify column `date` DATE;

-- adding the industry values to the rows which has null instead of industry type based on the record it has in the database already 


select distinct(industry) from remove_dup_layoffs order by 1;

select * from remove_dup_layoffs 
where company = 'Airbnb';

update remove_dup_layoffs
set industry = null
where industry = '';

select * from
remove_dup_layoffs a
join remove_dup_layoffs b 
on a.company = b.company and a.location = b.location
where a.industry is null and b.industry is not null;


update remove_dup_layoffs a 
join remove_dup_layoffs b 
on a.company = b.company and a.location = b.location
set a.industry = b.industry
where a.industry is null and b.industry is not null;

select * from remove_dup_layoffs
where industry is null;

select * from remove_dup_layoffs
where company = "Airbnb";

-- removing all the rows of total_laid_of and perecentage_laid_off is null

select * from remove_dup_layoffs 
where total_laid_off is NULL OR total_laid_off = ' ';

-- selecting all the rows whose laid of is null

select * from remove_dup_layoffs 
where (total_laid_off is NULL OR total_laid_off = ' ')
AND percentage_laid_off is null ;


-- deleting all the rows whose total_laid_off and percentage_laid_off is null

select * from remove_dup_layoffs 
where (total_laid_off is NULL OR total_laid_off = ' ')
AND percentage_laid_off is null ;

delete  from remove_dup_layoffs 
where (total_laid_off is NULL OR total_laid_off = ' ')
AND percentage_laid_off is null ;


 -- removing the row number table 
 
 alter table remove_dup_layoffs 
 drop column row_num;
 
 select * from remove_dup_layoffs;
 
 select industry , sum(total_laid_off) from remove_dup_layoffs
 where total_laid_off is not null 
 group  by industry ;
 
 -- getting/ grouping by year
 
 select  sum(total_laid_off) , substring(`date`,1,7) as year_mon from remove_dup_layoffs 
 group by substring(`date`,1,7)	
 order by substring(`date`,1,7);
 
 
-- using common expression tables CTE

with rolling_total as(
select  sum(total_laid_off) as total_laid_off_per_month, substring(`date`,1,7) as year_mon from remove_dup_layoffs 
group by substring(`date`,1,7)	
order by substring(`date`,1,7)
)
select year_mon, total_laid_off_per_month,
sum(total_laid_off_per_month)over(order by year_mon) as rolling_total
from rolling_total
where year_mon is not null
order by year_mon
;


-- we will sort the company and check for total laid off per year
 select * from remove_dup_layoffs;

select company , year(`date`) , sum(total_laid_off) 
from remove_dup_layoffs
group by company , year(`date`)
order by 2;

-- we will now rank to check for the top 5 companies

select company , year(`date`) , sum(total_laid_off) ,
dense_rank() over(partition by year(`date`) order by sum(total_laid_off)) as ranking
from remove_dup_layoffs
where year(`date`) is not null  and sum(total_laid_off) is not null	
group by company , year(`date`)
order by year(`date`) ,sum(total_laid_off) ;



SELECT company, YEAR (`date`) , SUM(total_laid_off)
FROM remove_dup_layoffs
GROUP BY company, YEAR(`date`)
order by 1;

with company_list (company , year, sum_of_laid_off)as(
select company , year(`date`) , sum(total_laid_off) 
from remove_dup_layoffs
group by company , year(`date`)
order by 1
) ,
company_ranks as(
select *,
dense_rank() over(partition by year order by sum_of_laid_off desc) as ranking 
from company_list
where year is not null
)
select * 
from company_ranks 
where ranking <=5;
-- we will now rank the top 5 company laid off every year

select company , total_laid_off , year(`date`),
dense_rank() over(partition by year(`date`) order by total_laid_off desc) as ranking 
from remove_dup_layoffs
where year(`date`) is not null
;



