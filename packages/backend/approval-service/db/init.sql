 
CREATE TABLE approval_logs (
    id SERIAL PRIMARY KEY,
    activity_id INT NOT NULL,
    coordinator_id INT NOT NULL,
    action VARCHAR(20) NOT NULL,  
    observations TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);