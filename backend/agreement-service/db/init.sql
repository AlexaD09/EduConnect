-- agreement-service/db/init.sql


CREATE TABLE IF NOT EXISTS tutors (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    id_number VARCHAR(15) NOT NULL,
    city VARCHAR(100) NOT NULL,
    contact_email VARCHAR(100),
    contact_phone VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS assignments (
    id SERIAL PRIMARY KEY,
    student_id INT NOT NULL,          
    agreement_id INT NOT NULL,        
    tutor_id INT NOT NULL REFERENCES tutors(id),
    assigned_at TIMESTAMP DEFAULT NOW()
);