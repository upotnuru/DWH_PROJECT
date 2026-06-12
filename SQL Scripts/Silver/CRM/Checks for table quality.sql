-- Check for nulls or duplicate i primary key
-- Expectation : NO result

SELECT 
cst_id,
count(*)
FROM bronze.crm_cust_info 
GROUP BY cst_id HAVING COUNT(*) > 1 OR cst_id IS NULL

select * from 
-- Checking for unwanted spaces
-- expectation : No results

SELECT prd_nm
FROM bronze.crm_prd_info 
WHERE prd_nm != TRIM(prd_nm)


--------------------------

-- data standardization & consistency

SELECT DISTINCT cst_gndr FROM silver.crm_cust_info

SELECT DISTINCT cst_marital_status FROM silver.crm_cust_info

--------------------------------------
select * from silver.crm_cust_info
select * from bronze.crm_prd_info 
--------------------------------------
-- Checking in the prd table 

-- Checking in the prd_id column (checking for duplicates & nulls).

SELECT 
prd_id,
count(*)
FROM bronze.crm_prd_info 
GROUP BY prd_id HAVING COUNT(*) > 1 OR prd_id IS NULL

-- Checking for the negitive & NULL values in cost column.

select prd_cost from bronze.crm_prd_info
where prd_cost = 0 or prd_cost is null

-- Checking for the unique values in prd_line column 

SELECT DISTINCT prd_line FROM bronze.crm_prd_info

-----------------------------------------------
-- FOR THE silver.crm_prd_info table

SELECT 
prd_id,
count(*)
FROM silver.crm_prd_info 
GROUP BY prd_id HAVING COUNT(*) > 1 OR prd_id IS NULL
-------------------------------------
SELECT prd_nm
FROM silver.crm_prd_info 
WHERE prd_nm != TRIM(prd_nm)
-------------------------------------
select prd_cost from silver.crm_prd_info
where prd_cost < 0 or prd_cost is null
-------------------------------------
SELECT DISTINCT prd_line FROM silver.crm_prd_info

-------------------------------------

 --> sls_order_num clear, is ther with out ant unwanted spaces

SELECT 
sls_ord_num,
sls_prd_key,
sls_cust_id,
sls_order_dt,
sls_ship_dt,
sls_due_dt,
sls_sales,
sls_quantity,
sls_price
FROM bronze.crm_sales_details
WHERE sls_ord_num != TRIM(sls_ord_num)
-----------------------------------------

/* --> It is checking whether every Product Key (sls_prd_key)
in the sales table exists in the product master table. */

SELECT 
sls_ord_num,
sls_prd_key,
sls_cust_id,
sls_order_dt,
sls_ship_dt,
sls_due_dt,
sls_sales,
sls_quantity,
sls_price
FROM bronze.crm_sales_details
WHERE sls_prd_key NOT IN (SELECT prd_key from silver.crm_prd_info) 

-------------------------------------------

/* -->identify sales records that reference 
customer IDs that do not exist in the customer master table."
*/

SELECT 
sls_ord_num,
sls_prd_key,
sls_cust_id,
sls_order_dt,
sls_ship_dt,
sls_due_dt,
sls_sales,
sls_quantity,
sls_price
FROM bronze.crm_sales_details
WHERE sls_cust_id NOT IN (SELECT cst_id from silver.crm_cust_info) 

---------------------------------------------

--> Date validation in bronze.crm_sales_details

SELECT 
NULLIF (sls_order_dt, 0) AS  sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0--> CHECKING FOR NEGATIVE VALUES/ZEROS 
						 -- ZERO's ARE THERE, WE WANT REPLACE WITH NULL.
 OR LEN(sls_order_dt) != 8 
 OR sls_order_dt < 19990101
 OR sls_order_dt > 20500101

 -- FOR sls_ship_dt COLUMN
 SELECT 
