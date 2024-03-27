-- Problem Statement:
-- For pairs of brands in the same year (e.g. apple/samsung/2020 and samsung/apple/2020)
-- if custom1 = custom3 and custom2 = custom4: then keep only one pair
-- For pairs of brands in the same year
-- If custom1 != custom3 OR custom2 != custom4: then keep both pairs
-- For brands that do not have pairs in the same year: keep those rows as well 

INPUT: 
BRAND1	BRAND2	YEAR	CUSTOM1	CUSTOM2	CUSTOM3	CUSTOM4
apple	samsung	2020	1	2	1	2
samsung	apple	2020	1	2	1	2
apple	samsung	2021	1	2	5	3
samsung	apple	2021	5	3	1	2
google			2020	5	9		
oneplus	nothing	2020	5	9	6	3

OUTPUT
BRAND1	BRAND2	YEAR	CUSTOM1	CUSTOM2	CUSTOM3	CUSTOM4
apple	samsung	2020	1	2	1	2
apple	samsung	2021	1	2	5	3
samsung	apple	2021	5	3	1	2
oneplus	nothing	2020	5	9	6	3
google			2020	5	9		

QUERY: 

WITH CTE1 AS (
    SELECT *,
        CASE 
            WHEN BRAND1 < BRAND2 THEN CONCAT(BRAND1, BRAND2, YEAR)
            ELSE CONCAT(BRAND2, BRAND1, YEAR) 
        END AS PAIR_ID
    FROM PRODUCTS
), 
CTE2 AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY PAIR_ID ORDER BY BRAND1) AS RN
    FROM CTE1
)

SELECT BRAND1, BRAND2, YEAR, CUSTOM1, CUSTOM2, CUSTOM3, CUSTOM4
FROM CTE2
WHERE RN = 1 OR (CUSTOM1 <> CUSTOM3 OR CUSTOM2 <> CUSTOM4);
