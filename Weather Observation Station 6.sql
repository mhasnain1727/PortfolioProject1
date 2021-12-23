-- Question Link - https://www.hackerrank.com/challenges/weather-observation-station-6/problem?h_r=next-challenge&h_v=zen&h_r=next-challenge&h_v=zen&h_r=next-challenge&h_v=zen&h_r=next-challenge&h_v=zen&h_r=next-challenge&h_v=zen&h_r=next-challenge&h_v=zen&h_r=next-challenge&h_v=zen&h_r=next-challenge&h_v=zen&h_r=next-challenge&h_v=zen

select city
from station
where substring(city,1,1) = 'a' or substring(city,1,1) = 'e' or substring(city,1,1) = 'i' or substring(city,1,1) = 'o' or substring(city,1,1) = 'u' 

-- or a better way of doing it

SELECT DISTINCT city 
from station 
where city LIKE '[a, e, i, o, u]%'
