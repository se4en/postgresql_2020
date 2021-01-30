-- READ UNCOMMITTED
BEGIN;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	-- грязное чтение (нет)
	SELECT capacity
	FROM ports
	WHERE port_id = 1; 
	-- потерянные изменения
	UPDATE ports
	SET capacity = 15
	WHERE port_id = 1;
COMMIT;


-- READ COMMITTED
BEGIN;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	-- грязное чтение (нет)
	SELECT capacity
	FROM ports
	WHERE port_id = 1; 
	-- неповторяющиеся чтения
	SELECT *
	FROM ports
	WHERE port_id = 1;
	-- 
	SELECT *
	FROM ports
	WHERE port_id = 1;
COMMIT;


-- REPEATABLE READ
BEGIN;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	-- неповторяющиеся чтения
	SELECT *
	FROM ports
	WHERE port_id = 1;
	-- 
	SELECT *
	FROM ports
	WHERE port_id = 1;
	-- фантомы
	SELECT *
	FROM ports
	WHERE capacity = 5;
	-- 
	SELECT *
	FROM ports
	WHERE capacity = 5;
COMMIT;


-- SERIALIZABLE
BEGIN;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
	-- фантомы
	SELECT *
	FROM ports
	WHERE capacity = 6;
	-- 
	SELECT *
	FROM ports
	WHERE capacity = 6;
COMMIT;