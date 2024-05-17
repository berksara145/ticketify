-- Create the database if it doesn't exist
CREATE DATABASE IF NOT EXISTS cs353dbproject;

-- Use the database
USE cs353dbproject;

CREATE TABLE IF NOT EXISTS user (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(60),
    last_name VARCHAR(60),
    email VARCHAR(100),
    password VARCHAR(40) NOT NULL,
    user_type VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS organizer (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    password VARCHAR(40) NOT NULL,
    first_name VARCHAR(60),
    last_name VARCHAR(60),
    email VARCHAR(100),
    user_type VARCHAR(20),
    phone_no VARCHAR(13)
);

CREATE TABLE IF NOT EXISTS  worker_bee (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    password VARCHAR(40) NOT NULL,
    first_name VARCHAR(60),
    last_name VARCHAR(60),
    email VARCHAR(100),
    user_type VARCHAR(20),
    issue_count INT
);

CREATE TABLE IF NOT EXISTS  buyer (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    password VARCHAR(40) NOT NULL,
    first_name VARCHAR(60),
    last_name VARCHAR(60),
    email VARCHAR(100),
    user_type VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS  admin (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    password VARCHAR(40) NOT NULL,
    first_name VARCHAR(60),
    last_name VARCHAR(60),
    email VARCHAR(100),
    user_type VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS  report(
    report_id INT AUTO_INCREMENT PRIMARY KEY,
    report_date VARCHAR(10) NOT NULL,
    report_text VARCHAR(8192)
);

CREATE TABLE IF NOT EXISTS  venue(
    venue_id INT AUTO_INCREMENT PRIMARY KEY,
    venue_name VARCHAR(64) NOT NULL,
    address VARCHAR(64) NOT NULL,
    phone_no VARCHAR(13),
    section_count INT NOT NULL,
    url_photo VARCHAR(255),
    venue_row_length INT,
    venue_column_length INT
);

CREATE TABLE IF NOT EXISTS  event(
    event_id INT AUTO_INCREMENT PRIMARY KEY,
    event_name VARCHAR(64) NOT NULL,
    start_date VARCHAR(10) NOT NULL,
    end_date VARCHAR(10),
    event_category VARCHAR(20),
    ticket_prices VARCHAR(255) NOT NULL,
    url_photo VARCHAR(255),
    description_text VARCHAR(800),
    event_rules VARCHAR(8192) NOT NULL
);

CREATE TABLE IF NOT EXISTS  performer(
    performer_id INT AUTO_INCREMENT PRIMARY KEY,
    performer_name VARCHAR(64) NOT NULL
);

CREATE TABLE IF NOT EXISTS  issue(
    issue_id INT AUTO_INCREMENT PRIMARY KEY,
    issue_text VARCHAR(8192) NOT NULL,
    response_text VARCHAR(8192)
);

CREATE TABLE IF NOT EXISTS  transaction(
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    date DATE
);

CREATE TABLE IF NOT EXISTS  Payment (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    amount DECIMAL(10, 2)
);

CREATE TABLE IF NOT EXISTS  tickets(
    ticket_id INT AUTO_INCREMENT PRIMARY KEY,
    is_bought BOOLEAN DEFAULT FALSE,
    ticket_barcode VARCHAR(64),
    ticket_price INT NOT NULL
);

-- weak entities
CREATE TABLE IF NOT EXISTS  seats (
    seat_position VARCHAR(8),
    venue_id INT,
    PRIMARY KEY (seat_position, venue_id),
    FOREIGN KEY (venue_id) REFERENCES venue(venue_id)
);


-- relations

-- Table: make
CREATE TABLE IF NOT EXISTS  make (
    issue_id INT,
    user_id INT,
    PRIMARY KEY (issue_id, user_id),
    FOREIGN KEY (user_id) REFERENCES user(user_id)
);

-- Table: create
CREATE TABLE IF NOT EXISTS  createe (
    issue_id INT,
    user_id INT,
    PRIMARY KEY (issue_id, user_id)
);

-- Table: respond
CREATE TABLE IF NOT EXISTS  respond (
    issue_id INT,
    user_id INT,
    PRIMARY KEY (issue_id, user_id),
    FOREIGN KEY (user_id) REFERENCES user(user_id)
);

-- Table: organization_organize_event
CREATE TABLE IF NOT EXISTS  organization_organize_event (
    user_id INT,
    event_id INT,
    PRIMARY KEY (user_id, event_id),
    FOREIGN KEY (user_id) REFERENCES user(user_id)
);

-- Table: perform
CREATE TABLE IF NOT EXISTS  perform (
    performer_id INT,
    event_id INT,
    PRIMARY KEY (performer_id, event_id)
);

-- Table: browse
CREATE TABLE IF NOT EXISTS  browse (
    user_id INT,
    event_id INT,
    PRIMARY KEY (user_id, event_id),
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (event_id) REFERENCES event(event_id)
);

-- Table: event_has_ticket
CREATE TABLE IF NOT EXISTS  event_has_ticket (
    event_id INT,
    ticket_id INT,
    PRIMARY KEY (event_id, ticket_id),
    FOREIGN KEY (event_id) REFERENCES event(event_id)
);

-- Table: buy
CREATE TABLE IF NOT EXISTS  buy (
    user_id INT,
    payment_id INT,
    ticket_id INT,
    PRIMARY KEY (user_id, payment_id, ticket_id),
    FOREIGN KEY (user_id) REFERENCES user(user_id)
);

-- Table: event_in_venue
CREATE TABLE IF NOT EXISTS  event_in_venue (
    event_id INT,
    venue_id INT,
    PRIMARY KEY (event_id, venue_id),
    FOREIGN KEY (venue_id) REFERENCES venue(venue_id)
);

-- Table: ticket_seat
CREATE TABLE IF NOT EXISTS  ticket_seat (
    ticket_id INT,
    seat_position CHAR(11),
    PRIMARY KEY (ticket_id, seat_position),
    FOREIGN KEY (ticket_id) REFERENCES tickets(ticket_id)
);

-- Table: contains
CREATE TABLE IF NOT EXISTS  contains (
    payment_id INT,
    transaction_id INT,
    PRIMARY KEY (payment_id, transaction_id)
);

-- Table: write
CREATE TABLE IF NOT EXISTS  writee (
    user_id INT,
    report_id INT,
    PRIMARY KEY (user_id, report_id),
    FOREIGN KEY (user_id) REFERENCES user(user_id)
);

-- Table: generate
CREATE TABLE IF NOT EXISTS  generate (
    user_id INT,
    venue_id INT,
    PRIMARY KEY (user_id, venue_id),
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (venue_id) REFERENCES venue(venue_id)
);