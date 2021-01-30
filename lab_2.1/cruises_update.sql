-- время, проведенное в море
WITH port_time AS (
	SELECT cruise_id, sum(end_time - start_time) "time_at_ports"
	FROM visits
	GROUP BY cruise_id
)
SELECT 
	cruise_id, 
	finish_date-start_date "all_time", 
	justify_hours(finish_date-start_date-time_at_ports) "in_sea",
	justify_hours(time_at_ports) "in_ports"
FROM cruises LEFT JOIN port_time
USING (cruise_id)
ORDER BY cruise_id;

-- самые популярные порты
SELECT city, count(*) "visits"
FROM ports RIGHT JOIN visits
USING (port_id)
GROUP BY city
ORDER BY visits DESC;

-- возможные круизы для посещения подряд
WITH RECURSIVE some_cruises AS (
    SELECT 
		cruise_id,
		start_port_id,
		finish_port_id,
        start_date,
		finish_date
    FROM cruises
	--WHERE cruise_id = 1
	
    UNION 
    
    SELECT 
        cr.cruise_id,
		cr.start_port_id,
		cr.finish_port_id,
		cr.start_date,
		cr.finish_date
    FROM some_cruises sc INNER JOIN cruises cr
	ON sc.finish_port_id = cr.start_port_id
	WHERE sc.finish_date < cr.start_date
	AND (cr.start_date - sc.finish_date) < interval '3 days'
	AND sc.start_port_id != cr.finish_port_id
)
SELECT * FROM some_cruises;