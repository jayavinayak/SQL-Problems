PROBLEM STATEMENT:
-- Write a SQL query to return the footer values from the input table, 
-- meaning all the last non-null values from each field as shown in the expected output.

INPUT:
ID | CAR            | LENGTH | WIDTH | HEIGHT
1  | Hyundai Tucson | 15     | 6     | 20
2  | NULL           | NULL   | 12    | 8
3  | NULL           | NULL   | NULL  | 15
4  | Toyota Rav4    | NULL   | NULL  | NULL
5  | Kia Sportage   | 12     | 15    | 18

OUTPUT 
CAR          | LENGTH | WIDTH | HEIGHT
Kia Sportage | 12     | 15    | 18


QUERY: 

SELECT
  (SELECT CAR FROM input_table WHERE CAR IS NOT NULL ORDER BY ID DESC LIMIT 1) AS CAR,
  (SELECT LENGTH FROM input_table WHERE LENGTH IS NOT NULL ORDER BY ID DESC LIMIT 1) AS LENGTH,
  (SELECT WIDTH FROM input_table WHERE WIDTH IS NOT NULL ORDER BY ID DESC LIMIT 1) AS WIDTH,
  (SELECT HEIGHT FROM input_table WHERE HEIGHT IS NOT NULL ORDER BY ID DESC LIMIT 1) AS HEIGHT;
