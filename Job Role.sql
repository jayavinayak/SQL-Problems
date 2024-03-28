PROBLEM STATEMENT -  DERIVE THE EXPECTED OUTPUT . 

INPUT 
ROW_ID  JOB_ROLE         SKILLS
1       Data Engineer    SQL
2                       Python
3                       AWS
4                       Snowflake
5                       Apache Spark
6       Web Developer   Java
7                       HTML
8                       CSS
9       Data Scientist  Python
10                      Machine Learning
11                      Deep Learning
12                      Tableau


OUTPUT 
ROW_ID  JOB_ROLE        SKILLS
1       Data Engineer   SQL
2       Data Engineer   Python
3       Data Engineer   AWS
4       Data Engineer   Snowflake
5       Data Engineer   Apache Spark
6       Web Developer   Java
7       Web Developer   HTML
8       Web Developer   CSS
9       Data Scientist  Python
10      Data Scientist  Machine Learning
11      Data Scientist  Deep Learning
12      Data Scientist  Tableau


QUERY:

WITH cte AS (
  SELECT 
    ROW_ID, 
    JOB_ROLE, 
    SKILLS, 
    SUM(CASE WHEN JOB_ROLE IS NOT NULL THEN 1 ELSE 0 END) OVER (ORDER BY ROW_ID) AS segment
  FROM 
    input_table
)
SELECT 
  ROW_ID, 
  FIRST_VALUE(JOB_ROLE) OVER (PARTITION BY segment ORDER BY ROW_ID) AS JOB_ROLE, 
  SKILLS
FROM 
  cte;
