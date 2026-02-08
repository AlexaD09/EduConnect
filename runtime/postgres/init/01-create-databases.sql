DO
$do$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_database WHERE datname = 'bd_academic_users') THEN
    CREATE DATABASE bd_academic_users;
  END IF;

  IF NOT EXISTS (SELECT FROM pg_database WHERE datname = 'activity_db') THEN
    CREATE DATABASE activity_db;
  END IF;

  IF NOT EXISTS (SELECT FROM pg_database WHERE datname = 'agreement_db') THEN
    CREATE DATABASE agreement_db;
  END IF;

  IF NOT EXISTS (SELECT FROM pg_database WHERE datname = 'approval_db') THEN
    CREATE DATABASE approval_db;
  END IF;
END
$do$;

GRANT ALL PRIVILEGES ON DATABASE bd_academic_users TO appuser;
GRANT ALL PRIVILEGES ON DATABASE activity_db TO appuser;
GRANT ALL PRIVILEGES ON DATABASE agreement_db TO appuser;
GRANT ALL PRIVILEGES ON DATABASE approval_db TO appuser;
