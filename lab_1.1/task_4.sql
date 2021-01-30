WITH RECURSIVE transist AS (
    
    SELECT 
        scheduled_departure,
        scheduled_arrival,
		departure_airport,
		arrival_airport
    FROM flights
	WHERE
		departure_airport='DME'
		AND arrival_airport='KZN'
	
    UNION 
    
    SELECT 
        f.scheduled_departure,
        f.scheduled_arrival,
		f.departure_airport,
		f.arrival_airport
    FROM transist tr INNER JOIN flights f
	ON tr.arrival_airport = f.departure_airport
	WHERE 
		f.scheduled_departure BETWEEN tr.scheduled_departure AND (tr.scheduled_departure + interval '1 day')
		AND f.arrival_airport!=tr.departure_airport
)
SELECT * FROM transist;