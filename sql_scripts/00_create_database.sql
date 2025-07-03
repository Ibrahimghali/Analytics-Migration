-- ================================================
-- Create New Database for dbt Practice
-- Run this script in SQL Server Management Studio
-- ================================================

-- Create the new database
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'dbt_analytics')
BEGIN
    CREATE DATABASE dbt_analytics;
    PRINT 'Database dbt_analytics created successfully!';
END
ELSE
BEGIN
    PRINT 'Database dbt_analytics already exists.';
END
GO

-- Switch to the new database
USE dbt_analytics;
GO

-- Create the silver and gold schemas
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'silver')
BEGIN
    EXEC('CREATE SCHEMA silver');
    PRINT 'Schema silver created successfully!';
END

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'gold')
BEGIN
    EXEC('CREATE SCHEMA gold');
    PRINT 'Schema gold created successfully!';
END
GO

-- Create raw_data schema for source tables
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'raw_data')
BEGIN
    EXEC('CREATE SCHEMA raw_data');
    PRINT 'Schema raw_data created successfully!';
END
GO

PRINT 'Database setup completed successfully!';
