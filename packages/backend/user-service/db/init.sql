-- =====================================================
-- Create database if it does not exist
-- =====================================================
DO
$do$
BEGIN
   IF NOT EXISTS (
      SELECT FROM pg_database WHERE datname = 'bd_academic_users'
   ) THEN
      CREATE DATABASE bd_academic_users;
   END IF;
END
$do$;


\c bd_academic_users;


CREATE TABLE IF NOT EXISTS roles (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);


CREATE TABLE IF NOT EXISTS students (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    id_number VARCHAR(15) NOT NULL,  
    city VARCHAR(100) NOT NULL,
    career VARCHAR(150) NOT NULL
);

CREATE TABLE IF NOT EXISTS agreements (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    institution VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    coordinator_name VARCHAR(255) NOT NULL,
    coordinator_id_number VARCHAR(15) NOT NULL
);


CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(100) UNIQUE NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(128) NOT NULL,
    role_id INT REFERENCES roles(id),
    student_id INT REFERENCES students(id) ON DELETE CASCADE,    
    agreement_id INT REFERENCES agreements(id) ON DELETE CASCADE 
);

CREATE TABLE IF NOT EXISTS batch_control (
    id SERIAL PRIMARY KEY,
    batch_name VARCHAR(100) UNIQUE NOT NULL,
    executed_at TIMESTAMP DEFAULT NOW()
);

-- ===================================================== 
-- roles
-- =====================================================
INSERT INTO roles (name)
SELECT 'ADMIN' WHERE NOT EXISTS (SELECT 1 FROM roles WHERE name = 'ADMIN');

INSERT INTO roles (name)
SELECT 'STUDENT' WHERE NOT EXISTS (SELECT 1 FROM roles WHERE name = 'STUDENT');

INSERT INTO roles (name)
SELECT 'COORDINATOR' WHERE NOT EXISTS (SELECT 1 FROM roles WHERE name = 'COORDINATOR');

