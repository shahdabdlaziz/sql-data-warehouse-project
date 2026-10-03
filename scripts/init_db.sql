/*
===============================================================================
Script Purpose: Initialize the DataWarehouse database environment.
Description:    Safely drops the existing DataWarehouse database (terminating 
                active connections), creates a fresh database, and provisions 
                the Medallion Architecture schemas (bronze, silver, gold).
===============================================================================
*/

USE master;
GO

-- Forcefully disconnect any active sessions before dropping to prevent locking errors
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
END;
GO

CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

-- Provision Medallion Architecture schemas
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO
