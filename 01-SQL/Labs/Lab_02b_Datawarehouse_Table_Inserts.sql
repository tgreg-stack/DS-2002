-- --------------------------------------------------------------------------------------------------------------
-- TODO: Extract the appropriate data from the northwind database, and INSERT it into the Northwind_DW database.
-- --------------------------------------------------------------------------------------------------------------

-- ----------------------------------------------
-- Populate dim_customers
-- ----------------------------------------------
TRUNCATE TABLE northwind_dw.dim_customers;

INSERT INTO `northwind_dw`.`dim_customers`
(`customer_id`,
`company`,
`last_name`,
`first_name`,
`job_title`,
`business_phone`,
`fax_number`,
`address`,
`city`,
`state_province`,
`zip_postal_code`,
`country_region`)
SELECT `id`,
	`company`,
	`last_name`,
	`first_name`,
	`job_title`,
	`business_phone`,
	`fax_number`,
	`address`,
	`city`,
	`state_province`,
	`zip_postal_code`,
	`country_region`
FROM northwind.customers;

-- ----------------------------------------------
-- Validate that the Data was Inserted ----------
-- ----------------------------------------------
SELECT * FROM northwind_dw.dim_customers;


-- ----------------------------------------------
-- Populate dim_employees
-- ----------------------------------------------
TRUNCATE TABLE `northwind_dw`.`dim_employees`;

INSERT INTO `northwind_dw`.`dim_employees`
(`employee_id`,
`company`,
`last_name`,
`first_name`,
`email_address`,
`job_title`,
`business_phone`,
`home_phone`,
`fax_number`,
`address`,
`city`,
`state_province`,
`zip_postal_code`,
`country_region`,
`web_page`)
SELECT `id`,
    `company`,
    `last_name`,
    `first_name`,
    `email_address`,
    `job_title`,
    `business_phone`,
    `home_phone`,
    `fax_number`,
    `address`,
    `city`,
    `state_province`,
    `zip_postal_code`,
    `country_region`,
    `web_page`
FROM `northwind`.`employees`;

-- ----------------------------------------------
-- Validate that the Data was Inserted ----------
-- ----------------------------------------------
SELECT * FROM northwind_dw.dim_employees;


-- ----------------------------------------------
-- Populate dim_products
-- ----------------------------------------------
TRUNCATE TABLE `northwind_dw`.`dim_products`;

INSERT INTO `northwind_dw`.`dim_products`
(`product_id`,
`product_code`,
`product_name`,
`standard_cost`,
`list_price`,
`reorder_level`,
`target_level`,
`quantity_per_unit`,
`discontinued`,
`minimum_reorder_quantity`,
`category`)
# TODO: Write a SELECT Statement to Populate the table;
SELECT `products`.`id`,
    `products`.`product_code`,
    `products`.`product_name`,
    `products`.`standard_cost`,
    `products`.`list_price`,
    `products`.`reorder_level`,
    `products`.`target_level`,
    `products`.`quantity_per_unit`,
    `products`.`discontinued`,
    `products`.`minimum_reorder_quantity`,
    `products`.`category`
FROM `northwind`.`products`;

-- ----------------------------------------------
-- Validate that the Data was Inserted ----------
-- ----------------------------------------------
SELECT * FROM northwind_dw.dim_products;


-- ----------------------------------------------
-- Populate dim_shippers
-- ----------------------------------------------
TRUNCATE TABLE `northwind_dw`.`dim_shippers`;

INSERT INTO `northwind_dw`.`dim_shippers`
(`shipper_id`,
`company`,
`address`,
`city`,
`state_province`,
`zip_postal_code`,
`country_region`)
# TODO: Write a SELECT Statement to Populate the table;
SELECT `shippers`.`id`,
    `shippers`.`company`,
    `shippers`.`address`,
    `shippers`.`city`,
    `shippers`.`state_province`,
    `shippers`.`zip_postal_code`,
    `shippers`.`country_region`
FROM `northwind`.`shippers`;

-- ----------------------------------------------
-- Validate that the Data was Inserted ----------
-- ----------------------------------------------
SELECT * FROM northwind_dw.dim_shippers;


-- ----------------------------------------------
-- Populate fact_orders
-- ----------------------------------------------
TRUNCATE TABLE `northwind_dw`.`fact_orders`;

INSERT INTO `northwind_dw`.`fact_orders`
(`order_id`,
`order_detail_id`,
`customer_id`,
`employee_id`,
`product_id`,
`shipper_id`,
`order_date`,
`paid_date`,
`shipped_date`,
`payment_type`,
`quantity`,
`unit_price`,
`discount`,
`shipping_fee`,
`taxes`,
`tax_rate`,
`order_status`,
`order_details_status`)


/* 
--------------------------------------------------------------------------------------------------
TODO: Write a SELECT Statement that:
- JOINS the northwind.orders table with the northwind.orders_status table
- JOINS the northwind.orders with the northwind.order_details table.
--  (TIP: Remember that there is a one-to-many relationship between orders and order_details).
- JOINS the northwind.order_details table with the northwind.order_details_status table.
--------------------------------------------------------------------------------------------------
- The column list I've included in the INSERT INTO clause above should be your guide to which 
- columns you're required to extract from each of the four tables. Pay close attention!
--------------------------------------------------------------------------------------------------
*/

SELECT o.`id` as `order_id`,
	od.`id` as `order_detail_id`,
    o.`customer_id`,
    o.`employee_id`,
    od.`product_id`,
    o.`shipper_id`,
    o.`order_date`,
    o.`paid_date`,
    o.`shipped_date`,
    o.`payment_type`,
    od.`quantity`,
    od.`unit_price`,
    od.`discount`,
    o.`shipping_fee`,
    o.`taxes`,
    o.`tax_rate`,
    os.status_name as `order_status`,
    ods.status_name as `order_details_status`
FROM northwind.orders as o
INNER JOIN northwind.orders_status as os
ON o.status_id = os.id
LEFT OUTER JOIN northwind.order_details as od
ON o.id = od.order_id
INNER JOIN northwind.order_details_status as ods
ON od.status_id = ods.id;

-- ----------------------------------------------
-- Validate that the Data was Inserted ----------
-- ----------------------------------------------
SELECT * FROM northwind_dw.fact_orders;



-- ----------------------------------------------
-- ----------------------------------------------
-- Next, create the date dimension and then -----
-- integrate the date, customer, employee -------
-- product and shipper dimension tables ---------
-- ----------------------------------------------
-- ----------------------------------------------


-- --------------------------------------------------------------------------------------------------
-- LAB QUESTION: Author a SQL query that returns the total (sum) of the quantity and unit price
-- for each customer (last name), sorted by the total unit price in descending order.
-- --------------------------------------------------------------------------------------------------