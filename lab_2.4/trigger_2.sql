CREATE OR REPLACE FUNCTION check_ship_func() 
RETURNS trigger AS '
BEGIN
	IF ((SELECT start_date, finish_date 
		FROM ships
		WHERE base_port_id = NEW.port_id) > NEW.capacity)
	THEN 
		BEGIN
			RAISE ''Ship % in cruise now'', NEW.name;
			RETURN NULL;
		END;
	END IF;
	RETURN OLD;
END'
LANGUAGE plpgsql;

CREATE TRIGGER ship_trigger 
BEFORE DELETE ON ships
FOR EACH ROW
EXECUTE FUNCTION check_ships_func();

--INSERT INTO ports (country, city, capacity) VALUES
--('Испания', 'Мадрид', 0);

UPDATE ports 
SET capacity = 1
WHERE port_id = 1;