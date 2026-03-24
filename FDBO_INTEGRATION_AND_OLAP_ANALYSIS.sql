
-- 1. INTEGRATION VIEW (Imaginea unificata a datelor)

CREATE OR REPLACE VIEW INT_SMART_CITY_V AS
SELECT m.*, l.cartier, l.strada FROM V_MONGO_TRAFFIC_SENSORS m
LEFT JOIN SENZORI_LOCATIE l ON m.sensor_id = l.id_senzor;


-- 2. DIMENSION VIEW (Clasificari analitice cu  CASE)

CREATE OR REPLACE VIEW DIM_TRAFFIC_GROUPS_V AS
SELECT 
    sensor_id,
    v_weather,
    CASE 
        WHEN v_speed < 20 THEN 'BLOCAJ'
        WHEN v_speed BETWEEN 20 AND 50 THEN 'NORMAL'
        ELSE 'FLUID'
    END AS categorie_viteza,
    CASE 
        WHEN v_emissions > 450 THEN 'CRITIC'
        ELSE 'ACCEPTABIL'
    END AS status_ecologic
FROM V_MONGO_TRAFFIC_SENSORS;


-- 3. ANALYTICAL VIEWS (OLAP , CUBE , ROLLUP)

-- Analiza  vreme vs conditii trafic
CREATE OR REPLACE VIEW OLAP_TRAFFIC_CUBE_V AS
SELECT 
    CASE WHEN GROUPING(v_weather) = 1 THEN '{TOATE CONDITIILE}' ELSE v_weather END AS vreme,
    CASE WHEN GROUPING(v_traffic_cond) = 1 THEN '{TOATE NIVELURILE}' ELSE v_traffic_cond END AS nivel_trafic,
    COUNT(*) as masuratori,
    ROUND(AVG(v_speed), 2) as viteza_medie
FROM V_MONGO_TRAFFIC_SENSORS
GROUP BY CUBE(v_weather, v_traffic_cond);

-- SELECT final
SELECT * FROM OLAP_TRAFFIC_CUBE_V;