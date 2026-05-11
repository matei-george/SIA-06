SELECT jt."MONGO_ID",jt."TRIP_ID",jt."TRANSPORT_TYPE",jt."ORIGIN_STATION",jt."VREME_MONGO",jt."TEMP_MONGO",jt."INTARZIERE_MONGO",jt."CONGESTION_INDEX"
FROM (
    SELECT get_smartcity_json('http://localhost:8084/sensors') as doc 
    FROM dual
) t,
JSON_TABLE(t.doc, '$[*]'
    COLUMNS (
        mongo_id         VARCHAR2(50)  PATH '$._id."$oid"',
        trip_id          VARCHAR2(20)  PATH '$.trip_id',
        transport_type   VARCHAR2(20)  PATH '$.transport_type',
        origin_station   VARCHAR2(50)  PATH '$.origin_station',
        vreme_mongo      VARCHAR2(50)  PATH '$.weather_condition',
        temp_mongo       NUMBER        PATH '$.temperature_C',
        intarziere_mongo NUMBER        PATH '$.actual_arrival_delay_min',
        congestion_index NUMBER        PATH '$.traffic_congestion_index'
    )
) jt