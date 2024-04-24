create database new_project1524
use new_project1524;

-----------------------------------------------------------------------------------------------------------------------------------------------------
--1.You are a Compensation analyst employed by a multinational corporation. Your
----Assignment is to Pinpoint Countries who give work fully remotely, for the title
----'managers’ Paying salaries Exceeding $90,000 USD

select * from Salaries;

select  company_location
from salaries 
where remote_ratio = 100 
and salary>90000 and job_title like '%manager%';


---------------------------------------------------------------------------------------------------------------------------------------------------------
--2. AS a remote work advocate Working for a progressive HR tech startup who
--place their freshers’ clients IN large tech firms. you are tasked WITH Identifying
--top 5 Country Having greatest count of large (company size) number of
--companies.

select  top 5 company_location,count(1) as no_of_large_com
from salaries 
where company_size='l' and experience_level='EN'
group by company_location
order by count(1) desc;

----------------------------------------------------------------------------------------------------------------------------------------------
--3. Picture yourself AS a data scientist Working for a workforce management
--platform. Your objective is to calculate the percentage of employees. Who
--enjoy fully remote roles WITH salaries Exceeding $100,000 USD, Shedding
--light ON the attractiveness of high-paying remote positions IN today's job
--market.


(select count(*)
as total_employee from salaries where salary>100000 and experience_level='En')

declare @cnt int
set @cnt= (select count(*) as total_employee from salaries where salary>100000)
declare @entry int
set @entry = (select count(*)
as total_employee from salaries where salary>100000 and experience_level='En')

declare @percentage float
set @percentage = (select @entry)*1.0/(select @cnt)
select @cnt
select @entry
select @percentage


-------------------------------------------------------------------------------------------------------------------------------------------------
--4. Imagine you are a data analyst Working for a global recruitment agency. Your
--Task is to identify the Locations where entry-level average salaries exceed the
--average salary for that job title IN market for entry level, helping your agency
--guide candidates towards lucrative opportunities.

select  jobs,location_ ,avg_salary,average_salary from (select job_title as jobs ,avg(salary)avg_salary
from salaries 
where experience_level='en'
group by job_title)a 
join 
(
select job_title as jobs2,company_location as location_,avg(salary)average_salary
from salaries
where experience_level='en'
group by job_title,company_location
)b 
on a.jobs =b.jobs2 and a.avg_salary<b.average_salary;


---------------------------------------------------------------------------------------------------
select * from salaries

--You ve been hired by a big HR Consultancy to look at how much people get
--paid IN different Countries. Your job is to Find out for each job title which.
--Country pays the maximum average salary. This helps you to place your
--candidates IN those countries.

select company_location,job_title,average from (
select company_location,job_title,avg(salary)average,
dense_rank() over(partition by job_title order by avg(salary_in_usd) desc)rnk
from salaries 
group by company_location,job_title
)x
where x.rnk=1;

-----------------------------------------------------------------------------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------------
--6. Picture yourself AS a workforce strategist employed by a global HR tech
--startup. Your Mission is to Determine the percentage of fully remote work for
--each experience level IN 2021 and compare it WITH the corresponding figures
--for 2024, Highlighting any significant Increases or decreases IN remote work
--Adoption over the years.

select * from salaries
select * from (
select * from (
select experience_level as exp_a,count(1) as total
from salaries 
where work_year =2021 
group by experience_level
) a 
join(
select experience_level as exp_b,count(1) as cnt 
from salaries 
where work_year =2021 and remote_ratio=100
group by experience_level)b 
on a.exp_a=b.exp_b)x
join 
(

select * from (
select experience_level as exp_c,count(1) as total
from salaries 
where work_year =2024 
group by experience_level
) c
join(
select experience_level as exp_d,count(1) as cnt 
from salaries 
where work_year =2024 and remote_ratio=100
group by experience_level)d
on c.exp_c=d.exp_d)y
on x.exp_a=y.exp_c and x.exp_b=y.exp_d
-------------------------------------------------------------------------------------------------------------------------------------------------------------
--8. AS a Compensation specialist at a Fortune 500 company, you are tasked WITH
--analyzing salary trends over time. Your objective is to calculate the average
--salary increase percentage for each experience level and job title between the
--years 2023 and 2024, helping the company stay competitive IN the talent
--market.

