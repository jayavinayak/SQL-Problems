 -- ski resort company is planning to construct a new ski slope using a pre-existing network of mountain huts and trails between them.
 -- A new slope has to begin at one of the mountain huts, have a middle station at another hut connected with the first one by a direct trail,
 -- and end at the third mountain hut which is also connected by a direct trail to the second hut.
 -- The altitude of the three huts chosen for constructing the ski slope has to be strictly decreasing.
 
 -- INPUT 
--  Mountain Huts 
 Id	Name		Altitude
1	Dakonat		1900
2	Natisa		2100
3	Gajantut	1600
4	Rifat		782
5	Tupur		1370

-- Trails 
Hut1	Hut2
1	3
3	2
3	5
4	5
1	5

-- OUTPUT 
startpt	  middlept	endpt
Dakonat.  Gajantut	Tupur
Dakonat	  Tupur		Rifat
Gajantut. Tupur		Rifat
Natisa	  Gajantut	Tupur

WITH cte_trails1 AS (
    SELECT 
        t1.hut1 AS start_hut, 
        h1.name AS start_hut_name,
        h1.altitude AS start_hut_altitude, 
        t1.hut2 AS end_hut
    FROM 
        mountain_huts h1
        JOIN trails t1 ON t1.hut1 = h1.id
),
cte_trails2 AS (
    SELECT 
        t2.start_hut, 
        t2.start_hut_name, 
        t2.start_hut_altitude, 
        t2.end_hut, 
        h2.name AS end_hut_name, 
        h2.altitude AS end_hut_altitude,
        CASE 
            WHEN t2.start_hut_altitude > h2.altitude THEN 1 
            ELSE 0 
        END AS altitude_flag
    FROM 
        cte_trails1 t2
        JOIN mountain_huts h2 ON h2.id = t2.end_hut
),
cte_final AS (
    SELECT 
        CASE WHEN altitude_flag = 1 THEN start_hut ELSE end_hut END AS start_hut,
        CASE WHEN altitude_flag = 1 THEN start_hut_name ELSE end_hut_name END AS start_hut_name ,
	CASE WHEN altitude_flag = 1 THEN end_hut ELSE start_hut END AS end_hut,
        CASE WHEN altitude_flag = 1 THEN end_hut_name ELSE start_hut_name END AS end_hut_name
    FROM 
        cte_trails2
)
SELECT 
    c1.start_hut_name AS startpt, 
    c1.end_hut_name AS middlept, 
    c2.end_hut_namaet AS endpt
FROM 
    cte_final c1
JOIN  cte_final c2 ON c1.end_hut = c2.start_hut;



