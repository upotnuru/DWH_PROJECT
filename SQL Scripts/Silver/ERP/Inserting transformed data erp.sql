--INSERTIG DATA INTO ERP TABLES
PRINT '>> Truncate Table : silver.erp_cust_az12'
TRUNCATE TABLE silver.erp_cust_az12;
PRINT '>> Inserting Table : silver.erp_cust_az12'
INSERT INTO silver.erp_cust_az12 (cid, bdate, gen)

select 
CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
	 ELSE cid
END AS cid,
CASE WHEN bdate > GETDATE() THEN NULL
	 ELSE bdate
END AS bdate,
CASE WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
	 WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
	 ELSE 'n/a'
END AS gen 
FROM [bronze].[erp_cust_az12]
 --------------------------------------------------------

 PRINT '>> Truncate Table : silver.erp_loc_a101'
TRUNCATE TABLE silver.erp_loc_a101;
PRINT '>> Inserting Table : silver.erp_loc_a101'
 INSERT INTO silver.erp_loc_a101 
 (cid, cntry)
 SELECT 
 REPLACE(cid, '-', '') cid,
 CASE WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'  --> TRANSFORM THE NULL'S, EMPTY CELLS WITH n/a
	  WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'--> CHECK THE COUNTRY NAMES, iF YOU FIND ANYTHING, CHANGE IT
	  WHEN TRIM(cntry) = 'DE' THEN 'Germany'
	  ELSE TRIM(cntry)
END AS cntry
FROM [bronze].[erp_loc_a101] 

---------------------------------------------------------

 PRINT '>> Truncate Table : silver.erp_px_cat_glv2'
TRUNCATE TABLE  silver.erp_px_cat_glv2;
PRINT '>> Inserting Table : silver.erp_px_cat_glv2'

INSERT INTO silver.erp_px_cat_glv2 (id, cat, subcat, maintenance)

SELECT id,
cat,
subcat,
maintenance FROM bronze.erp_px_cat_glv2
----------------------------------------------------------