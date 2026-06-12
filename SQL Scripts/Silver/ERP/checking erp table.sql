-------cHECKING FOR IS THERE ANY DIFFERENT KEY FROM crm_cust_info TABLE----------

select 
cid,
CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
	 ELSE cid
END AS New_cid,
bdate,
gen
from [bronze].[erp_cust_az12]
WHERE CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
	 ELSE cid
END NOT IN (SELECT cst_key FROM [silver].[crm_cust_info])

--------IDENTIFY OUT OF RANGE DATES--------------

SELECT bdate FROM [bronze].[erp_cust_az12]
WHERE bdate < '1930-01-01' OR bdate > GETDATE()

------- CHECKING THE GEN COLUMN IN TABLE---------

SELECT DISTINCT gen FROM [bronze].[erp_cust_az12]

--CHECKING 

SELECT DISTINCT
CASE WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
	 WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
	 ELSE 'n/a'
END AS gen
FROM [bronze].[erp_cust_az12]

------------------------------------
SELECT cid,
cntry
FROM [bronze].[erp_loc_a101]

SELECT 
DISTINCT cntry FROM [bronze].[erp_loc_a101]
--REPLACED ALL NULL's AND EMPTY CELLS WITH n/a
--ALTERED ALL THE cntry NAMES
--REMOVED UNWANTED SPACES
SELECT 
DISTINCT cntry FROM [silver].[erp_loc_a101]
ORDER BY cntry

SELECT * FROM [silver].[erp_loc_a101]


---------------------------------------------

SELECT id FROM [bronze].[erp_px_cat_glv2]

SELECT * FROM [silver].[crm_prd_info]  --> THESE BOTH TABLES HAVE SAME KEY (ID, CAT_ID)

----CHECKING FOR THE UNWANTED SPACES

SELECT * FROM [bronze].[erp_px_cat_glv2]
WHERE cat != TRIM(cat) OR  subcat != TRIM(subcat) OR maintenance != TRIM(maintenance)

------ FINDING FOR ANY DUPLICATES OR ERRORS OR NULL's

SELECT DISTINCT 
cat
FROM [bronze].[erp_px_cat_glv2]

SELECT DISTINCT 
subcat
FROM [bronze].[erp_px_cat_glv2]

SELECT DISTINCT 
maintenance
FROM [bronze].[erp_px_cat_glv2]