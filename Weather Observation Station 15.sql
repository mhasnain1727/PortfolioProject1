-- Question Link - https://www.hackerrank.com/challenges/weather-observation-station-15/problem

select round(long_w, 4)
from station
where lat_n = ( select max(lat_n)
                from station
                where lat_n < 137.2345);
                
-- Another mwthod

SELECT ROUND(LONG_W, 4)
FROM STATION
WHERE LAT_N < 137.2345
ORDER BY LAT_N DESC
LIMIT 1;
