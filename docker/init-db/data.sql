--USER-SERVICE

-- Roles
INSERT INTO roles (name) VALUES
('STUDENT'),
('TUTOR'),
('COORDINATOR');

-- Tutors
INSERT INTO tutors (full_name, phone)
SELECT
    'Tutor ' || i,
    '099000' || i
FROM generate_series(1,20) AS i;

-- Users
INSERT INTO users (full_name, email, role_id)
SELECT
    'User ' || i,
    'user' || i || '@example.com',
    (i % 3) + 1
FROM generate_series(1,100) AS i;
