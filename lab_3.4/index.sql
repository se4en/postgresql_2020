-- 1 
CREATE INDEX TICKETS_price ON tickets (price); -- 34 sec

-- without INDEX:

-- Gather  (cost=1000.00..1116177.10 rows=74791 width=197) (actual time=1.131..12219.100 rows=8208 loops=1)"
--   	Workers Planned: 2
--   	Workers Launched: 2
--   	->  Parallel Seq Scan on tickets  (cost=0.00..1107698.00 rows=31163 width=197) (actual time=3.083..12202.071 rows=2736 loops=3)"
--         	Filter: (sold AND (price > '30 000,00 ₽'::money) AND (price < '30 100,00 ₽'::money) AND (passenger_id > 500000))"
--         	Rows Removed by Filter: 9997264"
-- Planning Time: 0.285 ms
-- Execution Time: 12220.720 ms

SELECT * FROM tickets
WHERE price > money('30000')
AND price < money('30100')
AND passenger_id > 500000
AND sold = true;

EXPLAIN ANALYZE SELECT * FROM tickets
WHERE price > money('30000')
AND price < money('30100')
AND passenger_id > 500000
AND sold = true;

DROP INDEX IF EXISTS TICKETS_price;


-- 2
CREATE INDEX TICKETS_price_order ON tickets (price DESC NULLS LAST); -- 29 sec

-- without INDEX:

--"Limit  (cost=1164015.40..1164027.07 rows=100 width=397) (actual time=13662.028..13751.259 rows=100 loops=1)"
--"  ->  Gather Merge  (cost=1164015.40..1192481.95 rows=243982 width=397) (actual time=13662.027..13751.250 rows=100 loops=1)"
--"        Workers Planned: 2"
--"        Workers Launched: 2"
--"        ->  Sort  (cost=1163015.38..1163320.35 rows=121991 width=397) (actual time=13659.614..13659.654 rows=76 loops=3)"
--"              Sort Key: t.price DESC"
--             Sort Method: top-N heapsort  Memory: 121kB"
--             Worker 0:  Sort Method: top-N heapsort  Memory: 121kB"
--             Worker 1:  Sort Method: top-N heapsort  Memory: 124kB"
--             ->  Parallel Hash Join  (cost=35383.02..1158352.97 rows=121991 width=397) (actual time=13121.524..13583.908 rows=98126 loops=3)"
--                   Hash Cond: (t.cruise_id = cr.cruise_id)"
--                   ->  Parallel Seq Scan on tickets t  (cost=0.00..1045215.33 rows=1338515 width=198) (actual time=0.214..11583.495 rows=1077552 loops=3)"
--                         Filter: (sold AND (birthdate > '1990-01-01'::date))"
--                         Rows Removed by Filter: 8922448"
--                   ->  Parallel Hash  (cost=33869.33..33869.33 rows=37975 width=195) (actual time=669.506..669.507 rows=30364 loops=3)"
--                         Buckets: 32768  Batches: 8  Memory Usage: 2976kB"
--                         ->  Parallel Seq Scan on cruises cr  (cost=0.00..33869.33 rows=37975 width=195) (actual time=0.043..642.443 rows=30364 loops=3)"
--                               Filter: (distance < 1000)"
--                               Rows Removed by Filter: 302969"
--Planning Time: 0.196 ms"
--Execution Time: 13751.321 ms"

SELECT *
FROM tickets t INNER JOIN cruises cr
USING (cruise_id)
WHERE t.sold = true
AND cr.distance < 1000
AND cr.distance > 900
AND t.birthdate > '1990-01-01'
ORDER BY t.price DESC
LIMIT 100;

EXPLAIN ANALYZE SELECT *
FROM tickets t INNER JOIN cruises cr
USING (cruise_id)
WHERE t.sold = true
AND cr.distance < 1000
AND cr.distance > 900
AND t.birthdate > '1990-01-01'
ORDER BY t.price DESC NULLS LAST
LIMIT 100;

DROP INDEX IF EXISTS TICKETS_price_order;


