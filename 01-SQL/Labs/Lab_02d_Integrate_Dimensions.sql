# ===================================================================================
# How to Integrate a Dimension table. In other words, how to look-up Foreign Key
# values FROM a dimension table and add them to new Fact table columns.
#
# First, go to Edit -> Preferences -> SQL Editor and disable 'Safe Edits'.
# Close SQL Workbench and Reconnect to the Server Instance.
# ===================================================================================

USE northwind_dw;

# ==============================================================
# Step 1: Add New Column(s)
# ==============================================================
ALTER TABLE northwind_dw.fact_orders
# ADD NEW COLUMNS FOR CUSTOMER, EMPLOYEE, PRODUCT & SHIPPER KEYS
ADD COLUMN order_date_key int NOT NULL AFTER order_date,
ADD COLUMN shipped_date_key int NOT NULL AFTER shipped_date,
ADD COLUMN paid_date_key int NOT NULL AFTER paid_date,
ADD COLUMN customer_key int NOT NULL AFTER customer_id,
ADD COLUMN employee_key int NOT NULL AFTER employee_id,
ADD COLUMN product_key int NOT NULL AFTER product_id,
ADD COLUMN shipper_key int NOT NULL AFTER shipper_id;

# ==============================================================
# Step 2: Update New Column(s) with value from Dimension table
#         WHERE Business Keys in both tables match.
# ==============================================================

# --------------------------------------------------------------
# Use the following examples to guide you in integrating the 
# Customer, Employee, Product and Shipper dimension tables.
# --------------------------------------------------------------

UPDATE northwind_dw.fact_orders AS fo
JOIN northwind_dw.dim_date AS dd
ON DATE(fo.order_date) = dd.full_date
SET fo.order_date_key = dd.date_key;

UPDATE northwind_dw.fact_orders AS fo
JOIN northwind_dw.dim_date AS dd
ON DATE(fo.shipped_date) = dd.full_date
SET fo.shipped_date_key = dd.date_key;

UPDATE northwind_dw.fact_orders AS fo
JOIN northwind_dw.dim_date AS dd
ON DATE(fo.paid_date) = dd.full_date
SET fo.paid_date_key = dd.date_key;

UPDATE northwind_dw.fact_orders AS fo
JOIN northwind_dw.dim_customers AS dc
ON fo.customer_id = dc.customer_id
SET fo.customer_key = dc.customer_key;

UPDATE northwind_dw.fact_orders AS fo
JOIN northwind_dw.dim_employees AS de
ON fo.employee_id = de.employee_id
SET fo.employee_key = de.employee_key;

UPDATE northwind_dw.fact_orders AS fo
JOIN northwind_dw.dim_products AS dp
ON fo.product_id = dp.product_id
SET fo.product_key = dp.product_key;

UPDATE northwind_dw.fact_orders AS fo
JOIN northwind_dw.dim_shippers AS ds
ON fo.shipper_id = ds.shipper_id
SET fo.shipper_key = ds.shipper_key;

# ==============================================================
# Step 3: Validate that newly updated columns contain valid data
# ==============================================================
SELECT customer_id
	, customer_key
    , employee_id
    , employee_key
    , product_id
    , product_key
    , shipper_id
    , shipper_key
    , order_date
    , order_date_key
    , paid_date
    , paid_date_key
    , shipped_date
    , shipped_date_key
FROM northwind_dw.fact_orders
LIMIT 10;

# =============================================================
# Step 4: If values are correct then drop old column(s)
# =============================================================
ALTER TABLE northwind_dw.fact_orders
# DROP THE CUSTOMER, EMPLOYEE, PRODUCT and SHIPPER ID COLUMNS
DROP COLUMN order_date,
DROP COLUMN shipped_date,
DROP COLUMN paid_date,
DROP COLUMN customer_id,
DROP COLUMN employee_id,
DROP COLUMN product_id,
DROP COLUMN shipper_id;

# =============================================================
# Step 5: Validate Finished Fact Table.
# =============================================================
SELECT * FROM northwind_dw.fact_orders
LIMIT 10;

