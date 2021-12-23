-- Question Link - https://www.hackerrank.com/challenges/earnings-of-employees/problem

select max(salary*months), count(salary*months) 
from employee 
where salary*months in (select max(salary*months) from employee)

-- Another way (MS SQL Server)

select top 1 max(salary*months), count(salary*months)
from employee
group by salary*months
order by salary*months desc

-- Another way

select max(salary*months), count(salary*months)
from employee
group by salary*months
order by salary*months desc limit 1

