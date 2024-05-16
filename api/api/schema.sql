-- Create the database if it doesn't exist
CREATE DATABASE IF NOT EXISTS cs353dbproject;

-- Use the database
USE cs353dbproject;

CREATE TABLE user (
user_id CHAR(11) PRIMARY KEY,
password VARCHAR(40) NOT NULL,
first_name VARCHAR(60),
last_name VARCHAR(60),
email VARCHAR(100),
user_type VARCHAR(20)
)


-- Optionally, you can add any additional columns or constraints here.

-- Sample data insertion (optional)
INSERT INTO user (id,email, password) VALUES
    ('1','aly@gmail.com', 'password123');
-- You can add more INSERT statements to insert more sample data if needed.
