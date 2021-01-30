-- 1 Средняя цена билета на рейс из аэропортов в Москве

WITH avg_airports AS (
	SELECT departure_airport, avg(amount)
	FROM ticket_flights tf NATURAL JOIN flights f
	GROUP BY f.departure_airport
)

SELECT air.airport_name, avga.avg
FROM avg_airports avga JOIN airports air
ON avga.departure_airport=air.airport_code
WHERE air.city='Москва'
ORDER BY avga.avg ASC