-- 3 
CREATE INDEX TICKETS_feedback ON tickets USING GIN (to_tsvector('english', feedback)); -- 18 sec

--Gather  (cost=1000.00..2789257.29 rows=100036 width=197)"
--  Workers Planned: 2"
--  ->  Parallel Seq Scan on tickets t  (cost=0.00..2778253.69 rows=41682 width=197)"
--        Filter: (to_tsvector(feedback) @@ '''go'''::tsquery)"
ANALYZE tickets;

EXPLAIN SELECT * --ts_rank(to_tsvector(t.feedback), plainto_tsquery('go & magestic & deep')) 
FROM tickets t
WHERE to_tsvector('english', t.feedback) @@ 'go & magestic & deep';
--ORDER BY ts_rank(to_tsvector(t.feedback), plainto_tsquery('go & magestic & deep'));

DROP INDEX IF EXISTS TICKETS_feedback;

SELECT feedback FROM tickets WHERE ticket_id = 1168;

-- initdb --locale=ru_RU;

-- 4
CREATE INDEX CRUISES_services ON cruises USING GIN(services); -- 5 sec

--"Gather  (cost=1000.00..38782.63 rows=39133 width=195)"
--"  Workers Planned: 2"
--"  ->  Parallel Seq Scan on cruises  (cost=0.00..33869.33 rows=16305 width=195)"
--"        Filter: (services @> '{vacation}'::character varying[])"

SELECT * FROM cruises
WHERE services @> ARRAY['vacation']::varchar[];

EXPLAIN SELECT * FROM cruises
WHERE services @> ARRAY['vacation']::varchar[];


-- 5
CREATE INDEX TICKETS_services ON tickets USING GIN(additional_services); -- 3 min 0_o

--"Gather  (cost=1000.00..1092448.00 rows=150000 width=198)"
--"  Workers Planned: 2"
--"  ->  Parallel Seq Scan on tickets  (cost=0.00..1076448.00 rows=62500 width=198)"
--"        Filter: ((additional_services ->> 'adventure'::text) = 'Cancel'::text)"

SELECT * FROM tickets
WHERE additional_services->>'adventure' = 'Cancel'
AND additional_services->>'human' = 'Cancel';

EXPLAIN SELECT * FROM tickets
WHERE additional_services @> '{"human": "Cancel"}';


--6
DROP TABLE IF EXISTS SEC_cruises;
CREATE TABLE IF NOT EXISTS SEC_cruises (
  "cruise_id" integer,
  "ship" varchar,
  "start_port" varchar,
  "finish_port" varchar,
  "start_date" timestamp,
  "finish_date" timestamp,
  "distance" integer,
  "services" varchar[]
) PARTITION BY RANGE (start_date);

CREATE TABLE cruises_01_02 
PARTITION OF SEC_cruises
FOR VALUES FROM ('2020-01-01') TO ('2020-03-01');

CREATE TABLE cruises_03_04 
PARTITION OF SEC_cruises
FOR VALUES FROM ('2020-03-01') TO ('2020-05-01');

CREATE TABLE cruises_05_06 
PARTITION OF SEC_cruises
FOR VALUES FROM ('2020-05-01') TO ('2020-07-01');

CREATE TABLE cruises_07_08 
PARTITION OF SEC_cruises
FOR VALUES FROM ('2020-07-01') TO ('2020-09-01');

CREATE TABLE cruises_09_10 
PARTITION OF SEC_cruises
FOR VALUES FROM ('2020-09-01') TO ('2020-11-01');

CREATE TABLE cruises_11_12 
PARTITION OF SEC_cruises
FOR VALUES FROM ('2020-11-01') TO ('2021-01-01');

COPY SEC_cruises 
FROM '/home/dmitry/dbcourse/lab3/gener/cruises.csv' 
DELIMITER ';';

EXPLAIN SELECT * FROM SEC_cruises
WHERE start_date = '2020-03-03';

EXPLAIN SELECT * FROM cruises
WHERE start_date = '2020-03-03';











