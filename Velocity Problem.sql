PROBLEM STATEMENT - DERIVE THE OUTPUT
INPUT
LEVELS
client  auto  repair_date  indicator  value
c1      a1    2022         level      good
c1      a1    2022         velocity   90
c1      a1    2023         level      regular
c1      a1    2023         velocity   80
c1      a1    2024         level      wrong
c1      a1    2024         velocity   70
c2      a1    2022         level      good
c2      a1    2022         velocity   90
c2      a1    2023         level      wrong
c2      a1    2023         velocity   50
c2      a2    2024         level      good
c2      a2    2024         velocity   80

 OUTPUT
velocity | good | wrong | regular
50       | 0    | 1     | 0
70       | 0    | 1     | 0
80       | 1    | 0     | 1
90       | 2    | 0     | 0

QUERY: 
SELECT 
    v.repair_date, 
    v.velocity, 
    COUNT(CASE WHEN l.value = 'good' THEN 1 END) AS good,
    COUNT(CASE WHEN l.value = 'wrong' THEN 1 END) AS wrong,
    COUNT(CASE WHEN l.value = 'regular' THEN 1 END) AS regular
FROM 
    (SELECT repair_date, value  AS velocity FROM LEVELS WHERE indicator = 'level') l 
    ON v.repair_date = l.repair_date
GROUP BY 
    v.repair_date, v.velocity
ORDER BY 
    v.velocity;

