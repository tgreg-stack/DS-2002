DROP database `northwind_dw`;
CREATE DATABASE `northwind_dw` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE northwind_dw;

DROP TABLE IF EXISTS `dim_customers`;
CREATE TABLE `dim_customers` (
  `customer_key` int NOT NULL AUTO_INCREMENT,
  `customer_id` int NOT NULL,
  `company` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  `job_title` varchar(50) DEFAULT NULL,
  `business_phone` varchar(25) DEFAULT NULL,
  `fax_number` varchar(25) DEFAULT NULL,
  `address` longtext,
  `city` varchar(50) DEFAULT NULL,
  `state_province` varchar(50) DEFAULT NULL,
  `zip_postal_code` varchar(15) DEFAULT NULL,
  `country_region` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`customer_key`),
  KEY `customer_id` (`customer_id`),
  KEY `city` (`city`),
  KEY `company` (`company`),
  KEY `first_name` (`first_name`),
  KEY `last_name` (`last_name`),
  KEY `zip_postal_code` (`zip_postal_code`),
  KEY `state_province` (`state_province`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `dim_employees`;
CREATE TABLE `dim_employees` (
  `employee_key` int NOT NULL AUTO_INCREMENT,
  `employee_id` int NOT NULL,
  `company` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  `email_address` varchar(50) DEFAULT NULL,
  `job_title` varchar(50) DEFAULT NULL,
  `business_phone` varchar(25) DEFAULT NULL,
  `home_phone` varchar(25) DEFAULT NULL,
  `fax_number` varchar(25) DEFAULT NULL,
  `address` longtext,
  `city` varchar(50) DEFAULT NULL,
  `state_province` varchar(50) DEFAULT NULL,
  `zip_postal_code` varchar(15) DEFAULT NULL,
  `country_region` varchar(50) DEFAULT NULL,
  `web_page` longtext,
  PRIMARY KEY (`employee_key`),
  KEY `employee_id` (`employee_id`),
  KEY `city` (`city`),
  KEY `company` (`company`),
  KEY `first_name` (`first_name`),
  KEY `last_name` (`last_name`),
  KEY `zip_postal_code` (`zip_postal_code`),
  KEY `state_province` (`state_province`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `dim_products`;
CREATE TABLE `dim_products` (
  `product_key` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `product_code` varchar(25) DEFAULT NULL,
  `product_name` varchar(50) DEFAULT NULL,
  `standard_cost` decimal(19,4) DEFAULT '0.0000',
  `list_price` decimal(19,4) NOT NULL DEFAULT '0.0000',
  `reorder_level` int DEFAULT NULL,
  `target_level` int DEFAULT NULL,
  `quantity_per_unit` varchar(50) DEFAULT NULL,
  `discontinued` tinyint(1) NOT NULL DEFAULT '0',
  `minimum_reorder_quantity` int DEFAULT NULL,
  `category` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`product_key`),
  KEY `product_id` (`product_id`),
  KEY `product_code` (`product_code`),
  KEY `discontinued` (`discontinued`),
  KEY `category` (`category`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4;

# ----------------------------------------------------------
# TODO: CREATE the `dim_shippers` dimension table ----------
# ----------------------------------------------------------
DROP TABLE IF EXISTS `dim_shippers`;
CREATE TABLE `dim_shippers` (
  `shipper_key` int NOT NULL AUTO_INCREMENT,
  `shipper_id` int 	NOT NULL,
  `company` varchar(50) DEFAULT NULL,
  `address` longtext,
  `city` varchar(50) DEFAULT NULL,
  `state_province` varchar(50) DEFAULT NULL,
  `zip_postal_code` varchar(15) DEFAULT NULL,
  `country_region` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`shipper_key`),
  KEY `shipper_id` (`shipper_id`),
  KEY `city` (`city`),
  KEY `company` (`company`),
  KEY `zip_postal_code` (`zip_postal_code`),
  KEY `state_province` (`state_province`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;


# ----------------------------------------------------------------------
# TODO: JOIN the orders, order_details, order_details_status and 
#       orders_status tables to create a new Fact Table in Northwind_DW.
# To keep things simple, don't include purchase order or inventory info
# ----------------------------------------------------------------------
DROP TABLE IF EXISTS `fact_orders`;
CREATE TABLE `fact_orders` (
  `fact_order_key` int NOT NULL AUTO_INCREMENT,
  `order_id` int DEFAULT NULL,
  `order_detail_id` int DEFAULT NULL,
  `customer_id` int DEFAULT NULL,
  `employee_id` int DEFAULT NULL,
  `product_id` int DEFAULT NULL,
  `shipper_id` int DEFAULT NULL,
  `order_date` datetime DEFAULT NULL,
  `paid_date` datetime DEFAULT NULL,  
  `shipped_date` datetime DEFAULT NULL,
  `payment_type` varchar(50) DEFAULT NULL,
  `quantity` decimal(18,4) NOT NULL DEFAULT '0.0000',
  `unit_price` decimal(19,4) DEFAULT '0.0000',
  `discount` double NOT NULL DEFAULT '0',
  `shipping_fee` decimal(19,4) DEFAULT '0.0000',
  `taxes` decimal(19,4) DEFAULT '0.0000',
  `tax_rate` double DEFAULT '0',
  `order_status` varchar(50) NOT NULL,
  `order_details_status` varchar(50) NOT NULL,
  PRIMARY KEY (`fact_order_key`),
  KEY `order_id` (`order_id`),
  KEY `order_detail_id` (`order_detail_id`),
  KEY `customer_id` (`customer_id`),
  KEY `employee_id` (`employee_id`),
  KEY `product_id` (`product_id`),
  KEY `shipper_id` (`shipper_id`),
  KEY `payment_type` (`payment_type`),
  KEY `order_status` (`order_status`),
  KEY `order_details_status` (`order_details_status`)
) ENGINE=InnoDB AUTO_INCREMENT=82 DEFAULT CHARSET=utf8mb3;
  

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
USE northwind_dw;

DROP TABLE IF EXISTS dim_date;
CREATE TABLE dim_date(
 date_key int NOT NULL,
 full_date date NULL,
 date_name char(11) NOT NULL,
 date_name_us char(11) NOT NULL,
 date_name_eu char(11) NOT NULL,
 day_of_week tinyint NOT NULL,
 day_name_of_week char(10) NOT NULL,
 day_of_month tinyint NOT NULL,
 day_of_year smallint NOT NULL,
 weekday_weekend char(10) NOT NULL,
 week_of_year tinyint NOT NULL,
 month_name char(10) NOT NULL,
 month_of_year tinyint NOT NULL,
 is_last_day_of_month char(1) NOT NULL,
 calendar_quarter tinyint NOT NULL,
 calendar_year smallint NOT NULL,
 calendar_year_month char(10) NOT NULL,
 calendar_year_qtr char(10) NOT NULL,
 fiscal_month_of_year tinyint NOT NULL,
 fiscal_quarter tinyint NOT NULL,
 fiscal_year int NOT NULL,
 fiscal_year_month char(10) NOT NULL,
 fiscal_year_qtr char(10) NOT NULL,
  PRIMARY KEY (`date_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

# Here is the PopulateDateDimension Stored Procedure: 
delimiter //

DROP PROCEDURE IF EXISTS PopulateDateDimension//
CREATE PROCEDURE PopulateDateDimension(BeginDate DATETIME, EndDate DATETIME)
BEGIN

	# =============================================
	# Description: http://arcanecode.com/2009/11/18/populating-a-kimball-date-dimension/
	# =============================================

	# A few notes, this code does nothing to the existing table, no deletes are triggered before hand.
    # Because the DateKey is uniquely indexed, it will simply produce errors if you attempt to insert duplicates.
	# You can however adjust the Begin/End dates and rerun to safely add new dates to the table every year.
	# If the begin date is after the end date, no errors occur but nothing happens as the while loop never executes.

	# Holds a flag so we can determine if the date is the last day of month
	DECLARE LastDayOfMon CHAR(1);

	# Number of months to add to the date to get the current Fiscal date
	DECLARE FiscalYearMonthsOffset INT;

	# These two counters are used in our loop.
	DECLARE DateCounter DATETIME;    #Current date in loop
	DECLARE FiscalCounter DATETIME;  #Fiscal Year Date in loop

	# Set this to the number of months to add to the current date to get the beginning of the Fiscal year.
    # For example, if the Fiscal year begins July 1, put a 6 there.
	# Negative values are also allowed, thus if your 2010 Fiscal year begins in July of 2009, put a -6.
	SET FiscalYearMonthsOffset = 6;

	# Start the counter at the begin date
	SET DateCounter = BeginDate;

	WHILE DateCounter <= EndDate DO
		# Calculate the current Fiscal date as an offset of the current date in the loop
		SET FiscalCounter = DATE_ADD(DateCounter, INTERVAL FiscalYearMonthsOffset MONTH);

		# Set value for IsLastDayOfMonth
		IF MONTH(DateCounter) = MONTH(DATE_ADD(DateCounter, INTERVAL 1 DAY)) THEN
			SET LastDayOfMon = 'N';
		ELSE
			SET LastDayOfMon = 'Y';
		END IF;

		# add a record into the date dimension table for this date
		INSERT INTO dim_date
			(date_key
			, full_date
			, date_name
			, date_name_us
			, date_name_eu
			, day_of_week
			, day_name_of_week
			, day_of_month
			, day_of_year
			, weekday_weekend
			, week_of_year
			, month_name
			, month_of_year
			, is_last_day_of_month
			, calendar_quarter
			, calendar_year
			, calendar_year_month
			, calendar_year_qtr
			, fiscal_month_of_year
			, fiscal_quarter
			, fiscal_year
			, fiscal_year_month
			, fiscal_year_qtr)
		VALUES  (
			( YEAR(DateCounter) * 10000 ) + ( MONTH(DateCounter) * 100 ) + DAY(DateCounter)  #DateKey
			, DateCounter #FullDate
			, CONCAT(CAST(YEAR(DateCounter) AS CHAR(4)),'/', DATE_FORMAT(DateCounter,'%m'),'/', DATE_FORMAT(DateCounter,'%d')) #DateName
			, CONCAT(DATE_FORMAT(DateCounter,'%m'),'/', DATE_FORMAT(DateCounter,'%d'),'/', CAST(YEAR(DateCounter) AS CHAR(4)))#DateNameUS
			, CONCAT(DATE_FORMAT(DateCounter,'%d'),'/', DATE_FORMAT(DateCounter,'%m'),'/', CAST(YEAR(DateCounter) AS CHAR(4)))#DateNameEU
			, DAYOFWEEK(DateCounter) #DayOfWeek
			, DAYNAME(DateCounter) #DayNameOfWeek
			, DAYOFMONTH(DateCounter) #DayOfMonth
			, DAYOFYEAR(DateCounter) #DayOfYear
			, CASE DAYNAME(DateCounter)
				WHEN 'Saturday' THEN 'Weekend'
				WHEN 'Sunday' THEN 'Weekend'
				ELSE 'Weekday'
			END #WeekdayWeekend
			, WEEKOFYEAR(DateCounter) #WeekOfYear
			, MONTHNAME(DateCounter) #MonthName
			, MONTH(DateCounter) #MonthOfYear
			, LastDayOfMon #IsLastDayOfMonth
			, QUARTER(DateCounter) #CalendarQuarter
			, YEAR(DateCounter) #CalendarYear
			, CONCAT(CAST(YEAR(DateCounter) AS CHAR(4)),'-',DATE_FORMAT(DateCounter,'%m')) #CalendarYearMonth
			, CONCAT(CAST(YEAR(DateCounter) AS CHAR(4)),'Q',QUARTER(DateCounter)) #CalendarYearQtr
			, MONTH(FiscalCounter) #[FiscalMonthOfYear]
			, QUARTER(FiscalCounter) #[FiscalQuarter]
			, YEAR(FiscalCounter) #[FiscalYear]
			, CONCAT(CAST(YEAR(FiscalCounter) AS CHAR(4)),'-',DATE_FORMAT(FiscalCounter,'%m')) #[FiscalYearMonth]
			, CONCAT(CAST(YEAR(FiscalCounter) AS CHAR(4)),'Q',QUARTER(FiscalCounter)) #[FiscalYearQtr]
		);
		# Increment the date counter for next pass thru the loop
		SET DateCounter = DATE_ADD(DateCounter, INTERVAL 1 DAY);
	END WHILE;
END//

CALL PopulateDateDimension('2000-01-01', '2010-12-31');

SELECT MIN(full_date) AS BeginDate
	, MAX(full_date) AS EndDate
FROM dim_date;


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


-- --------------------------------------------------------------------------------------
-- Title: Lab 02e Create Merge Stored Procedures
-- Author: Professor Jon Tupitza, University of Virginia School of Data Science
-- --------------------------------------------------------------------------------------
-- Description: This script demonstrates how to create stored procedures for maintaining
-- Type 1 Slowly-Changing Dimensions. Type 1 Dimension changes are handled by updating
-- values contained within the columns of currently existing rows, in-place, rather than
-- inserting new rows to capture the new values associated with instances of the affected
-- entities. Consequently, this overwrites historic values rather than maintaining them.  
-- --------------------------------------------------------------------------------------
USE northwind_dw;

-- -------------------------------------------------------------------
-- Customers Dimension
-- -------------------------------------------------------------------
DELIMITER $

DROP PROCEDURE IF EXISTS merge_customers;

CREATE PROCEDURE merge_customers(
	IN cust_key INT,
    IN customer_id INT,
    IN company VARCHAR(50),
    IN last_name VARCHAR(50),
    IN first_name VARCHAR(50),
    IN job_title VARCHAR(50),
    IN business_phone VARCHAR(25),
    IN fax_number VARCHAR(25),
    IN address LONGTEXT,
    IN city VARCHAR(50),
    IN state_province VARCHAR(50),
    IN zip_postal_code VARCHAR(15),
    IN country_region VARCHAR(50)
)
BEGIN
    IF EXISTS (SELECT 1 FROM dim_customers WHERE customer_key = cust_key) THEN
        UPDATE northwind_dw.dim_customers
        SET customer_id = customer_id,
			company = company,
			last_name = last_name,
			first_name = first_name,
			job_title = job_title,
			business_phone = business_phone,
			fax_number = fax_number,
			address = address,
			city = city,
			state_province = state_province,
			zip_postal_code = zip_postal_code,
			country_region = country_region
        WHERE customer_key = cust_key;
    ELSE
        INSERT INTO northwind_dw.dim_customers (
			customer_id
            , company
            , last_name
            , first_name
            , job_title
            , business_phone
            , fax_number
            , address
            , city
            , state_province
            , zip_postal_code
            , country_region)
        VALUES (
			customer_id
            , company
            , last_name
            , first_name
            , job_title
            , business_phone
            , fax_number
            , address
            , city
            , state_province
            , zip_postal_code
            , country_region);
    END IF;
END$$

DELIMITER ;

-- ---------------------------------------------------------------------
-- Unit Test 'merge_customers'
-- ---------------------------------------------------------------------
-- Changes Area Code and 'Zip_Postal_Code' to accurate values.
CALL merge_customers(29, 29, 'Company CC', 'Lee', 'Soo Jung', 'Purchasing Manager', '(303)555-0100', '(303)555-0101', '789 29th Street', 'Denver', 'CO', '80271', 'USA');
-- Creates a New Customer Record
CALL merge_customers(30, 30, 'Company DD', 'McCartney', 'Paul', 'Purchasing Manager', '(703)555-1234', '(703)555-1212', '258 30th Street', 'Alexandria', 'VA', '22314', 'USA');


-- View the Results ----------------------    
SELECT * FROM northwind_dw.dim_customers
WHERE customer_key >= 29;

-- -------------------------------------------------------------------
-- Employees Dimension
-- -------------------------------------------------------------------
DELIMITER $

DROP PROCEDURE IF EXISTS merge_employees;

CREATE PROCEDURE merge_employees(
	IN emp_key INT,
    IN employee_id INT,
    IN company VARCHAR(50),
    IN last_name VARCHAR(50),
    IN first_name VARCHAR(50),
    IN email_address VARCHAR(50),
    IN job_title VARCHAR(50),
    IN business_phone VARCHAR(25),
    IN home_phone VARCHAR(25),
    IN fax_number VARCHAR(25),
    IN address LONGTEXT,
    IN city VARCHAR(50),
    IN state_province VARCHAR(50),
    IN zip_postal_code VARCHAR(15),
    IN country_region VARCHAR(50),
    IN web_page LONGTEXT
)
BEGIN
    IF EXISTS (SELECT 1 FROM dim_employees WHERE employee_key = emp_key) THEN
        UPDATE northwind_dw.dim_employees
        SET employee_id = employee_id,
			company = company,
			last_name = last_name,
			first_name = first_name,
            email_address = email_address,
			job_title = job_title,
			business_phone = business_phone,
            home_phone = home_phone,
			fax_number = fax_number,
			address = address,
			city = city,
			state_province = state_province,
			zip_postal_code = zip_postal_code,
			country_region = country_region,
            web_page = web_page
        WHERE employee_key = emp_key;
    ELSE
        INSERT INTO northwind_dw.dim_employees (
			employee_id
            , company
            , last_name
            , first_name
            , email_address
            , job_title
            , business_phone
            , home_phone
            , fax_number
            , address
            , city
            , state_province
            , zip_postal_code
            , country_region
            , web_page)
        VALUES (
			employee_id
            , company
            , last_name
            , first_name
            , email_address
            , job_title
            , business_phone
            , home_phone
            , fax_number
            , address
            , city
            , state_province
            , zip_postal_code
            , country_region
            , web_page);
    END IF;
END$$

DELIMITER ;

-- ---------------------------------------------------------------------
-- Unit Test 'merge_employees'
-- ---------------------------------------------------------------------
-- Changes Area Code and 'Zip_Postal_Code' to accurate values.
CALL merge_employees(9, 9, 'Northwind Traders', 'Hellung-Larsen', 'Anne', 'anne@northwindtraders.com', 'Sales Representative', '(206)555-0100', '(206)555-0102', '(206)555-0103', '123 9th Avenue', 'Seattle', 'WA', '98104', 'USA', 'http://northwindtraders.com#http://northwindtraders.com/#');
-- Creates a New Customer Record
CALL merge_employees(10, 10, 'Northwind Traders', 'McCartney', 'Paul', 'paul@northwindtraders.com', 'Purchasing Manager', '(206)555-1234', '(206)555-1212', '(206)555-4321', '258 30th Street', 'Seattle', 'WA', '98104', 'USA', 'http://northwindtraders.com#http://northwindtraders.com/#');


-- View the Results ----------------------    
SELECT * FROM northwind_dw.dim_employees
WHERE employee_key >= 9;


-- -------------------------------------------------------------------
-- TODO: Products Dimension
-- -------------------------------------------------------------------
DELIMITER $

DROP PROCEDURE IF EXISTS merge_products;

CREATE PROCEDURE merge_products(
  IN `prod_key` int,
  IN `product_id` int ,
  IN `product_code` varchar(25) ,
  IN `product_name` varchar(50) ,
  IN `standard_cost` decimal(19,4) ,
  IN `list_price` decimal(19,4) ,
  IN `reorder_level` int ,
  IN `target_level` int ,
  IN `quantity_per_unit` varchar(50),
  IN `discontinued` tinyint(1) ,
  IN `minimum_reorder_quantity` int ,
  IN `category` varchar(50)
)
BEGIN
	IF exists (select 1 from dim_products where product_key = prod_key) then
		Update northwind_dw.dim_products
        set product_id = product_id,
			product_code = product_code,
			product_name = product_name,
			standard_cost = standard_cost,
			list_price = list_price,
			reorder_level = reorder_level,
			target_level = target_level,
			quantity_per_unit = quantity_per_unit,
			discontinued = discontinued,
			minimum_reorder_quantity = minimum_reorder_quantity,
			category = category
		where product_key = prod_key;
	else
		insert into northwind_dw.dim_products (
			product_id,
            product_code,
            product_name,
            standard_cost,
            list_price,
            reorder_level,
            target_level,
            quantity_per_unit,
            discontinued,
            minimum_reorder_quantity,
            category)
		Values(
			product_id,
            product_code,
            product_name,
            standard_cost,
            list_price,
            reorder_level,
            target_level,
            quantity_per_unit,
            discontinued,
            minimum_reorder_quantity,
            category);
    End if;
END$$

DELIMITER ;

-- ---------------------------------------------------------------------
-- Unit Test 'merge_products'
-- ---------------------------------------------------------------------
-- Changes Area Code and 'Zip_Postal_Code' to accurate values.
CALL merge_products(45, 99, 'NWTSO-99', 'Northwind Traders Chicken Soup', '1.0000', '1.9500', '100', '200', '18.5 oz', '0', 50, 'Soups');
-- Creates a New Customer Record
CALL merge_products(46, 100, 'NWTSO-100', 'Northwind Traders Beef Soup', '1.0000', '1.9500', '100', '200', '18.5 oz', '0', 50, 'Soups');


-- View the Results ----------------------    
SELECT * FROM northwind_dw.dim_products
WHERE product_key >= 45;



-- -------------------------------------------------------------------
-- TODO: Shippers Dimension
-- -------------------------------------------------------------------
DELIMITER $

DROP PROCEDURE IF EXISTS merge_shippers;

CREATE PROCEDURE merge_shippers(
  `ship_key` int ,
  `shipper_id` int ,
  `company` varchar(50) ,
  `address` longtext,
  `city` varchar(50) ,
  `state_province` varchar(50) ,
  `zip_postal_code` varchar(15) ,
  `country_region` varchar(50)
)
BEGIN
	IF exists (select 1 from dim_shippers where shipper_key = ship_key) then
		update northwind_dw.dim_shippers
        set shipper_id = shipper_id,
			company = company,
			address = address,
			city = city,
			state_province = state_province, 
			zip_postal_code = zip_postal_code,
			country_region = country_region
        where shipper_key = ship_key;
	Else 
		insert into northwind_dw.dim_shippers (
			shipper_id,
			company,
			address,
			city,
			state_province,
			zip_postal_code,
			country_region)
		Values (
			shipper_id,
            company,
            address,
            city,
            state_province,
            zip_postal_code,
            country_region);
	End if;
END$$

DELIMITER ;

-- ---------------------------------------------------------------------
-- Unit Test 'merge_shippers'
-- ---------------------------------------------------------------------
-- Changes Area Code and 'Zip_Postal_Code' to accurate values.
CALL merge_shippers(3, 3, 'Shipping Company C', '123 Any Street', 'Memphis', 'TN', '38103', 'USA');
-- Creates a New Customer Record
CALL merge_shippers(4, 4, 'Shipping Company C', '123 Any Street', 'Memphis', 'TN', '38103', 'USA');


-- View the Results ----------------------    
SELECT * FROM northwind_dw.dim_shippers
WHERE shipper_key >= 3;

-- --------------------------------------------------------------------------------------------------
-- LAB QUESTION: Author a SQL query that returns the total (sum) of the quantity and unit price
-- for each customer (last name), sorted by the total unit price in descending order.
-- --------------------------------------------------------------------------------------------------

Select 
	last_name,
	sum(quantity) as total_quantity,
	sum(unit_price) as total_unit_price
from fact_orders as fo
join dim_customers as dc
	on fo.customer_key = dc.customer_key
group by last_name
order by total_unit_price desc;