select a.experience_level,a.job_title,avgerage_salary_2023,avgerage_salary_2024,(avgerage_salary_2024-avgerage_salary_2023)*100/avgerage_salary_2023 as change_in_salary from (
select experience_level,job_title,(avg(salary) )avgerage_salary_2023
from salaries 
where work_year in (2023)
group by experience_level,job_title
) a
join 
(
select experience_level,job_title,avg(salary) avgerage_salary_2024
from salaries 
where work_year in (2024)
group by experience_level,job_title
)b on a.experience_level=b.experience_level and a.job_title=b.job_title;

------------------------------------------------------------------------------------------------------------------------------------------
--9. You are a database administrator tasked with role-based access control for a
--companys employee database. Your goal is to implement a security measure
--where employees in different experience level (e.g. Entry Level, Senior level
--etc.) can only access details relevant to their respective experience level,
--ensuring data confidentiality and minimizing the risk of unauthorized access.
-----------------------------------------------------------------------------------------------------------------
--10



---11As a market researcher, your job is to Investigate the job market for a company that analyzes workforce data.
--Your Task is to know how many people were employed IN different types of companies
--AS per their size IN 2021.
select company_size,count(1)number_of_people_employed from salaries
where work_year=2021
group by company_size



------------------------------------------------------------------------------------------------------------------------------------------------------
--Imagine you are a talent Acquisition specialist Working for an International recruitment agency. 
--Your Task is to identify the top 3 job titles that command the highest average salary Among part-time Positions IN the year 2023. 
--However, you are Only Interested IN Countries WHERE there are more than 50 employees,
---Ensuring a robust sample size for your analysis.


select * from (
select company_location,count(company_location)cnt from salaries
group by company_location
having count(company_location)>50)a
join (
select company_location,job_title,avg(salary)average_salary
from salaries
where work_year=2023 and employment_type='pt'
group by company_location,job_title)b
on a.company_location=b.company_location
---------------------------------------------------------------------------------------------------------------------------------------------------------
--As a database analyst you have been assigned the task to 
--Select Countries where average mid-level salary is higher than overall mid-level salary for the year 2023.

select a.company_location,salary_2023,average_salary_overall from (
select company_location,(salary)salary_2023
from salaries 
where work_year =2023 and experience_level='mi'
)a
join 
(
select company_location,avg(salary) average_salary_overall
from salaries 
where experience_level='mi'
group by company_location)b
on a.company_location=b.company_location and average_salary_overall>salary_2023

--------------------------------------------------------------------------------------------------------------------------------------------------------
---As a database analyst you have been assigned the task to
---Identify the company locations with the highest and lowest average salary for senior-level (SE) employees in 2023.
use new_project1524
select location ,average_salary from (
selecT company_location as location,(avg(salary) )average_salary,
dense_rank() over( order by avg(salary) desc)rnk_desc,
dense_rank() over( order by avg(salary)asc)rnk_asc
from salaries 
where work_year=2023 and experience_level='Se'
group by company_location
)x
where x.rnk_desc=1 or x.rnk_asc=1

------------------------------------------------------------------------------------------------------------------------------------------------------
--You're a Financial analyst Working for a leading HR Consultancy,
--and your Task is to Assess the annual salary growth rate for various job titles.
--By Calculating the percentage Increase IN salary FROM previous year to this year,
---you aim to provide valuable Insights Into salary trends WITHIN different job roles.

