-- 2 Сравнение цены билета из СПБ в Москву с минимальной ценой в за тот же класс
SELECT DISTINCT fare_conditions "Класс", amount "Цена", 
	min(amount) OVER (PARTITION BY fare_conditions) "Минимальная цена в классе" 
FROM ticket_flights tf NATURAL JOIN flights f
WHERE departure_airport='LED' AND 
	(arrival_airport='SVO' OR arrival_airport='VKO' OR arrival_airport='DME')  