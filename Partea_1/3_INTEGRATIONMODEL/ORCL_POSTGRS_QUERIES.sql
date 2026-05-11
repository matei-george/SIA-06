-- 1. Definirea Logicii de Integrare
-- arata legătura dintre infrastructura planificată și călătoriile active
SELECT 
    NVL(nume_ruta, 'TOTAL RETEA') as ruta,
    NVL(nume_statie, 'Subtotal Ruta') as statie,
    COUNT(*) as nr_opriri,
    SUM(delay_min) as total_minute_pierdute,
    MAX(delay_min) as cea_mai_mare_intarziere
FROM V_FED_TRANSPORT_FINAL
GROUP BY ROLLUP(nume_ruta, nume_statie);

-- 2. Analiza Performanței pe Rute - CUBE
-- Calculează volumul de opriri, totalul minutelor pierdute și cea mai mare întârziere înregistrată.
SELECT 
    NVL(weather, 'Toate Conditiile') as conditii_meteo,
    NVL(transport_type, 'Toate Vehiculele') as vehicul,
    COUNT(*) as numar_curse,
    ROUND(AVG(delay_min), 2) as medie_intarziere
FROM V_FED_TRANSPORT_FINAL
GROUP BY CUBE(weather, transport_type)
ORDER BY medie_intarziere DESC;

-- 3. Identificarea stațiilor cu cel mai mare impact asupra întârzierii rutei
-- Folosește RATIO_TO_REPORT pentru procente automate
SELECT 
    nume_ruta,
    nume_statie,
    delay_min as intarziere_statie,
    ROUND(100 * RATIO_TO_REPORT(delay_min) OVER (PARTITION BY nume_ruta), 2) || '%' as pondere_in_intarziere_ruta
FROM V_FED_TRANSPORT_FINAL
WHERE delay_min > 0
ORDER BY nume_ruta, intarziere_statie DESC;


-- 4. Clasamentul Eficienței (RANK)
-- Top 3 cele mai punctuale stații pentru fiecare rută în parte
SELECT * FROM (
    SELECT 
        nume_ruta,
        nume_statie,
        delay_min,
        RANK() OVER (PARTITION BY nume_ruta ORDER BY delay_min ASC) as rang_punctualitate
    FROM V_FED_TRANSPORT_FINAL
)
WHERE rang_punctualitate <= 3
ORDER BY nume_ruta, rang_punctualitate;


-- 5. Sinteza pe Categorii (GROUPING SETS)
-- Totalurile pe tip de transport și totalurile pe condiții meteo
SELECT 
    NVL(transport_type, '--- TOTAL PE VREME ---') as categorie_vehicul,
    NVL(weather, '--- TOTAL PE VEHICUL ---') as categorie_meteo,
    COUNT(*) as total_curse,
    ROUND(AVG(delay_min), 2) as medie_delay
FROM V_FED_TRANSPORT_FINAL
GROUP BY GROUPING SETS (transport_type, weather);

-- 6. Analiza de flux: "Unde s-a pierdut timpul efectiv?"
-- Compară întârzierea curentă cu cea de la stația anterioară de pe aceeași rută
SELECT 
    nume_ruta,
    nume_statie,
    delay_min as intarziere_curenta,
    LAG(delay_min, 1, 0) OVER (PARTITION BY nume_ruta ORDER BY nume_statie) as intarziere_statia_trecuta,
    delay_min - LAG(delay_min, 1, 0) OVER (PARTITION BY nume_ruta ORDER BY nume_statie) as diferenta_timp
FROM V_FED_TRANSPORT_FINAL
ORDER BY nume_ruta, nume_statie;
