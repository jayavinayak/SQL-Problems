PROBLEM STATEMENT : 
Given vacation_plans tables shows the vacations applied by each employee during the year 2024.
Leave_balance table has the available leaves for each employee.
Write an SQL query to determine if the vacations applied by each employee can be approved or not based on the available leave balance.
If an employee has sufficient available leaves then mention the status as "Approved" else mention "Insufficient Leave Balance".
Assume there are no public holidays during 2024. weekends (sat & sun) should be excluded while calculating vacation days.
VACATION PLAN
ID  EMP_ID  FROM_DT     TO_DT
1   1       12/02/2024  16/02/2024
2   2       20/02/2024  29/02/2024
3   3       01/03/2024  31/03/2024
4   1       11/04/2024  23/04/2024
5   4       01/06/2024  30/06/2024
6   3       05/07/2024  15/07/2024
7   3       28/08/2024  15/09/2024

LEAVE BALANCE
EMP_ID  BALANCE
1       12
2       10
3       26
4       20
5       14

OUTPUT
ID  EMP_ID  FROM_DT     TO_DT       VACATION_DAYS  STATUS
1   1       12/02/2024  16/02/2024  5              Approved
2   2       20/02/2024  29/02/2024  8              Approved
3   3       01/03/2024  31/03/2024  21             Approved
5   4       01/06/2024  30/06/2024  20             Approved
4   1       11/04/2024  23/04/2024  9              Insufficient Leave Balance
6   3       05/07/2024  15/07/2024  7              Insufficient Leave Balance
7   3       28/08/2024  15/09/2024  13             Insufficient Leave Balance

QUERY: 
WITH RECURSIVE cte AS (
    WITH cte_data AS (
        SELECT 
            v.id, 
            v.emp_id, 
            v.from_dt, 
            v.to_dt,
            l.balance AS leave_balance, 
            COUNT(d.dates) AS vacation_days,
            ROW_NUMBER() OVER (PARTITION BY v.emp_id ORDER BY v.emp_id, v.id) AS rn
        FROM 
            vacation_plans v
        CROSS JOIN LATERAL (
            SELECT 
                CAST(dates AS DATE) AS dates, 
                TRIM(TO_CHAR(dates, 'Day')) AS day
            FROM 
                GENERATE_SERIES(v.from_dt, v.to_dt, '1 Day') AS dates
        ) d
        JOIN 
            leave_balance l 
            ON l.emp_id = v.emp_id
        WHERE 
            day NOT IN ('Saturday', 'Sunday')
        GROUP BY 
            v.id, v.emp_id, v.from_dt, v.to_dt, l.balance
    )
    SELECT 
        *, 
        (leave_balance - vacation_days) AS remaining_balance
    FROM 
        cte_data 
    WHERE 
        rn = 1
    
    UNION ALL
    
    SELECT 
        cd.*, 
        (cte.remaining_balance - cd.vacation_days) AS remaining_balance
    FROM 
        cte 
    JOIN 
        cte_data cd 
        ON cd.rn = cte.rn + 1 AND cd.emp_id = cte.emp_id
)
SELECT 
    id, 
    emp_id, 
    from_dt, 
    to_dt, 
    leave_balance, 
    vacation_days,
    CASE 
        WHEN remaining_balance < 0 THEN 'Insufficient Leave Balance' 
        ELSE 'Approved' 
    END AS status
FROM 
    cte;
