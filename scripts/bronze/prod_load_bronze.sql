/*
===============================================================================
Stored Procedure: bronze.load_bronze
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the PostgreSQL COPY command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    CALL bronze.load_bronze();
===============================================================================
*/
CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql
AS $$
DECLARE 
	v_cust_rows INT;
	v_prd_rows INT;
	v_sales_rows INT;
	v_erp_cust_rows INT;
	v_erp_loc_rows INT;
	v_erp_px_rows INT;
	start_time TIMESTAMP;
	end_time TIMESTAMP;
	batch_start_time TIMESTAMP;
	batch_end_time TIMESTAMP;
BEGIN
    batch_start_time := NOW();
    RAISE NOTICE '==========================================';
	RAISE NOTICE 'Loading Bronze Layer';
	RAISE NOTICE '==========================================';

	RAISE NOTICE '------------------------------------------';
	RAISE NOTICE 'Loading CRM Tables';
	RAISE NOTICE '------------------------------------------';

    start_time := NOW();
	-- CRM Customer Info
	RAISE NOTICE '>> Truncating Table: bronze.crm_cust_info';
	TRUNCATE TABLE bronze.crm_cust_info;

	RAISE NOTICE '>> Inserting Data Into: bronze.crm_cust_info';
	COPY bronze.crm_cust_info
	FROM '/Users/srushtiab/Downloads/sql-data-warehouse-project 3/datasets/source_crm/cust_info.csv'
	DELIMITER ','
	CSV HEADER;

	SELECT COUNT(*) INTO v_cust_rows FROM bronze.crm_cust_info;
	RAISE NOTICE '(% rows affected)', v_cust_rows;
    end_time := NOW();
	RAISE NOTICE '>> Load Duration: % seconds', EXTRACT(EPOCH FROM (end_time - start_time));
	RAISE NOTICE '------------------------------';

	start_time := NOW();
	-- CRM Product Info
	RAISE NOTICE '>> Truncating Table: bronze.crm_prd_info';
	TRUNCATE TABLE bronze.crm_prd_info;

	RAISE NOTICE '>> Inserting Data Into: bronze.crm_prd_info';
	COPY bronze.crm_prd_info
	FROM '/Users/srushtiab/Downloads/sql-data-warehouse-project 3/datasets/source_crm/prd_info.csv'
	DELIMITER ','
	CSV HEADER;

	SELECT COUNT(*) INTO v_prd_rows FROM bronze.crm_prd_info;
	RAISE NOTICE '(% rows affected)', v_prd_rows;
    end_time := NOW();
	RAISE NOTICE '>> Load Duration: % seconds', EXTRACT(EPOCH FROM (end_time - start_time));
	RAISE NOTICE '------------------------------';

    start_time := NOW();
	-- CRM Sales Details
	RAISE NOTICE '>> Truncating Table: bronze.crm_sales_details';
	TRUNCATE TABLE bronze.crm_sales_details;

	RAISE NOTICE '>> Inserting Data Into: bronze.crm_sales_details';
	COPY bronze.crm_sales_details
	FROM '/Users/srushtiab/Downloads/sql-data-warehouse-project 3/datasets/source_crm/sales_details.csv'
	DELIMITER ','
	CSV HEADER;

	SELECT COUNT(*) INTO v_sales_rows FROM bronze.crm_sales_details;
	RAISE NOTICE '(% rows affected)', v_sales_rows;
    end_time := NOW();
	RAISE NOTICE '>> Load Duration: % seconds', EXTRACT(EPOCH FROM (end_time - start_time));
	RAISE NOTICE '------------------------------';

	RAISE NOTICE '------------------------------------------';
	RAISE NOTICE 'Loading ERP Tables';
	RAISE NOTICE '------------------------------------------';

	start_time := NOW();
	-- ERP Customer Table
	RAISE NOTICE '>> Truncating Table: bronze.erp_cust_az12';
	TRUNCATE TABLE bronze.erp_cust_az12;

	RAISE NOTICE '>> Inserting Data Into: bronze.erp_cust_az12';
	COPY bronze.erp_cust_az12
	FROM '/Users/srushtiab/Downloads/sql-data-warehouse-project 3/datasets/source_erp/cust_az12.csv'
	DELIMITER ','
	CSV HEADER;

	SELECT COUNT(*) INTO v_erp_cust_rows FROM bronze.erp_cust_az12;
	RAISE NOTICE '(% rows affected)', v_erp_cust_rows;
    end_time := NOW();
	RAISE NOTICE '>> Load Duration: % seconds', EXTRACT(EPOCH FROM (end_time - start_time));
	RAISE NOTICE '------------------------------';

    start_time := NOW();
	-- ERP Location Table
	RAISE NOTICE '>> Truncating Table: bronze.erp_loc_a101';
	TRUNCATE TABLE bronze.erp_loc_a101;

	RAISE NOTICE '>> Inserting Data Into: bronze.erp_loc_a101';
	COPY bronze.erp_loc_a101
	FROM '/Users/srushtiab/Downloads/sql-data-warehouse-project 3/datasets/source_erp/loc_a101.csv'
	DELIMITER ','
	CSV HEADER;

	SELECT COUNT(*) INTO v_erp_loc_rows FROM bronze.erp_loc_a101;
	RAISE NOTICE '(% rows affected)', v_erp_loc_rows;
    end_time := NOW();
	RAISE NOTICE '>> Load Duration: % seconds', EXTRACT(EPOCH FROM (end_time - start_time));
	RAISE NOTICE '------------------------------';

    start_time := NOW();
	-- ERP Product Category Table
	RAISE NOTICE '>> Truncating Table: bronze.erp_px_cat_g1v2';
	TRUNCATE TABLE bronze.erp_px_cat_g1v2;

	RAISE NOTICE '>> Inserting Data Into: bronze.erp_px_cat_g1v2';
	COPY bronze.erp_px_cat_g1v2
	FROM '/Users/srushtiab/Downloads/sql-data-warehouse-project 3/datasets/source_erp/px_cat_g1v2.csv'
	DELIMITER ','
	CSV HEADER;

	SELECT COUNT(*) INTO v_erp_px_rows FROM bronze.erp_px_cat_g1v2;
	RAISE NOTICE '(% rows affected)', v_erp_px_rows;
    end_time := NOW();
	RAISE NOTICE '>> Load Duration: % seconds', EXTRACT(EPOCH FROM (end_time - start_time));
	RAISE NOTICE '------------------------------';

	batch_end_time := NOW();
	RAISE NOTICE '------------------------------------------';
	RAISE NOTICE '✅ Bronze layer loading completed successfully!';
	RAISE NOTICE '>> Total Load Duration: % seconds', EXTRACT(EPOCH FROM (batch_end_time - batch_start_time));
	RAISE NOTICE '------------------------------';


EXCEPTION
	WHEN OTHERS THEN
		RAISE NOTICE '============================================';
		RAISE NOTICE '❌ ERROR OCCURRED DURING LOADING BRONZE LAYER';
		RAISE NOTICE 'Error Message: %', SQLERRM;
		RAISE NOTICE 'Error State: %', SQLSTATE;
		RAISE NOTICE '============================================';
END;
$$;
