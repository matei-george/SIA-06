-------------------------------------------------------------------------
-- SECTIUNE: VIRTUALIZARE MONGODB (PORT 8093)
-------------------------------------------------------------------------

-- 1. Inregistrare Endpoint REST
SELECT java_method('org.spark.service.rest.RESTEnabledSQLService', 'createJSONViewFromREST', 'v_mongo_sensors_raw', 'http://localhost:8093/DSA-NoSQL-MongoDBService/rest/transport/TrafficSensorsView');

-- 2. Aplatizare (Flattening)
CREATE OR REPLACE VIEW view_traffic_sensors AS SELECT v.* FROM v_mongo_sensors_raw LATERAL VIEW explode(array) AS v;