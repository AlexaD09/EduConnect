CREATE TABLE activities (
    id SERIAL PRIMARY KEY,
    student_id INT NOT NULL,
    agreement_id INT NOT NULL,
    description TEXT NOT NULL,
    entry_photo_path VARCHAR(255),  
    exit_photo_path VARCHAR(255),   
    status VARCHAR(20) DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT NOW()
);