
-- PROBLEM STATEMENT: Using the given Salary, Income and Deduction tables, first write an SQL query to populate the Emp_Transaction table , and create the second tabel

INPUT
SALARY
EMP_ID EMP_NAME BASE_SALARY
1 Rohan 5000
2 Alex 6000
3 Maryam 7000

INCOME
ID INCOME PERCENTAGE
1 Basic 100
2 Allowance 4
3 Others 6

DEDUCTION
ID DEDUCTION PERCENTAGE
1 Insurance 5
2 Health 6
3 House 4

OUTPUT 
EMP_ID | EMP_NAME | TRNS_TYPE | AMOUNT
1      | Rohan    | Insurance | 250
2      | Alex     | Insurance | 300
3      | Maryam   | Insurance | 350
1      | Rohan    | House     | 200
2      | Alex     | House     | 240
3      | Maryam   | House     | 280
1      | Rohan    | Basic     | 5000
2      | Alex     | Basic     | 6000
3      | Maryam   | Basic     | 7000
1      | Rohan    | Health    | 300
2      | Alex     | Health    | 360
3      | Maryam   | Health    | 420
1      | Rohan    | Allowance | 200
2      | Alex     | Allowance | 240
3      | Maryam   | Allowance | 280
1      | Rohan    | Others    | 300
2      | Alex     | Others    | 360
3      | Maryam   | Others    | 420

EMPLOYEE | BASIC | ALLOWANCE | OTHERS | GROSS | INSURANCE | HEALTH | HOUSE | TOTAL DEDUCTION
Alex     | 6000  | 240       | 360    | 6600  | 300       | 360    | 240   | 900
Maryam   | 7000  | 280       | 420    | 7700  | 350       | 420    | 280   | 1050
Rohan    | 5000  | 200       | 300    | 5500  | 250       | 300    | 200   | 750


INSERT INTO emp_transactions (EMP_ID, EMP_NAME, TRNS_TYPE, AMOUNT)
SELECT 
    s.EMP_ID, 
    s.EMP_NAME, 
    x.transtype, 
    CASE 
        WHEN x.transtype = 'Basic' THEN ROUND(s.BASE_SALARY * (i.PERCENTAGE / 100), 2)
        WHEN x.transtype = 'Allowance' THEN ROUND(s.BASE_SALARY * (i.PERCENTAGE / 100), 2)
        WHEN x.transtype = 'Others' THEN ROUND(s.BASE_SALARY * (i.PERCENTAGE / 100), 2)
        WHEN x.transtype IN ('Insurance', 'Health', 'House') THEN ROUND(s.BASE_SALARY * (d.PERCENTAGE / 100), 2)
    END as AMOUNT
FROM salary s
CROSS JOIN (
    SELECT INCOME as transtype, PERCENTAGE FROM income
    UNION
    SELECT DEDUCTION as transtype, PERCENTAGE FROM deduction
) x

SELECT 
  emp_name,
  SUM(CASE WHEN trns_type = 'Basic' THEN amount ELSE 0 END) AS basic,
  SUM(CASE WHEN trns_type = 'Allowance' THEN amount ELSE 0 END) AS allowance,
  SUM(CASE WHEN trns_type = 'Others' THEN amount ELSE 0 END) AS others,
  SUM(CASE WHEN trns_type = 'Insurance' THEN amount ELSE 0 END) AS insurance,
  SUM(CASE WHEN trns_type = 'Health' THEN amount ELSE 0 END) AS health,
  SUM(CASE WHEN trns_type = 'House' THEN amount ELSE 0 END) AS house,
  (SUM(CASE WHEN trns_type IN ('Basic', 'Allowance', 'Others') THEN amount ELSE 0 END) -
   SUM(CASE WHEN trns_type IN ('Insurance', 'Health', 'House') THEN amount ELSE 0 END)) as total deduction
FROM emp_transaction
GROUP BY emp_name;
