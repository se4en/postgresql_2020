-- удаление всех посещений заданной страны
DELETE FROM visits
WHERE port_id IN (
	SELECT port_id
	FROM ports
	WHERE country = 'Греция'
)
AND start_time < '20200-10-28 00:00';

-- увеличение цены билета
WITH expensive_cruises AS (
	SELECT cruise_id
	FROM cruises cr INNER JOIN ports pt
	ON cr.start_port_id = pt.port_id
	WHERE pt.country = 'Греция'
)
UPDATE tickets tk
SET price = 1.05 * price
FROM expensive_cruises ec
WHERE tk.cruise_id = ec.cruise_id;

-- неисправность корабля - срабатывание ограничений
DELETE FROM ships 
WHERE ship_name='MSC OPERA' OR ship_name='COSTA DELIZIOSA';

-- изменение базового порта
UPDATE ships sh
SET base_port_id = (
	SELECT port_id
	FROM ports
	ORDER BY capacity DESC
	LIMIT 1
)
WHERE base_port_id = (
	SELECT port_id
	FROM ports
	WHERE city = 'Марсель'
);


