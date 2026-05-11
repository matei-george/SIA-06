package org.datasource.mongodb.views.trafficsensors;

public record TrafficSensorView(
        String trip_id,
        String transport_type,
        String origin_station,
        String weather_condition,
        Double temperature_C,
        Integer actual_arrival_delay_min,
        Integer traffic_congestion_index
) {}