NULLIF (sls_ship_dt, 0) AS  sls_ship_dt
FROM bronze.crm_sales_details
WHERE sls_ship_dt <= 0--> CHECKING FOR NEGATIVE VALUES/ZEROS 
						 -- ZERO's ARE THERE, WE WANT REPLACE WITH NULL.
 OR LEN(sls_ship_dt) != 8 
 OR sls_ship_dt < 19990101
 OR sls_ship_dt > 20500101

 -- FOR sls_due_dt COLUMN

  SELECT 
NULLIF (sls_due_dt, 0) AS  sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0--> CHECKING FOR NEGATIVE VALUES/ZEROS 
						 -- ZERO's ARE THERE, WE WANT REPLACE WITH NULL.
 OR LEN(sls_due_dt) != 8 
 OR sls_due_dt < 19990101
 OR sls_due_dt > 20500101

 -- CHECK FOR INVALID ORDER OD DATES COLUMN

 SELECT * FROM bronze.crm_sales_details
 WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt

 SELECT * FROM bronze.crm_sales_details
 WHERE sls_ship_dt > sls_due_dt


 

 ------------------------------------
 --Checking for the sls_sales, sls_quentity, sls_price
 -- First check --> sales = quentity*price
 -- Second check --> sls_sales is not null, and > 0

 SELECT * FROM  bronze.crm_sales_details
 WHERE sls_sales IS NULL OR sls_sales <=0

 SELECT * FROM bronze.crm_sales_details
 WHERE sls_sales != sls_quantity * sls_price AND sls_price >0

 ---------------------------
 SELECT * FROM 
 (
 SELECT 
 sls_quantity,
 sls_price,
 CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
	 THEN sls_quantity * ABS(sls_price)
	 ELSE sls_sales
END AS sls_sales FROM bronze.crm_sales_details) AS P
 WHERE sls_sales != sls_quantity * sls_price AND sls_price >0

 -----------------------------------------

 SELECT sls_quantity FROM bronze.crm_sales_details
 WHERE sls_quantity <= 0 OR sls_quantity IS NULL

 --> sls_quantity CHECKING FOR WETHER THERE IS ANY NULLS OR NAGITVE VALUS
 -----------------------------------------

 SELECT sls_price
 FROM bronze.crm_sales_details
 WHERE sls_price
 <= 0 OR sls_price
 IS NULL

 -----------------------------------------
 SELECT DISTINCT 

sls_sales AS old_sls_sales,
sls_quantity,
sls_price AS old_sls_price,

CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
	 THEN sls_quantity * ABS(sls_price)
	 ELSE sls_sales
END AS sls_sales,

CASE WHEN sls_price IS NULL OR sls_price <= 0
	 THEN sls_sales/NULLIF(sls_quantity, 0) 
	 ELSE sls_price
END AS sls_price
FROM bronze.crm_sales_details 

WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price

---------------------------------------
-- CHECKING FOR THE SILVER TABLE

SELECT * FROM  silver.crm_sales_details
 WHERE sls_sales IS NULL OR sls_sales <=0

 SELECT * FROM silver.crm_sales_details
 WHERE sls_sales != sls_quantity * sls_price AND sls_price >0

 ---------------------------
 SELECT * FROM 
 (
 SELECT 
 sls_quantity,
 sls_price,
 CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
	 THEN sls_quantity * ABS(sls_price)
	 ELSE sls_sales
END AS sls_sales FROM silver.crm_sales_details) AS P
 WHERE sls_sales != sls_quantity * sls_price AND sls_price >0

 -----------------------------------------

 SELECT sls_quantity FROM silver.crm_sales_details
 WHERE sls_quantity <= 0 OR sls_quantity IS NULL

 --> sls_quantity CHECKING FOR WETHER THERE IS ANY NULLS OR NAGITVE VALUS
 -----------------------------------------

 SELECT sls_price
 FROM silver.crm_sales_details
 WHERE sls_price
 <= 0 OR sls_price
 IS NULL

 -----------------------------------------
 SELECT * 
 FROM 
 silver.crm_sales_details
 WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt

 SELECT * FROM silver.crm_sales_details
 SELECT * FROM silver.crm_cust_info
 SELECT * FROM silver.crm_prd_info