-- 0 
-- show nearest cruises
CREATE OR REPLACE VIEW fast_tickets AS
	SELECT t.cruise_id, t.place, t.price
	FROM tickets t NATURAL JOIN (
		SELECT c.cruise_id
		FROM cruises c
		WHERE (c.start_date - current_timestamp) < interval '21 days'
		AND c.start_date > current_timestamp 
		AND (c.finish_date - c.start_date) < interval '7 days'
	) CR; 

DROP VIEW fast_tickets;

-- 1
-- edit services on ship at 2 weeks
CREATE OR REPLACE VIEW ship_services AS
	SELECT c.ship, c.services
	FROM cruises c
	WHERE (c.start_date - current_timestamp) < interval '14 days' 
	AND c.start_date > current_timestamp;
	
DROP VIEW ship_services;

-- 2
-- edit services or feedback in ticket
CREATE OR REPLACE VIEW ticket_info AS
	SELECT 
		t.cruise_id ,--AS cruise_id, 
		t.place ,--AS place,
		t.price ,--AS price,
		t.additional_services ,--AS additional_services,
		t.feedback --AS feedback
	FROM tickets t
	WHERE t.sold=true;
	
DROP VIEW ticket_info;