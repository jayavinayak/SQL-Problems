Problem Statement- Return the rows where the student scores higher than the previous test. 
INPUT
STUDENT:
TEST_ID  MARKS
100      55
101      55
102      60
103      58
104      40
105      50

OUTPUT 1
TEST_ID  MARKS
100      55
102      60
105      50

OUTPUT 2
TEST_ID  MARKS
102      60
105      50

QUERY FOR OUTPUT 1

WITH cte AS (
  SELECT 
    test_id, 
    marks, 
    LAG(marks, 1, 0) OVER (ORDER BY test_id) AS previous_marks
  FROM 
    students
)
SELECT 
  test_id, 
  marks 
FROM 
  cte 
WHERE 
  marks > previous_marks;
  
QUERY FOR OUTPUT 2

WITH cte AS (
	SELECT 
    test_id, 
    marks, 
    LAG(marks, 1, marks) OVER (ORDER BY test_id) AS previous_marks
  FROM 
    students
)
SELECT 
  test_id, 
  marks 
FROM 
  cte 
WHERE 
  marks > previous_marks;
  




