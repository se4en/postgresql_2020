--1 base
DROP FUNCTION mean_price(p_phone passengers.phone%TYPE);

CREATE OR REPLACE FUNCTION mean_price(p_phone passengers.phone%TYPE) 
RETURNS numeric AS $$
	WITH pass_info AS (
		SELECT p.passenger_id
		FROM passengers p 
		WHERE p.phone = p_phone
	)
	SELECT avg(price::numeric)
	FROM tickets LEFT JOIN pass_info 
	USING (passenger_id);
	
$$ LANGUAGE sql;

SELECT mean_price('79999893445'); 


--2 case and declare
DROP FUNCTION  get_sale(id passengers.passenger_id%TYPE, OUT sale money);

CREATE OR REPLACE FUNCTION get_sale(id passengers.passenger_id%TYPE, OUT sale money)
AS
$$	
	DECLARE
        dist passengers.miles%TYPE = 0;
    BEGIN
	dist = (
		SELECT p.miles
		FROM passengers p
		WHERE p.passenger_id = id
	);
	CASE 
		WHEN dist BETWEEN 0 AND 1000 THEN
			sale = 500;
		WHEN dist BETWEEN 1000 AND 3000 THEN
			sale = 1000;
		WHEN dist BETWEEN 3000 AND 10000 THEN
			sale = 5000;
		ELSE
			sale = 10000;
	END CASE;
	END;
$$ LANGUAGE plpgsql;

SELECT sale FROM get_sale(10000);

--3 loop
DROP FUNCTION  get_cheep_long_cruise(port cruises.start_port%TYPE);

CREATE OR REPLACE FUNCTION get_cheep_long_cruise(port cruises.start_port%TYPE,
											   OUT res_cruise tickets.cruise_id%TYPE,
											   OUT res_price money,
											   OUT res_place tickets.place%TYPE) AS $$
	DECLARE
        cr_row cruises%ROWTYPE;
		tk_row tickets%ROWTYPE;
	BEGIN
		res_price = '0.0'::float8::numeric::money;
    FOR cr_row IN (
			SELECT * 
			FROM cruises 
			WHERE cruises.start_port = port
			AND cruises.finish_port = port ) LOOP
		SELECT * INTO tk_row
		FROM tickets tk
		WHERE tk.cruise_id=cr_row.cruise_id
		ORDER BY price
		LIMIT 1;
        IF tk_row.price > res_price THEN
            res_price = tk_row.price;
            res_place = tk_row.place;
			res_cruise = tk_row.cruise_id;
        END IF;
    END LOOP;
    END;
$$ LANGUAGE plpgsql;

SELECT res_cruise, res_price, res_place from get_cheep_long_cruise('Москва');

-- 4 cursor - get cruises, what start from 'port' and its time about 'cr_period'
DROP FUNCTION  create_ticket_cursor(port cruises.start_port%TYPE, cr_period interval, refcursor);

CREATE FUNCTION create_ticket_cursor(port cruises.start_port%TYPE, cr_period interval, refcursor) 
RETURNS refcursor AS $$
	BEGIN
		OPEN $3 FOR (
      		SELECT * 
			FROM cruises cr
			WHERE cr.start_port = port
			AND (cr.finish_date - cr.start_date) < cr_period + interval '1 day'
			AND (cr.finish_date - cr.start_date) > cr_period - interval '1 day'
   		);
		RETURN $3;
	END;
$$ LANGUAGE plpgsql;

DROP FUNCTION create_ticket_cursor(port cruises.start_port%TYPE, cr_period interval);

CREATE FUNCTION create_ticket_cursor(port cruises.start_port%TYPE, cr_period interval)
RETURNS refcursor AS $$
	DECLARE
		ref_cur refcursor;
	BEGIN
		OPEN ref_cur FOR (
			SELECT * 
			FROM cruises cr
			WHERE cr.start_port = port
			AND (cr.finish_date - cr.start_date) < cr_period + interval '1 day'
			AND (cr.finish_date - cr.start_date) > cr_period - interval '1 day'
		);
		RETURN ref_cur;
	END;
$$ LANGUAGE plpgsql;

BEGIN;
FETCH ALL FROM (SELECT create_ticket_cursor('Москва', '7 days'));
COMMIT;





-- 4 exception
DROP FUNCTION set_price(t_id tickets.ticket_id%TYPE, t_price tickets.price%TYPE, t_sold tickets.sold%TYPE);

CREATE OR REPLACE FUNCTION set_price(t_id tickets.ticket_id%TYPE,
									 sale tickets.price%TYPE,
									 t_sold tickets.sold%TYPE,
									OUT new_price money) AS
$$
	BEGIN
            UPDATE tickets tk
			SET tk.
            EXCEPTION
                WHEN successful_completion THEN
                	RAISE EXCEPTION 'UPDATE_OK';
                when too_many_rows then
                raise exception 'too many rowssss';
    END;
$$ LANGUAGE plpgsql;

SELECT set_price(1000, 1000, FALSE);






