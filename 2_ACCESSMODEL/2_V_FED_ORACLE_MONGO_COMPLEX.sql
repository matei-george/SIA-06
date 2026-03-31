SELECT 
    
    NVL(s.stop_name, m.origin_station) as statie_afisata,
    m.transport_type,
    m.vreme_mongo,
    m.temp_mongo,
    m.intarziere_mongo,
    CASE 
        WHEN m.congestion_index > 80 THEN 'BLOCAJ CRITIC'
        WHEN m.congestion_index BETWEEN 50 AND 80 THEN 'TRAFIC GREU'
        ELSE 'FLUID'
    END as stare_trafic_calculata
FROM V_MONGO_TRIPS_ACCESS m
-- Folosim LEFT JOIN ca să nu pierdem nicio stație din MongoDB
LEFT JOIN STOPS_EXT s ON (
    TRIM(UPPER(s.stop_name)) = TRIM(UPPER(m.origin_station)) 
    OR s.stop_id = REGEXP_REPLACE(m.origin_station, '[^0-9]', '')
)