with my_cte as (
select distinct job_title,work_year,sum(salary) over(partition by job_title order by work_year)salary
from salaries 
), cte as (
select job_title,work_year,salary,lag(salary) over(partition by job_title order by work_year)previous_salary
from my_cte 
)
select job_title,work_year,salary,previous_salary,round(coalesce((salary-previous_salary)*100/previous_salary,0.0) ,2)pct
from cte 
use new_project1524
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
--You've been hired by a global HR Consultancy to identify Countries experiencing significant salary growth for entry-level roles.
--Your task is to list the top three Countries with the highest salary growth rate FROM 2020 to 2023,
--Considering Only companies with more than 50 employees, helping multinational Corporations identify Emerging talent markets.

with mycte as (
select work_year,location,salary as salary from (
select company_location as location,count(company_location)cnt
from salaries 
group by company_location
having count(company_location)>50)a
join 
(
select company_location,salary,work_year
from salaries where experience_level='en' and work_year in (2020,2021,2022,2023)
)b
on a.location=b.company_location
),cte as (
select work_year,location,sum(salary)salary,lag(sum(salary)) over(partition by location order by work_year)previous_salary
from mycte
group by work_year,location
)
select work_year,location,salary,previous_salary ,(salary-previous_salary)*100/previous_salary as pct
from cte 
--------------------------------------------------------------------------------------------------------------------------------------------------------
---Picture yourself as a data architect responsible for database management. 
--Companies in US and AU(Australia) decided to create a hybrid model for employees they decided that employees earning salaries exceeding $90000 USD,
--will be given work from home. You now need to update the remote work ratio for eligible employees, 
--ensuring efficient remote work management while implementing appropriate error handling mechanisms for invalid input parameters.

select * from salaries 
where company_location in ('us','au') and salary > 90000

update salaries 
set remote_ratio = case when company_location in ('us','au') and salary > 90000 then 100 else 0 end ;


-------------------------------------------------------------------------------------------------------------------------------------------------------
--In the year 2024, due to increased demand in the data industry, there was an increase in salaries of data field employees.
--Entry Level-35% of the salary.
--Mid junior – 30% of the salary.
--Immediate senior level- 22% of the salary.
--Expert level- 20% of the salary.
--Director – 15% of the salary.

select distinct experience_level from salaries 

update salaries 
---set salary_in_usd = case when work_year =2024 and experience_level = 'en' then salary_in_usd+(salary_in_usd*0.35) end 
set salary_in_usd = case when work_year =2024 and experience_level = 'mi' then salary_in_usd+(salary_in_usd*0.30) end 
update salaries
set salary_in_usd = case when work_year =2024 and experience_level = 'mi' then salary_in_usd+(salary_in_usd*0.30) end 
update salaries 
set salary_in_usd = case when work_year =2024 and experience_level = 'se' then salary_in_usd+(salary_in_usd*0.22) end 
update salaries 
set salary_in_usd = case when work_year =2024 and experience_level = 'ex' then salary_in_usd+(salary_in_usd*0.15) end 

select * from salaries 
where work_year=2024

--------------------------------------------------------------------------------------------------------------------------------------------------------------
 alter table salaries 
 drop column salary_in_usd

 ------------------------------------------------------------------------------------------------------------------------------------------------------------------
 --You are a researcher and you have been assigned the task to Find the year with the highest average salary for each job title.
 select year,job_title,cast(average_salary as decimal(9,2))average_salary from (
 select work_year as year ,job_title,avg(salary)average_salary,
 dense_rank() over(partition by job_title order by avg(salary) desc)rnk from salaries 
 group by work_year,job_title
 )x
 where x.rnk=1
 order by year,job_title

 --------------------------------------------------------------------------------------------------------------------------------------------------------
 --You have been hired by a market research agency where you been assigned the task to show the 
 ---percentage of different employment type (full time, part time) in Different job roles, 
 ---in the format where each row will be job title, each column will be type of employment type and 
 ----cell value for that row and column will show the % value.

 select employment_type,concat(cast(count(*)*1.0/(select count(*) from salaries)*100 as decimal(4,2)) ,' ','%')pct
 from salaries 
 group by employment_type;

