--- Quality Check ---
-- silver.crm_cust_info table --
-- Check duplicate customer_id -- 
SELECT cst_id, COUNT(*) FROM 

(SELECT
	ci.cst_id ,
	ci.cst_key,
	ci.cst_firstname,
	ci.cst_lastname,
	la.cntry,
	ca.bdate,
	ci.cst_create_date
FROM silver.crm_cust_info AS ci
LEFT JOIN silver.erp_cust_az12 AS ca
ON		  ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 AS la
ON		  ci.cst_key = la.cid
) t GROUP BY cst_id 
HAVING COUNT(*) > 1

-- silver.crm_prd_info table --

-- Foreign key Integrity (Dimensions) 
SELECT * FROM gold.fact_sales f 
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
WHERE p.product_key IS NULL

