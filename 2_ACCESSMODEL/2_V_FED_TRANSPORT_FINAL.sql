SELECT 
    s.stop_name as nume_statie,
    r.route_long_name as nume_ruta,
    api.transport_type,
    
    (MOD(TO_NUMBER(REGEXP_REPLACE(api.origin_station, '[^0-9]', '')), 20) + 5) as delay_min,
    -- Atribuim o vreme variată în funcție de stație
    CASE MOD(TO_NUMBER(REGEXP_REPLACE(api.origin_station, '[^0-9]', '')), 3)
        WHEN 0 THEN 'Sunny'
        WHEN 1 THEN 'Rainy'
        ELSE 'Cloudy'
    END as weather,
    api.origin_station as statie_originala_pg
FROM STOPS_EXT s
JOIN (
    SELECT * FROM (SELECT httpuritype('http://127.0.0.1:4000/trips?limit=1000').getclob() as jd FROM dual) t,
    JSON_TABLE(t.jd, '$[*]' COLUMNS (
        origin_station   VARCHAR2(100) PATH '$.origin_station',
        transport_type   VARCHAR2(20)  PATH '$.transport_type'
    ))
) api ON 1=1 -- Facem un join logic pentru a popula stațiile
JOIN ROUTES_EXT r ON 1=1 -- Legam rutele
WHERE ROWNUM <= 500 -- Limitam pentru performanța
AND (
    -- Mapare dinamică: Stația 1 merge la prima stație din Oracle, Stația 2 la a doua, etc.
    MOD(TO_NUMBER(REGEXP_REPLACE(api.origin_station, '[^0-9]', '')), 50) = MOD(s.stop_id, 50)
)