SELECT count(*) AS total_calatorii FROM transport.trips;

SELECT 
    t.trip_id, 
    t.transport_type, 
    s.date, 
    s.actual_arrival_delay_min, 
    w.weather_condition
FROM transport.trips t
JOIN transport.schedule s ON t.trip_id = s.trip_id
JOIN transport.weather w ON t.trip_id = w.trip_id
LIMIT 10;

SELECT 
    t.route_id, 
    ROUND(AVG(s.actual_arrival_delay_min::INT), 2) AS intarziere_medie
FROM transport.trips t
JOIN transport.schedule s ON t.trip_id = s.trip_id
GROUP BY t.route_id
ORDER BY intarziere_medie DESC
LIMIT 5;

SELECT 
    w.weather_condition, 
    COUNT(*) AS nr_calatorii,
    COUNT(*) FILTER (WHERE m.delayed = TRUE) AS nr_intarzieri
FROM transport.weather w
JOIN transport.metrics m ON w.trip_id = m.trip_id
GROUP BY w.weather_condition
ORDER BY nr_intarzieri DESC;

SELECT 
    t.transport_type,
    m.peak_hour,
    COUNT(*) AS total,
    ROUND(AVG(s.actual_arrival_delay_min::INT), 2) AS medie_intarziere
FROM transport.trips t
JOIN transport.metrics m ON t.trip_id = m.trip_id
JOIN transport.schedule s ON t.trip_id = s.trip_id
WHERE t.transport_type = 'Metro'
GROUP BY t.transport_type, m.peak_hour;

SELECT * FROM transport.trips 
WHERE origin_station LIKE 'Station_1%' 
LIMIT 20;
