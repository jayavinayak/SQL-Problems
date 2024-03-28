PROBLEM STATEMENT -  In the given input table DAY_INDICATOR field indicates the day of the week with the first character being Monday, followed by Tuesday and so on.
Write a query to filter the dates column to showcase only those days where day_indicator character for that day of the week is 1

PRODUCTS
PRODUCT_ID    DAY_INDICATOR    DATES
AP755         1010101          04/03/2024
AP755         1010101          05/03/2024
AP755         1010101          06/03/2024
AP755         1010101          07/03/2024
AP755         1010101          08/03/2024
AP755         1010101          09/03/2024
AP755         1010101          10/03/2024
XQ802         1000110          04/03/2024
XQ802         1000110          05/03/2024
XQ802         1000110          06/03/2024
XQ802         1000110          07/03/2024
XQ802         1000110          08/03/2024
XQ802         1000110          09/03/2024
XQ802         1000110          10/03/2024


WITH cte AS (
    SELECT 
        PRODUCT_ID,
        DAY_INDICATOR, 
        DATES,
        CASE 
            WHEN SUBSTRING(DAY_INDICATOR, EXTRACT(ISODOW FROM DATES)::INTEGER, 1) = '1' 
            THEN 'include' 
            ELSE 'exclude' 
        END AS segment
    FROM 
        PRODUCTS 
)
SELECT 
    PRODUCT_ID, 
    DAY_INDICATOR, 
    DATES
FROM 
    cte 
WHERE 
    segment = 'include';
