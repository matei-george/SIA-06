DROP TABLE IF EXISTS transport.metrics;
DROP TABLE IF EXISTS transport.weather;
DROP TABLE IF EXISTS transport.schedule;
DROP TABLE IF EXISTS transport.trips;

-- Tabel pentru detaliile fixe ale călătoriei
CREATE TABLE transport.trips (
    trip_id VARCHAR(20) PRIMARY KEY,
    transport_type VARCHAR(20),
    route_id VARCHAR(20),
    origin_station VARCHAR(100),
    destination_station VARCHAR(100)
);

-- Tabel pentru orar și întârzieri
CREATE TABLE transport.schedule (
    trip_id VARCHAR(20) PRIMARY KEY,
    date DATE,
    time TIME,
    scheduled_departure TIME,
    scheduled_arrival TIME,
    actual_departure_delay_min INTEGER,
    actual_arrival_delay_min INTEGER,
    CONSTRAINT fk_schedule_trip FOREIGN KEY (trip_id) REFERENCES transport.trips(trip_id)
);

-- Tabel pentru condiții meteo
CREATE TABLE transport.weather (
    trip_id VARCHAR(20) PRIMARY KEY,
    weather_condition VARCHAR(50),
    temperature_C NUMERIC(4,1),
    humidity_percent INTEGER,
    wind_speed_kmh INTEGER,
    precipitation_mm NUMERIC(5,2),
    CONSTRAINT fk_weather_trip FOREIGN KEY (trip_id) REFERENCES transport.trips(trip_id)
);

-- Tabel pentru factori externi și indicatori de performanță
CREATE TABLE transport.metrics (
    trip_id VARCHAR(20) PRIMARY KEY,
    event_type VARCHAR(50),
    event_attendance_est INTEGER,
    traffic_congestion_index INTEGER,
    holiday BOOLEAN,
    peak_hour BOOLEAN,
    weekday INTEGER,
    season VARCHAR(20),
    delayed BOOLEAN,
    CONSTRAINT fk_metrics_trip FOREIGN KEY (trip_id) REFERENCES transport.trips(trip_id)
);