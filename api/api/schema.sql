-- Create the database if it doesn't exist
CREATE DATABASE IF NOT EXISTS cs353dbproject;

-- Use the database
USE cs353dbproject;

-- Create the user table
CREATE TABLE user (
    id VARCHAR(5) PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
);

-- Optionally, you can add any additional columns or constraints here.

-- Sample data insertion (optional)
INSERT INTO user (id,email, password) VALUES
    ('1','aly@gmail.com', 'password123');
-- You can add more INSERT statements to insert more sample data if needed.
