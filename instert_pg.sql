-- Inserare în trips (distincte pentru a asigura integritatea PK)
INSERT INTO transport.trips (trip_id, transport_type, route_id, origin_station, destination_station)
SELECT DISTINCT trip_id, transport_type, route_id, origin_station, destination_station
FROM transport.stg_public_transport_delays;

-- Inserare în schedule
INSERT INTO transport.schedule
SELECT 
    trip_id, 
    date::DATE, 
    time::TIME, 
    scheduled_departure::TIME, 
    scheduled_arrival::TIME, 
    actual_departure_delay_min::INTEGER, 
    actual_arrival_delay_min::INTEGER
FROM transport.stg_public_transport_delays;

-- Inserare în weather
INSERT INTO transport.weather
SELECT 
    trip_id, 
    weather_condition, 
    temperature_C::NUMERIC, 
    humidity_percent::INTEGER, 
    wind_speed_kmh::INTEGER, 
    precipitation_mm::NUMERIC
FROM transport.stg_public_transport_delays;

-- Inserare în metrics
INSERT INTO transport.metrics
SELECT 
    trip_id, 
    NULLIF(event_type, 'None'), -- Transformăm textul 'None' în NULL real
    NULLIF(event_attendance_est, 'None')::INTEGER, 
    traffic_congestion_index::INTEGER, 
    holiday::BOOLEAN, 
    peak_hour::BOOLEAN, 
    weekday::INTEGER, 
    season, 
    delayed::BOOLEAN
FROM transport.stg_public_transport_delays;