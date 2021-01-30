CREATE OR REPLACE FUNCTION add_func() 
RETURNS trigger AS '
BEGIN
	
	UPDATE passengers
	SET miles += (
		SELECT distance
		FROM cruises
		WHERE cruise_id = NEW.cruise_id;
	)
	WHERE passenger_id = NEW.passenger_id;

	UPDATE passengers
	SET amount_spent +=  NEW.price;
	WHERE passenger_id = NEW.passenger_id;
	
	RETURN NEW;
END'
LANGUAGE plpgsql;

CREATE TRIGGER adding_trigger 
BEFORE INSERT tickets
FOR EACH ROW
EXECUTE FUNCTION add_func();

