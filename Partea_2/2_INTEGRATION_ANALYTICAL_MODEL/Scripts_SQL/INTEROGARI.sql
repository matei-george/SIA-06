-------------------------------------------------------------------------
-- MODEL ANALITIC → INTEROGARI
-------------------------------------------------------------------------

-- Murarasu Matei - George

-- 1. Analiza Performanței și Eficienței Operaționale (KPIs)

SELECT 
    t.transportType,
    COUNT(t.tripId) AS total_curse,
    SUM(CASE WHEN m.delayed = true THEN 1 ELSE 0 END) AS curse_intarziate,
    ROUND(AVG(m.trafficCongestionIndex), 2) AS medie_congestie_trafic,
    ROUND((SUM(CASE WHEN m.delayed = true THEN 1 ELSE 0 END) * 100.0 / COUNT(t.tripId)), 2) AS procent_intarziere
FROM view_trips_postgres t
JOIN view_metrics_postgres m ON t.tripId = m.tripId
GROUP BY t.transportType
ORDER BY procent_intarziere DESC;

-- 2. Profilul Orelor de Vârf per Sezon

SELECT 
    m.season,
    m.peakHour,
    COUNT(*) as numar_inregistrari,
    ROUND(AVG(m.eventAttendanceEst), 0) as medie_pasageri_evenimente,
    MAX(m.trafficCongestionIndex) as congestie_maxima_raportata
FROM view_metrics_postgres m
WHERE m.peakHour = true
GROUP BY m.season, m.peakHour
ORDER BY medie_pasageri_evenimente DESC;

-- 3. Analiza Fenomenelor Meteo Extreme și Impactul lor Comercial

SELECT 
    w.weatherCondition,
    m.eventType,
    ROUND(AVG(w.precipitationMm), 2) as medie_precipitatii_mm,
    ROUND(AVG(m.eventAttendanceEst), 0) as prezenta_medie_eveniment,
    ROUND(AVG(m.trafficCongestionIndex), 2) as indice_congestie_mediu
FROM view_weather_postgres w
JOIN view_metrics_postgres m ON w.tripId = m.tripId
WHERE w.precipitationMm > 0
GROUP BY w.weatherCondition, m.eventType
ORDER BY medie_precipitatii_mm DESC;

-------------------------------------------------------------------------

-- Gradinaru Cosmin - Gabriel

-- 4. Distribuția Întârzierilor pe Zilele Săptămânii și Sezoane

SELECT 
    m.season,
    m.weekday, -- 1=Luni, 7=Duminica
    COUNT(*) as total_tripuri,
    SUM(CASE WHEN m.delayed = true THEN 1 ELSE 0 END) as curse_intarziate,
    ROUND(AVG(m.trafficCongestionIndex), 2) as nivel_mediu_congestie
FROM view_metrics_postgres m
GROUP BY m.season, m.weekday
ORDER BY m.season, m.weekday;

-- 5. Validarea Senzorilor: Congestie Raportată vs. Senzori NoSQL

SELECT 
    t.tripId,
    t.originStation,
    m.trafficCongestionIndex AS congestie_postgres,
    s.traffic_congestion_index AS congestie_senzori_mongo,
    ABS(m.trafficCongestionIndex - s.traffic_congestion_index) AS diferenta_eroare,
    CASE 
        WHEN ABS(m.trafficCongestionIndex - s.traffic_congestion_index) > 3 THEN 'Necesita Recalibrare'
        ELSE 'Sincronizat'
    END AS status_senzor
FROM view_trips_postgres t
JOIN view_metrics_postgres m ON t.tripId = m.tripId
JOIN view_traffic_sensors s ON t.tripId = s.trip_id
WHERE m.peakHour = true;

-- 6. Impactul Temperaturii asupra Prezenței la Evenimente

SELECT 
    m.eventType,
    CASE 
        WHEN w.temperatureC > 30 THEN 'Canicula'
        WHEN w.temperatureC < 5 THEN 'Frig extrem'
        ELSE 'Optim'
    END AS confort_termic,
    ROUND(AVG(m.eventAttendanceEst), 0) AS medie_participanti,
    ROUND(AVG(m.trafficCongestionIndex), 2) AS impact_trafic_mediu
FROM view_metrics_postgres m
JOIN view_weather_postgres w ON m.tripId = w.tripId
GROUP BY m.eventType, confort_termic
ORDER BY medie_participanti DESC;

-------------------------------------------------------------------------

-- Ancuta Constantin Alexandru

-- 7. Analiza Eficienței pe Interval de Congestie

SELECT 
    CASE 
        WHEN m.trafficCongestionIndex >= 8 THEN 'Zona Rosie (Critic)'
        WHEN m.trafficCongestionIndex BETWEEN 5 AND 7 THEN 'Zona Galbena (Avertizare)'
        ELSE 'Zona Verde (Fluid)'
    END AS zona_congestie,
    COUNT(*) as numar_curse,
    ROUND(AVG(CASE WHEN m.delayed = true THEN 1 ELSE 0 END) * 100, 2) as probabilitate_intarziere_procent,
    ROUND(AVG(m.eventAttendanceEst), 0) as medie_pasageri
FROM view_metrics_postgres m
GROUP BY 1
ORDER BY probabilitate_intarziere_procent DESC;

-- 8. Analiza „Smart City”: Senzori (Mongo) vs. Vreme (Postgres)

SELECT 
    w.weatherCondition,
    ROUND(AVG(w.temperatureC), 1) as temperatura_medie,
    ROUND(AVG(s.traffic_congestion_index), 2) as flux_senzori_mongo,
    MAX(s.traffic_congestion_index) as varf_congestie_senzor
FROM view_weather_postgres w
JOIN view_traffic_sensors s ON w.tripId = s.trip_id
WHERE w.precipitationMm > 0.5
GROUP BY w.weatherCondition
ORDER BY flux_senzori_mongo DESC;

-- 9. Analiza Senzorilor (Mongo) vs. Target Performanță (Postgres)

SELECT 
    s.origin_station,
    t.transportType,
    ROUND(AVG(s.traffic_congestion_index), 2) as flux_mediu_senzori,
    COUNT(CASE WHEN m.delayed = true THEN 1 END) as numar_intarzieri_confirmate,
    MAX(m.trafficCongestionIndex) as congestie_maxima_raportata_pg
FROM view_traffic_sensors s
JOIN view_trips_postgres t ON s.trip_id = t.tripId
JOIN view_metrics_postgres m ON t.tripId = m.tripId
GROUP BY s.origin_station, t.transportType
HAVING flux_mediu_senzori > 5
ORDER BY flux_mediu_senzori DESC;