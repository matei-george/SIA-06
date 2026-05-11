-- 1. Analiza Multidimensionala ROLAP

SELECT 
    statie_afisata, 
    stare_trafic_calculata, 
    COUNT(*) as volum_trafic,
    ROUND(AVG(temp_mongo), 1) as temperatura_medie
FROM V_FED_ORACLE_MONGO_COMPLEX
GROUP BY ROLLUP(statie_afisata, stare_trafic_calculata);


-- 2. Clasamentul Stațiilor după Întârziere (Funcții Analitice)
-- cele mai problematice statii pentru fiecare tip de transport.

SELECT * FROM (
    SELECT 
        statie_afisata,
        transport_type,
        intarziere_mongo,
        vreme_mongo,
        RANK() OVER (PARTITION BY transport_type ORDER BY intarziere_mongo DESC) as pozitie_in_top
    FROM V_FED_ORACLE_MONGO_COMPLEX
)
WHERE pozitie_in_top <= 3
ORDER BY transport_type, pozitie_in_top;


-- 3. Analiza Multidimensională cu CUBE (Vreme vs. Trafic)
-- corelatia dintre conditiile meteo si starea traficului.

SELECT 
    NVL(vreme_mongo, '{ORICE VREME}') as conditii_meteo,
    NVL(stare_trafic_calculata, '{ORICE TRAFIC}') as status_trafic,
    COUNT(*) as numar_inregistrari,
    ROUND(AVG(intarziere_mongo), 2) as medie_intarziere_min
FROM V_FED_ORACLE_MONGO_COMPLEX
GROUP BY CUBE(vreme_mongo, stare_trafic_calculata)
ORDER BY numar_inregistrari DESC;


-- 4. Identificarea Punctelor Critice
-- clasificare in functie de cea mai mare intarziere in mongoDB

SELECT * FROM (
    SELECT 
        statie_afisata,
        transport_type,
        intarziere_mongo,
        RANK() OVER (PARTITION BY transport_type ORDER BY intarziere_mongo DESC) as clasament_intarziere
    FROM V_FED_ORACLE_MONGO_COMPLEX
) 
WHERE clasament_intarziere = 1;

-- 5. Analiza de Mediu (CUBE)
-- cum se comporta traficul în funcție de pragurile de temperatură

SELECT 
    CASE 
        WHEN temp_mongo < 10 THEN 'FRIG'
        WHEN temp_mongo BETWEEN 10 AND 25 THEN 'MODERAT'
        ELSE 'CALD'
    END as categorie_temperatura,
    NVL(stare_trafic_calculata, 'TOATE STARILE') as status_trafic,
    COUNT(*) as nr_citiri_senzor,
    ROUND(AVG(intarziere_mongo), 2) as delay_mediu
FROM V_FED_ORACLE_MONGO_COMPLEX
GROUP BY CUBE (
    CASE 
        WHEN temp_mongo < 10 THEN 'FRIG'
        WHEN temp_mongo BETWEEN 10 AND 25 THEN 'MODERAT'
        ELSE 'CALD'
    END, 
    stare_trafic_calculata
)
ORDER BY categorie_temperatura;

-- 6. Raport de Eficiență pe Tip de Transport (CUBE)
-- performanța per vehicul (din Mongo) raportată la stația de origine (din Oracle)

SELECT 
    NVL(transport_type, '--- TOTAL GENERAL ---') as vehicul,
    NVL(statie_afisata, '--- TOATE STATIILE ---') as locatie,
    COUNT(*) as total_curse_monitorizate,
    ROUND(AVG(intarziere_mongo), 2) as medie_intarziere_api
FROM V_FED_ORACLE_MONGO_COMPLEX
GROUP BY GROUPING SETS ((transport_type), (statie_afisata), ());