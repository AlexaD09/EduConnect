DO
$do$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'appuser') THEN
      CREATE ROLE appuser LOGIN PASSWORD 'apppass';
   END IF;
END
$do$;
