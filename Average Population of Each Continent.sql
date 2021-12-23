-- Question Link - https://www.hackerrank.com/challenges/average-population-of-each-continent/problem

select co.continent, avg(cy.population) 
from country as co inner join city cy
on co.code = cy.countrycode
group by co.continent
