-- READ UNCOMMITTED
BEGIN;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	-- потерянные изменения + грязное чтение
	UPDATE ports
	SET capacity = 10
	WHERE port_id = 1;
COMMIT;


-- READ COMMITTED
BEGIN;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	-- грязное чтение
	UPDATE ports
	SET capacity = 1
	WHERE port_id = 1;
	-- неповторяющиеся чтения
	UPDATE ports
	SET capacity = 13
	WHERE port_id = 1;
COMMIT;


-- REPEATABLE READ
BEGIN;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	-- неповторяющиеся чтения
	UPDATE ports
	SET capacity = 17
	WHERE port_id = 1;
	-- фантомы
	UPDATE ports
	SET capacity = 5
	WHERE port_id = 1;
COMMIT;


-- SERIALIZABLE
BEGIN;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
	-- фантомы
	UPDATE ports
	SET capacity = 6
	WHERE port_id = 1;
COMMIT;