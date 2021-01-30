-- 1
DROP MATERIALIZED VIEW view_1;

CREATE MATERIALIZED VIEW view_1 AS 
SELECT price, feedback
FROM tickets
WHERE gender = 'W' and country = 'Австрия';

-- 2
DROP VIEW view_2;

CREATE VIEW view_2 AS 
SELECT price, feedback
FROM tickets
WHERE gender = 'W' and country = 'Австрия';

-- 3
DROP VIEW view_3;

CREATE VIEW view_3 AS 
SELECT cruise_id, place, price
FROM tickets
WHERE gender = 'M' AND (country = 'Андорра' OR country = 'Албания');


-- comp
SELECT *
FROM view_1
WHERE price > money(50000);

SELECT *
FROM view_2
WHERE price > money(50000);

SELECT *
FROM view_3
WHERE price > money (50000);
