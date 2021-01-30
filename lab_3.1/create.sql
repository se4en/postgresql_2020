-- passengers
DROP TABLE IF EXISTS "passengers" CASCADE;
CREATE TABLE IF NOT EXISTS "passengers" (
  "passenger_id" integer,
  "name" varchar,
  "sername" varchar,
  "phone" varchar(10),
  "e-mail" varchar,
  "miles" integer,
  "amount_spent" money,
  "birthdate" date,
  "country" varchar,
  "city" varchar
);

COPY "passengers" 
FROM '/home/dmitry/dbcourse/lab3/gener/passengers.csv' 
DELIMITER ';';

ALTER TABLE "passengers" 
	ADD PRIMARY KEY (passenger_id),
	ALTER COLUMN phone SET NOT NULL, 
	ALTER COLUMN "name" SET NOT NULL,
	ALTER COLUMN sername SET NOT NULL,
	ALTER COLUMN miles SET DEFAULT 0,
	ALTER COLUMN amount_spent SET DEFAULT 0;

SELECT * 
FROM "passengers" 
ORDER BY miles
DESC 
LIMIT 100;


-- cruises
DROP TABLE IF EXISTS "cruises" CASCADE;
CREATE TABLE IF NOT EXISTS "cruises" (
  "cruise_id" integer,
  "ship" varchar,
  "start_port" varchar,
  "finish_port" varchar,
  "start_date" timestamp,
  "finish_date" timestamp,
  "distance" integer,
  "services" varchar[]
);

COPY "cruises" 
FROM '/home/dmitry/dbcourse/lab3/gener/cruises.csv' 
DELIMITER ';';

ALTER TABLE "cruises" 
	ADD PRIMARY KEY (cruise_id),
	ALTER COLUMN ship SET NOT NULL, 
	ALTER COLUMN start_port SET NOT NULL,
	ALTER COLUMN finish_port SET NOT NULL,
	ALTER COLUMN start_date SET NOT NULL,
	ALTER COLUMN finish_date SET NOT NULL,
	ALTER COLUMN services SET NOT NULL;

SELECT * FROM "cruises" LIMIT 100;


-- tickets
DROP TABLE IF EXISTS "tickets";
CREATE TABLE IF NOT EXISTS "tickets" (
  "ticket_id" integer,
  "passenger_id" integer,
  "cruise_id" integer,
  "place" varchar(4),
  "price" money,
  "sold" boolean,
  "additional_services" jsonb,
  "feedback" text, 
  "e-mail" varchar,
  "birthdate" date,
  "gender" char,
  "city" varchar
);

CREATE TRIGGER adding_trigger 
AFTER INSERT 
ON tickets
FOR EACH ROW
EXECUTE FUNCTION add_func();

SELECT count(*) FROM tickets;
-- 1
COPY "tickets" FROM '/home/dmitry/dbcourse/lab3/gener/tickets0.csv' DELIMITER ';';
-- 2
COPY "tickets" FROM '/home/dmitry/dbcourse/lab3/gener/tickets1.csv' DELIMITER ';';
-- 3
COPY "tickets" FROM '/home/dmitry/dbcourse/lab3/gener/tickets2.csv' DELIMITER ';';
-- 4
COPY "tickets" FROM '/home/dmitry/dbcourse/lab3/gener/tickets3.csv' DELIMITER ';';
-- 5
COPY "tickets" FROM '/home/dmitry/dbcourse/lab3/gener/tickets4.csv' DELIMITER ';';
-- 6
COPY "tickets" FROM '/home/dmitry/dbcourse/lab3/gener/tickets5.csv' DELIMITER ';';
-- 7
COPY "tickets" FROM '/home/dmitry/dbcourse/lab3/gener/tickets6.csv' DELIMITER ';';
-- 8
COPY "tickets" FROM '/home/dmitry/dbcourse/lab3/gener/tickets7.csv' DELIMITER ';';
-- 9
COPY "tickets" FROM '/home/dmitry/dbcourse/lab3/gener/tickets8.csv' DELIMITER ';';
-- 10
COPY "tickets" FROM '/home/dmitry/dbcourse/lab3/gener/tickets9.csv' DELIMITER ';';

DELETE FROM tickets
WHERE ticket_id > 2000000;

ALTER TABLE "tickets" 
	ADD PRIMARY KEY (ticket_id),
	ADD FOREIGN KEY (cruise_id) REFERENCES "cruises" (cruise_id) 
		ON DELETE CASCADE ON UPDATE CASCADE,
	ADD FOREIGN KEY (passenger_id) REFERENCES "passengers" (passenger_id)
		ON DELETE CASCADE ON UPDATE CASCADE,
	ALTER COLUMN place SET NOT NULL,
	ALTER COLUMN price SET NOT NULL,
	ALTER COLUMN sold SET NOT NULL;
	



SELECT * FROM "tickets" LIMIT 100;