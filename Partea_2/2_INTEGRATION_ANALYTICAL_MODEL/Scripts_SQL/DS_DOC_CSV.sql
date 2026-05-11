-------------------------------------------------------------------------
-- SECTIUNE: VIRTUALIZARE CSV (PORT 8097)
-------------------------------------------------------------------------

-- 1. Inregistrare Endpoint-uri REST in Spark
SELECT java_method('org.spark.service.rest.RESTEnabledSQLService', 'createJSONViewFromREST', 'v_sql_trips_raw', 'http://localhost:8090/DSA-SQL-JDBCService/rest/transport/TripsPostgresView');

SELECT java_method('org.spark.service.rest.RESTEnabledSQLService', 'createJSONViewFromREST', 'v_sql_weather_raw', 'http://localhost:8090/DSA-SQL-JDBCService/rest/transport/WeatherPostgresView');

SELECT java_method('org.spark.service.rest.RESTEnabledSQLService', 'createJSONViewFromREST', 'v_sql_metrics_raw', 'http://localhost:8090/DSA-SQL-JDBCService/rest/transport/MetricsPostgresView');

-- 2. Creare Vederi Tabelare (Aplatizare)
CREATE OR REPLACE VIEW view_trips_postgres AS SELECT v.* FROM v_sql_trips_raw LATERAL VIEW explode(array) AS v;

CREATE OR REPLACE VIEW view_weather_postgres AS SELECT v.* FROM v_sql_weather_raw LATERAL VIEW explode(array) AS v;

CREATE OR REPLACE VIEW view_metrics_postgres AS SELECT v.* FROM v_sql_metrics_raw LATERAL VIEW explode(array) AS v;

-- 3. Testare rapida
SELECT * FROM view_trips_postgres LIMIT 10;