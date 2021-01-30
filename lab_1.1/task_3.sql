-- 3 10 пассажиров с именем Максим, потратившие больше всего на перелеты
SELECT total_amount, passenger_name
FROM bookings NATURAL JOIN tickets
WHERE 
	passenger_name LIKE 'MAKSIM%'
	AND (book_date BETWEEN '2017-08-01'::timestamp AND '2017-08-31'::timestamp)
ORDER BY total_amount DESC
LIMIT 10;
