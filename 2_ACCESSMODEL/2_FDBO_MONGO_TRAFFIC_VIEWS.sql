CREATE OR REPLACE VIEW V_MONGO_TRAFFIC_SENSORS AS
SELECT jt.*
FROM JSON_TABLE(
       get_smartcity_json('http://localhost:8080/api/traffic_sensors'),
       '$[*]'
       COLUMNS (
         sensor_id        VARCHAR2(50)  PATH '$._id."$oid"',
         t_stamp          VARCHAR2(50)  PATH '$.Timestamp',
         v_count          NUMBER        PATH '$.Vehicle_Count',
         v_speed          NUMBER        PATH '$.Traffic_Speed_kmh',
         v_occupancy      NUMBER        PATH '$. "Road_Occupancy_%"',
         v_weather        VARCHAR2(50)  PATH '$.Weather_Condition',
         v_traffic_cond   VARCHAR2(50)  PATH '$.Traffic_Condition',
         v_emissions      NUMBER        PATH '$.Emission_Levels_g_km'
       )
     ) jt;

-- Interogare fedrata(NoSQL + Oracle)
SELECT 
    l.cartier,
    l.strada,
    m.v_traffic_cond as stare_trafic,
    m.v_speed as viteza
FROM V_MONGO_TRAFFIC_SENSORS m
JOIN SENZORI_LOCATIE l ON m.sensor_id = l.id_senzor;