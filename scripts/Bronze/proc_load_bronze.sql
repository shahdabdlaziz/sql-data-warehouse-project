/*
===============================================================================
Stored Procedure: bronze.load_bronze
Description:    Executes a "Full Load" process to ingest raw CSV files into 
                the Bronze layer. Encapsulated in a stored procedure for 
                reusability, scheduling, and execution tracking.
===============================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze
AS
BEGIN
    -- Suppress 'x rows affected' messages to reduce network traffic and ETL overhead
    SET NOCOUNT ON;

    DECLARE @start_time DATETIME = GETDATE();
    DECLARE @end_time DATETIME;

    BEGIN TRY
        PRINT '====================================================================';
        PRINT 'STARTING BRONZE LAYER DATA INGESTION';
        PRINT '====================================================================';

        -- ============================================================================
        -- CRM Data Ingestion
        -- ============================================================================

        PRINT '>> Truncating and Loading: bronze.crm_cust_info';
        TRUNCATE TABLE bronze.crm_cust_info;
        BULK INSERT bronze.crm_cust_info
        FROM 'C:\Users\shahd\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
        WITH (
            FIRSTROW = 2, -- Skip the CSV header row
            FIELDTERMINATOR = ',',
            TABLOCK       -- Enforce table-level locking
        );

        PRINT '>> Truncating and Loading: bronze.crm_prd_info';
        TRUNCATE TABLE bronze.crm_prd_info;
        BULK INSERT bronze.crm_prd_info
        FROM 'C:\Users\shahd\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        PRINT '>> Truncating and Loading: bronze.crm_sales_details';
        TRUNCATE TABLE bronze.crm_sales_details;
        BULK INSERT bronze.crm_sales_details
        FROM 'C:\Users\shahd\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        -- ============================================================================
        -- ERP Data Ingestion
        -- ============================================================================

        PRINT '>> Truncating and Loading: bronze.erp_loc_a101';
        TRUNCATE TABLE bronze.erp_loc_a101;
        BULK INSERT bronze.erp_loc_a101
        FROM 'C:\Users\shahd\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        PRINT '>> Truncating and Loading: bronze.erp_cust_az12';
        TRUNCATE TABLE bronze.erp_cust_az12;
        BULK INSERT bronze.erp_cust_az12
        FROM 'C:\Users\shahd\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        PRINT '>> Truncating and Loading: bronze.erp_px_cat_g1v2';
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;
        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'C:\Users\shahd\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '====================================================================';
        PRINT 'BRONZE LAYER DATA INGESTION COMPLETED SUCCESSFULLY';
        PRINT 'Total Load Time: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '====================================================================';

    END TRY
    BEGIN CATCH
        PRINT '====================================================================';
        PRINT 'ERROR OCCURRED DURING INGESTION';
        PRINT '====================================================================';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number:  ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error Line:    ' + CAST(ERROR_LINE() AS NVARCHAR);
        PRINT 'Error State:   ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '====================================================================';
    END CATCH;
END;
GO
