DROP TABLE IF EXISTS transport.stg_public_transport_delays;

CREATE TABLE transport.stg_public_transport_delays (
    trip_id TEXT,
    date TEXT,
    time TEXT,
    transport_type TEXT,
    route_id TEXT,
    origin_station TEXT,
    destination_station TEXT,
    scheduled_departure TEXT,
    scheduled_arrival TEXT,
    actual_departure_delay_min TEXT,
    actual_arrival_delay_min TEXT,
    weather_condition TEXT,
    temperature_C TEXT,
    humidity_percent TEXT,
    wind_speed_kmh TEXT,
    precipitation_mm TEXT,
    event_type TEXT,
    event_attendance_est TEXT,
    traffic_congestion_index TEXT,
    holiday TEXT,
    peak_hour TEXT,
    weekday TEXT,
    season TEXT,
    delayed TEXT
);