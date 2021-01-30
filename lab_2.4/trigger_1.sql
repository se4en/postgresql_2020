CREATE OR REPLACE FUNCTION check_port_func() 
RETURNS trigger AS '
BEGIN
	IF (TG_OP = ''UPDATE'') THEN
		IF ((SELECT count(*) 
			FROM ships
			WHERE base_port_id = NEW.port_id) > NEW.capacity)
		THEN 
			BEGIN
				RAISE ''So many ships in % '', NEW.city;
				RETURN NULL;
			END;
		END IF;
		RETURN NEW;
	
	ELSIF (TG_OP = ''INSERT'') THEN
		IF (NEW.capacity < 1) 
		THEN 
			BEGIN
				RAISE ''Capacity in % must be > 0 '', NEW.city;
				RETURN NULL;
			END;
		END IF;
		RETURN NEW;
	END IF;
END'
LANGUAGE plpgsql;

CREATE TRIGGER port_trigger 
BEFORE INSERT OR UPDATE ON ports
FOR EACH ROW
EXECUTE FUNCTION check_port_func();

--INSERT INTO ports (country, city, capacity) VALUES
--('Испания', 'Мадрид', 0);

UPDATE ports 
SET capacity = 1
WHERE port_id = 1;
