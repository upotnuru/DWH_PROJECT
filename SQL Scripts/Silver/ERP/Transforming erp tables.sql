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

from [bronze].[erp_cust_az12]
------------------------------------------

SELECT 
cid,
cntry
FROM [bronze].[erp_loc_a101]
										-------> '-' IS DIVIDIG THE CID
SELECT * FROM [silver].[crm_cust_info]

SELECT REPLACE(cid, '-', '') cid,  --------> iT'LL REMOVE THE '-' IN MIDDLE OF cid
cntry
FROM [bronze].[erp_loc_a101]

SELECT 
DISTINCT cntry AS OLD_cntry,
CASE WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'  --> TRANSFORM THE NULL'S, EMPTY CELLS WITH n/a
	 WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'--> CHECK THE COUNTRY NAMES, iF YOU FIND ANYTHING, CHANGE IT
	 WHEN TRIM(cntry) = 'DE' THEN 'Germany'
	 ELSE TRIM(cntry)
END AS cntry
FROM [bronze].[erp_loc_a101] 
-------------------------