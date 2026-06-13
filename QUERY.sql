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