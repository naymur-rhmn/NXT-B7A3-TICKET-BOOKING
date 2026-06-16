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
-- 1. CREATE USERS TABLE
-- =========================================================================
CREATE TABLE users (
  user_id SERIAL,
  full_name VARCHAR(150) NOT NULL,
  email VARCHAR(150) NOT NULL,
  role VARCHAR(20) NOT NULL,
  phone_number VARCHAR(20),

  CONSTRAINT pk_user_id
    PRIMARY KEY (user_id),

  CONSTRAINT unq_email
    UNIQUE (email),

  CONSTRAINT cq_role
    CHECK (role IN ('Ticket Manager', 'Football Fan'))
);


-- =========================================================================
-- 2. CREATE MATCHES TABLE
-- =========================================================================
CREATE TABLE matches (
  match_id SERIAL,
  fixture VARCHAR(150) NOT NULL,
  tournament_category VARCHAR(100) NOT NULL,
  base_ticket_price NUMERIC(10,2) NOT NULL,
  match_status VARCHAR(20) NOT NULL,

  CONSTRAINT pk_matches PRIMARY KEY (match_id),

  CONSTRAINT chk_ticket_price_matches
    CHECK (base_ticket_price > 0),
  
  CONSTRAINT chk_match_status
    CHECK (match_status IN ('Available', 'Selling Fast', 'Sold Out', 'Postponed'))
);

-- =========================================================================
-- 3. CREATE BOOKINGS TABLE
-- =========================================================================
CREATE TABLE bookings (
    booking_id SERIAL,
    user_id INT,
    match_id INT,
    seat_number VARCHAR(20),
    payment_status VARCHAR(20) ,
    total_cost NUMERIC(10,2) NOT NULL,

    CONSTRAINT pk_booking PRIMARY KEY (booking_id),

    CONSTRAINT fk_user
      FOREIGN KEY (user_id) REFERENCES users(user_id),
  
    CONSTRAINT fk_match 
      FOREIGN KEY (match_id) REFERENCES matches(match_id),

    CONSTRAINT chk_payment_status
        CHECK (payment_status IN ('Pending', 'Confirmed', 'Cancelled', 'Refunded')
        OR payment_status IS NULL
        ),

    CONSTRAINT chk_total_cost
        CHECK (total_cost > 0),

    CONSTRAINT uq_match_seat
        UNIQUE (match_id, seat_number)
)

