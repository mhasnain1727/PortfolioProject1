-- Question Link - https://www.hackerrank.com/challenges/the-report/problem

Select If(GRADE < 8, NULL, NAME), GRADE, MARKS
From STUDENTS JOIN GRADES
Where MARKS BETWEEN MIN_MARK AND MAX_MARK
Order by GRADE desc, NAME
