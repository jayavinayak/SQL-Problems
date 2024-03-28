Problem Statement - Derive the expected output

INPUT:
ID    NAME     LOCATION
1
2     David
3              London
4
5     David

EXPECTED OUTPUT - 1:
ID    NAME     LOCATION
1     David    London

EXPECTED OUTPUT - 2:
ID    NAME     LOCATION
5     David    London


QUERY: 

SELECT MIN(id) AS id, MAX(name) AS name, MAX(location) AS location
FROM input_table;

SELECT MAX(id) AS id, MAX(name) AS name, MAX(location) AS location
FROM input_table;
