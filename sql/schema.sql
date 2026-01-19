-- Database schema for Food Delivery SQL Analytics Project
-- This file defines the core tables used for analysis


-- Restaurants Table

CREATE TABLE restaurants (
    restaurant_id INT PRIMARY KEY,
    restaurant_name TEXT,
    area TEXT,
    cuisines TEXT,
    rating FLOAT,
    cost_for_two FLOAT,
    online_order INT
);


-- Orders Table

CREATE TABLE orders (
    order_id VARCHAR(50) PRIMARY KEY,
    order_type TEXT,
    restaurant_latitude FLOAT,
    restaurant_longitude FLOAT
);


-- Delivery Partners Table

CREATE TABLE delivery_partners (
    partner_pk INT PRIMARY KEY,
    delivery_partner_id VARCHAR(50) UNIQUE,
    age INT,
    partner_rating FLOAT,
    vehicle_type TEXT
);


-- Delivery Details Table

CREATE TABLE delivery_details (
    order_id VARCHAR(50),
    delivery_partner_id VARCHAR(50),
    delivery_location_latitude FLOAT,
    delivery_location_longitude FLOAT,
    time_taken_min FLOAT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (delivery_partner_id) REFERENCES delivery_partners(delivery_partner_id)
);
