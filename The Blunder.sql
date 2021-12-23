-- Question Link - https://www.hackerrank.com/challenges/the-blunder/problem

select ceil(avg(salary) - avg(cast(replace(salary, 0, '') as int)))
from employees
