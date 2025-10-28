/*
=============================================================
Create Database and Schemas (PostgreSQL Version)
=============================================================
Script Purpose:
    This script creates a new database named 'datawarehouse' after checking if it already exists. 
    If the database exists, it is dropped and recreated. 
    Then, it creates three schemas within the database: 'bronze', 'silver', and 'gold'.

WARNING:
    Running this script will drop the entire 'datawarehouse' database if it exists. 
    All data in the database will be permanently deleted.
=============================================================
*/

-- Step 1: Drop the database if it exists
DROP DATABASE IF EXISTS datawarehouse;

-- Step 2: Create the database
CREATE DATABASE datawarehouse;

-- ⚠️ NOTE:
-- You must reconnect to the 'datawarehouse' database manually in pgAdmin or psql
-- before running the next section.

-- Step 3: Create schemas inside the new database
-- (Run these AFTER connecting to 'datawarehouse')
CREATE SCHEMA IF NOT EXISTS bronze;
CREATE SCHEMA IF NOT EXISTS silver;
CREATE SCHEMA IF NOT EXISTS gold;
