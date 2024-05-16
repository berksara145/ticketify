-- Create the database if it doesn't exist
CREATE DATABASE IF NOT EXISTS cs353dbproject;

-- Use the database
USE cs353dbproject;

CREATE TABLE IF NOT EXISTS user (
user_id CHAR(3) PRIMARY KEY,
first_name VARCHAR(60),
last_name VARCHAR(60),
email VARCHAR(100),
password VARCHAR(40) NOT NULL,
user_type VARCHAR(20)
);

INSERT INTO user (user_id, first_name, last_name, email, password, user_type) VALUES
    ('111','aly', 'zeyzey' ,'aly@gmail.com', 'password123', 'user');
