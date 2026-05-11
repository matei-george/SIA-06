----------------------------------------------------------------------------------
-- 1. Înregistrarea JSON-ului din serviciul CSV
----------------------------------------------------------------------------------
SELECT java_method(
               'org.spark.service.rest.RESTEnabledSQLService',
               'createJSONViewFromREST',
               'view_routes_json_raw', -- Numele vederii intermediare
               'http://localhost:8097/DSA-DOC-CSVService/rest/transport/RoutesView');

-- Verifică dacă datele brute au ajuns
SELECT * FROM view_routes_json_raw;

----------------------------------------------------------------------------------
-- 2. Crearea Vederii Finale (Aplatizate)
----------------------------------------------------------------------------------
CREATE OR REPLACE VIEW view_routes AS
SELECT v.*
FROM view_routes_json_raw as json_view
    LATERAL VIEW explode(json_view.array) AS v; [cite: 127-129]

----------------------------------------------------------------------------------
-- 3. Testare Tabel Final
----------------------------------------------------------------------------------
SELECT * FROM view_routes;