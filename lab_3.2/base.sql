SET ROLE postgres;

-- create new user
CREATE USER test;


REVOKE ALL ON tickets FROM test;
REVOKE ALL ON cruises FROM test;
REVOKE ALL ON passengers FROM test;
DROP USER test;

-- set access
GRANT SELECT, INSERT, UPDATE 
ON tickets 
TO test;

GRANT SELECT, UPDATE 
(services, start_date, finish_date)
ON cruises 
TO test;

GRANT SELECT 
ON passengers
TO test;

SET ROLE test;

