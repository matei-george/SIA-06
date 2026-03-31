-- 1. Creare utilizator FDBO
CREATE USER FDBO IDENTIFIED BY fdbo_pass;

-- 2. Drepturi de baza 
GRANT CONNECT, RESOURCE, DBA TO FDBO; 

-- 3. Drepturi specifice pentru acces fisiere 
GRANT CREATE ANY DIRECTORY TO FDBO;
GRANT READ, WRITE ON DIRECTORY EXT_FILE_DS TO FDBO;

-- 4. Activare acces pentru External Tables (utilizat de ORACLE_LOADER)
GRANT EXECUTE ON utl_file TO FDBO;

GRANT READ, WRITE ON DIRECTORY EXT_FILE_DS TO FDBO;

CREATE OR REPLACE DIRECTORY EXT_FILE_DS AS 'D:\Facultate\Sisteme de Integrare Informationala\data';

-- 5. Tabelele in sine

-- stops.csv
CREATE TABLE stops_ext (
    location_type       VARCHAR2(100), 
    parent_station      VARCHAR2(100), 
    stop_code           VARCHAR2(100), 
    stop_desc           VARCHAR2(100), 
    stop_id             VARCHAR2(100), 
    stop_lat            VARCHAR2(100), 
    stop_lon            VARCHAR2(100), 
    stop_name           VARCHAR2(500), 
    stop_timezone       VARCHAR2(100), 
    stop_url            VARCHAR2(100), 
    wheelchair_boarding VARCHAR2(100), 
    zone_id             VARCHAR2(100)  
)
ORGANIZATION EXTERNAL (
    TYPE ORACLE_LOADER
    DEFAULT DIRECTORY EXT_FILE_DS
    ACCESS PARAMETERS (
        RECORDS DELIMITED BY NEWLINE
        SKIP 1
        FIELDS TERMINATED BY ',' 
        OPTIONALLY ENCLOSED BY '"' 
        LRTRIM
        MISSING FIELD VALUES ARE NULL 
    )
    LOCATION ('stops.csv')
)
REJECT LIMIT UNLIMITED;



-- routes.csv
CREATE TABLE routes_ext (
    agency_id           VARCHAR2(100), 
    route_color         VARCHAR2(100), 
    route_desc          VARCHAR2(500), 
    route_id            VARCHAR2(100), 
    route_long_name     VARCHAR2(500), 
    route_short_name    VARCHAR2(200), 
    route_text_color    VARCHAR2(100), 
    route_type          VARCHAR2(100), 
    route_url           VARCHAR2(500)  
)
ORGANIZATION EXTERNAL (
    TYPE ORACLE_LOADER
    DEFAULT DIRECTORY EXT_FILE_DS 
    ACCESS PARAMETERS (
        RECORDS DELIMITED BY NEWLINE
        SKIP 1
        FIELDS TERMINATED BY ',' 
        OPTIONALLY ENCLOSED BY '"'
        LRTRIM
        MISSING FIELD VALUES ARE NULL
    )
    LOCATION ('routes.csv')
)
REJECT LIMIT UNLIMITED;


-- trips.csv
CREATE TABLE trips_ext (
    bikes_allowed         VARCHAR2(100), 
    block_id              VARCHAR2(100), 
    direction_id          VARCHAR2(100), 
    route_id              VARCHAR2(100), 
    service_id            VARCHAR2(100), 
    shape_id              VARCHAR2(100), 
    trip_headsign         VARCHAR2(500), 
    trip_id               VARCHAR2(100), 
    trip_short_name       VARCHAR2(100), 
    wheelchair_accessible VARCHAR2(100)  
)
ORGANIZATION EXTERNAL (
    TYPE ORACLE_LOADER
    DEFAULT DIRECTORY EXT_FILE_DS 
    ACCESS PARAMETERS (
        RECORDS DELIMITED BY NEWLINE
        SKIP 1 
        FIELDS TERMINATED BY ',' 
        OPTIONALLY ENCLOSED BY '"'
        LRTRIM
        MISSING FIELD VALUES ARE NULL
    )
    LOCATION ('trips.csv')
)
REJECT LIMIT UNLIMITED;

-- stop_times.csv
CREATE TABLE stop_times_ext (
    arrival_time        VARCHAR2(100), 
    departure_time      VARCHAR2(100), 
    drop_off_type       VARCHAR2(100), 
    pickup_type         VARCHAR2(100), 
    shape_dist_traveled VARCHAR2(100), 
    stop_headsign       VARCHAR2(500), 
    stop_id             VARCHAR2(100), 
    stop_sequence       VARCHAR2(100), 
    timepoint           VARCHAR2(100), 
    trip_id             VARCHAR2(100)  
)
ORGANIZATION EXTERNAL (
    TYPE ORACLE_LOADER
    DEFAULT DIRECTORY EXT_FILE_DS
    ACCESS PARAMETERS (
        RECORDS DELIMITED BY NEWLINE
        SKIP 1
        FIELDS TERMINATED BY ',' 
        OPTIONALLY ENCLOSED BY '"'
        LRTRIM
        MISSING FIELD VALUES ARE NULL
    )
    LOCATION ('stop_times.csv')
)
REJECT LIMIT UNLIMITED;