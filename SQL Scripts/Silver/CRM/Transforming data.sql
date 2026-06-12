SELECT 
*
FROM (
SELECT *,
ROW_NUMBER () OVER (PARTITION BY cst_id ORDER BY cst_create_date) AS RECENT_ONCE
FROM bronze.crm_cust_info) P
WHERE RECENT_ONCE = 1

---------------------------------
SELECT cst_id,
cst_key,
TRIM(cst_firstname) AS cst_firstname,
TRIM(cst_lastname) AS cst_lastname,
cst_marital_status,
cst_gndr,
cst_create_date
FROM bronze.crm_cust_info

-----------------------------------

SELECT cst_id,
cst_key,
TRIM(cst_firstname) AS cst_firstname,
TRIM(cst_lastname) AS cst_lastname,
CASE WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
	 WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
	 ELSE 'n/a'
END cst_marital_status,
CASE WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
	 WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
	 ELSE 'N/A'
END cst_gndr,
cst_create_date
FROM bronze.crm_cust_info

--------------------------------------------------------
-- product table
select * from bronze.crm_prd_info 
SELECT 
prd_id,
prd_key,
REPLACE(SUBSTRING(PRD_KEY, 1, 5), '-', '_') AS cat_id,
SUBSTRING (prd_key, 7,LEN(prd_key)) AS prd_key,
prd_nm,
ISNULL (prd_cost, 0) AS prd_cost,

CASE UPPER(TRIM(prd_line))
	 WHEN'R' THEN 'Road'
	 WHEN'M' THEN 'Mountain'
	 WHEN'S' THEN 'Other sales'
	 WHEN'T' THEN 'Touring'
	 ELSE 'N/A'
END AS prd_line,
CAST(prd_start_dt AS DATE) AS prd_start_dt,
CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) -1 AS DATE) AS prd_end_dt_test
FROM bronze.crm_prd_info 

SELECT * FROM [silver].[crm_prd_info]

-------------------------------------------
-- sales table

SELECT * FROM [bronze].[crm_sales_details]

SELECT 
sls_ord_num,
sls_prd_key,
sls_cust_id,
	CASE WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
	ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE) --> WE CAN'T CHANGE THE INT TO DATE
END AS sls_order_dt,									 -- INT --> VARCHAR --> DATE 

CASE WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
	ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE) --> WE CAN'T CHANGE THE INT TO DATE
END AS sls_ship_dt,									 -- INT --> VARCHAR --> DATE 

CASE WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
	ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE) --> WE CAN'T CHANGE THE INT TO DATE
END AS sls_due_dt,									-- INT --> VARCHAR --> DATE 

CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
	 THEN sls_quantity * ABS(sls_price)
	 ELSE sls_sales
END AS sls_sales,
sls_sales AS old_sales,
sls_quantity,
CASE WHEN sls_price IS NULL OR sls_price <= 0
	 THEN sls_sales/NULLIF(sls_quantity, 0) 
	 ELSE sls_price
END AS sls_price,
sls_price AS ols_price
FROM bronze.crm_sales_details 