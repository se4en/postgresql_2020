SET ROLE postgres;

CREATE ROLE test_2;

-- access to table
GRANT SELECT
ON tickets
TO test_2;

-- access to view
GRANT SELECT
ON ticket_info
TO test_2;

GRANT UPDATE
(price, additional_services, feedback)
ON ticket_info
TO test_2;


SET ROLE test_2;
-- try to update table
UPDATE tickets
SET price = money(10000)
WHERE ticket_id = 10;
-- try to update view
UPDATE ticket_info
SET feedback = 'Nice'
WHERE place = 'tV14';


SELECT * FROM ticket_info
WHERE place = 'tV14'
LIMIT 10;






