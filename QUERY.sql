-- =========================================================================
-- SYSTEM: Football Ticket Booking System Database Setup Template
-- DESCRIPTION: Pseudo-DDL Template for Table Creation & Data Insertion
-- INSTRUCTIONS: Replace 'TYPE' and the constraint placeholders with your own
--               actual data types, relational keys, and check criteria.
-- =========================================================================

-- DROP TABLES IF THEY ALREADY EXIST TO PREVENT CONFLICTS
DROP TABLE IF EXISTS Bookings;
DROP TABLE IF EXISTS Matches;
DROP TABLE IF EXISTS Users;

-- =========================================================================
-- 0. CREATE ENUMS
-- =========================================================================

CREATE TYPE user_role AS ENUM (
    'Ticket Manager',
    'Football Fan'
);

CREATE TYPE match_status AS ENUM (
    'Available',
    'Selling Fast',
    'Sold Out',
    'Postponed'
);

CREATE TYPE payment_status AS ENUM (
    'Pending',
    'Confirmed',
    'Cancelled',
    'Refunded'
);


-- =========================================================================
-- 1. CREATE USERS TABLE
-- =========================================================================


CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100),
    email VARCHAR(150) UNIQUE,
    role user_role NOT NULL,
    phone_number VARCHAR(20)
);

-- =========================================================================
-- 2. CREATE MATCHES TABLE
-- =========================================================================
CREATE TABLE Matches (
    match_id SERIAL PRIMARY KEY,
    fixture VARCHAR(150),
    tournament_category VARCHAR(100),
    base_ticket_price DECIMAL(10, 2),
    match_status match_status NOT NULL,
    CONSTRAINT chk_ticket_price
        CHECK (base_ticket_price >= 0)
);

-- =========================================================================
-- 3. CREATE BOOKINGS TABLE
-- =========================================================================
CREATE TABLE Bookings (
    booking_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    match_id INT NOT NULL,
    seat_number VARCHAR(20),
    payment_status payment_status,
    total_cost DECIMAL(10, 2),

    CONSTRAINT fk_booking_user
        FOREIGN KEY (user_id)
        REFERENCES Users(user_id),

    CONSTRAINT fk_booking_match
        FOREIGN KEY (match_id)
        REFERENCES Matches(match_id),

    CONSTRAINT chk_total_cost
        CHECK (total_cost >= 0)
);


-- =========================================================================
-- DATA SEEDING: INSERT SAMPLE DATA INTO USERS
-- =========================================================================
INSERT INTO Users (user_id, full_name, email, role, phone_number) VALUES
(1, 'Tanvir Rahman', 'tanvir@mail.com', 'Football Fan', '+8801711111111'),
(2, 'Asif Haque', 'asif@mail.com', 'Football Fan', '+8801722222222'),
(3, 'Sajjad Rahman', 'sajjad@mail.com', 'Ticket Manager', '+8801733333333'),
(4, 'Jannat Ara', 'jannat@mail.com', 'Football Fan', NULL);

-- =========================================================================
-- DATA SEEDING: INSERT SAMPLE DATA INTO MATCHES
-- =========================================================================
INSERT INTO Matches (match_id, fixture, tournament_category, base_ticket_price, match_status) VALUES
(101, 'Real Madrid vs Barcelona', 'Champions League', 150.00, 'Available'),
(102, 'Man City vs Liverpool', 'Premier League', 120.00, 'Selling Fast'),
(103, 'Bayern Munich vs PSG', 'Champions League', 130.00, 'Available'),
(104, 'AC Milan vs Inter Milan', 'Serie A', 90.00, 'Sold Out'),
(105, 'Juventus vs Roma', 'Serie A', 80.00, 'Available');

-- =========================================================================
-- DATA SEEDING: INSERT SAMPLE DATA INTO BOOKINGS
-- =========================================================================
INSERT INTO Bookings (booking_id, user_id, match_id, seat_number, payment_status, total_cost) VALUES
(501, 1, 101, 'A-12', 'Confirmed', 150.00),
(502, 1, 102, 'B-04', 'Confirmed', 120.00),
(503, 2, 101, 'A-13', 'Confirmed', 150.00),
(504, 2, 101, NULL, NULL, 150.00),
(505, 3, 102, 'C-20', 'Pending', 120.00);

-- =====================
-- Query 1
-- =====================
SELECT match_id, fixture, base_ticket_price 
FROM matches
WHERE tournament_category = 'Champions League'
    AND match_status = 'Available';


-- =====================
-- Query 2
-- =====================
SELECT user_id, full_name, email
FROM Users
WHERE full_name ILIKE 'Tanvir%'
   OR full_name ILIKE '%Haque%';

   -- =====================
-- Query 3
-- =====================
SELECT 
    booking_id,
    user_id,
    match_id,
    COALESCE(payment_status::TEXT, 'Action Required') AS systematic_status
FROM bookings
WHERE payment_status IS NULL;

-- =====================
-- Query 4
-- =====================
SELECT 
    b.booking_id,
    u.full_name,
    m.fixture,
    b.total_cost
FROM Bookings b
INNER JOIN Users u
    ON b.user_id = u.user_id
INNER JOIN Matches m
    ON b.match_id = m.match_id;


-- =====================
-- Query 5
-- =====================
SELECT 
    u.user_id,
    u.full_name,
    b.booking_id
FROM Users u
LEFT JOIN Bookings b
    ON u.user_id = b.user_id;