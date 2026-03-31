DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'transport_admin') THEN
    CREATE ROLE transport_admin WITH
      LOGIN
      NOSUPERUSER
      NOCREATEDB
      NOCREATEROLE
      INHERIT
      NOREPLICATION
      CONNECTION LIMIT -1
      PASSWORD 'transport_pass';
  END IF;
END $$;

CREATE SCHEMA IF NOT EXISTS transport AUTHORIZATION transport_admin;