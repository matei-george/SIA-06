-------------------------------------------------------------------------
-- STRATUL ANALITIC: INTEGRARE SI JOIN-URI CROSS-PLATFORM
-------------------------------------------------------------------------

-- 1. Vedere Master Schedule (Postgres + CSV)
CREATE OR REPLACE VIEW view_master_schedule AS
SELECT 
    t.tripId,
    r.routeLongName, 
    t.transportType, 
    t.originStation, 
    r.routeType       
FROM view_trips_postgres t
JOIN view_routes r ON t.routeId = r.routeId;

-- 2. VEDEREA FINALA PENTRU WEB MODEL (Vedere Federata Completa)
-- Aceasta va fi folosita de microserviciul DSA-WEB-RESTService
CREATE OR REPLACE VIEW view_analytical_transport_master AS
SELECT 
    t.tripId,
    t.transportType,
    t.originStation,
    r.routeLongName,
    m.trafficCongestionIndex AS pg_traffic_index,
    m.delayed AS is_delayed,
    s.traffic_congestion_index AS mongo_sensor_index,
    s.weather_condition AS sensor_weather
FROM view_trips_postgres t
LEFT JOIN view_routes r ON t.routeId = r.routeId
LEFT JOIN view_metrics_postgres m ON t.tripId = m.tripId
LEFT JOIN view_traffic_sensors s ON t.tripId = s.trip_id;

-- 3. Interogari Analitice de Verificare
-- Viteza medie per tip vehicul (CSV Mobility)
SELECT vehicleType, AVG(CAST(speed AS DOUBLE)) as avg_speed 
FROM view_mobility GROUP BY vehicleType;

-- Corelare Intarzieri cu Vremea (Postgres Join)
SELECT t.tripId, w.weatherCondition, w.temperatureC
FROM view_trips_postgres t
JOIN view_weather_postgres w ON t.tripId = w.tripId
WHERE w.temperatureC < 5;