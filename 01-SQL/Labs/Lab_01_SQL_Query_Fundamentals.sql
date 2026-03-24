-- --------------------------------------------------------------------------------------
-- Course: DS2-2002 - Data Science Systems | Author: Jon Tupitza
-- Lab 1: SQL Query Fundamentals | 5 Points
-- --------------------------------------------------------------------------------------

-- --------------------------------------------------------------------------------------
-- 1). First, How Many Rows (Products) are in the Products Table?			| 0.2 pt
-- --------------------------------------------------------------------------------------
select count(*) 
from products;
-- 45

-- --------------------------------------------------------------------------------------
-- 2). Fetch Each Product Name and its Quantity per Unit					| 0.2.pt
-- --------------------------------------------------------------------------------------
select product_name, quantity_per_unit
from products;

-- --------------------------------------------------------------------------------------
-- 3). Fetch the Product ID and Name of Currently Available Products		| 0.2 pt
-- --------------------------------------------------------------------------------------
select id, product_name 
from products
where discontinued = 0;

-- --------------------------------------------------------------------------------------
-- 4). Fetch the Product ID, Name & List Price Costing Less Than $20
--     Sort the results with the most expensive Products first.				| 0.2 pt
-- --------------------------------------------------------------------------------------
select id, product_name, standard_cost
from products
where standard_cost < 20
order by standard_cost desc;

-- --------------------------------------------------------------------------------------
-- 5). Fetch the Product ID, Name & List Price Costing Between $15 and $20
--     Sort the results with the most expensive Products first.				| 0.2 pt
-- --------------------------------------------------------------------------------------
select id , product_name, standard_cost
from products
where standard_cost between 15 and 20
order by standard_cost desc;

-- Older (Equivalent) Syntax -----


-- --------------------------------------------------------------------------------------
-- 6). Fetch the Product Name & List Price of the 10 Most Expensive Products 
--     Sort the results with the most expensive Products first.				| 0.33 pt
-- --------------------------------------------------------------------------------------
select product_name, standard_cost
from products
order by standard_cost desc
limit 10;

-- --------------------------------------------------------------------------------------
-- 7). Fetch the Name & List Price of the Most & Least Expensive Products	| 0.33 pt.
-- --------------------------------------------------------------------------------------
select product_name, standard_cost
from products
where standard_cost = (select max(standard_cost) from products)
	or standard_cost = (select min(standard_cost)from products);

-- --------------------------------------------------------------------------------------
-- 8). Fetch the Product Name & List Price Costing Above Average List Price
--     Sort the results with the most expensive Products first.				| 0.33 pt.
-- --------------------------------------------------------------------------------------
select product_name, standard_cost
from products
where standard_cost > (select avg(standard_cost) from products)
order by standard_cost desc;

-- --------------------------------------------------------------------------------------
-- 9). Fetch & Label the Count of Current and Discontinued Products using
-- 	   the "CASE... WHEN" syntax to create a column named "availablity"
--     that contains the values "discontinued" and "current". 				| 0.33 pt
-- --------------------------------------------------------------------------------------
UPDATE northwind.products SET discontinued = 1 WHERE id IN (95, 96, 97);

-- TODO: Insert query here.
select 
	case 
		when discontinued = 1 then 'discontinued'
		else 'current'
    end as 'availability',
    count(*) as product_count
from products
group by
	case
		when discontinued = 1 then 'discontinued'
		else 'current'
    end;
    
UPDATE northwind.products SET discontinued = 0 WHERE id in (95, 96, 97);

-- --------------------------------------------------------------------------------------
-- 10). Fetch Product Name, Reorder Level, Target Level and "Reorder Threshold"
-- 	    Where Reorder Level is Less Than or Equal to 20% of Target Level	| 0.33 pt.
-- --------------------------------------------------------------------------------------
select product_name, reorder_level, target_level, minimum_reorder_quantity
from products
where reorder_level <= (0.2 * target_level);

-- --------------------------------------------------------------------------------------
-- 11). Fetch the Number of Products per Category Priced Less Than $20.00	| 0.33 pt
-- --------------------------------------------------------------------------------------
select category, count(*) as "Number of Products"
from products
where standard_cost < 20
group by category;

-- --------------------------------------------------------------------------------------
-- 12). Fetch the Number of Products per Category With Less Than 5 Units In Stock	| 0.5 pt
-- --------------------------------------------------------------------------------------
select category, count(*) as "Number of Products"
from products
where reorder_level < 5
group by category;

-- --------------------------------------------------------------------------------------
-- 13). Fetch Products along with their Supplier Company & Address Info		| 0.5 pt
-- --------------------------------------------------------------------------------------
select product_name, company, address
from products
join suppliers
	on products.supplier_ids = suppliers.id;

-- --------------------------------------------------------------------------------------
-- 14). Fetch the Customer ID and Full Name for All Customers along with
-- 		the Order ID and Order Date for Any Orders they may have			| 0.5 pt
-- --------------------------------------------------------------------------------------
select c.id, c.first_name, c.last_name, o.id, o.order_date
from customers c
left join orders o
	on c.id = o.customer_id;

-- --------------------------------------------------------------------------------------
-- 15). Fetch the Order ID and Order Date for All Orders along with
--   	the Customr ID and Full Name for Any Associated Customers			| 0.5 pt
-- --------------------------------------------------------------------------------------
select o.id, o.order_date, c.id, c.first_name, c.last_name
from orders o
left join customers c
	on o.customer_id = c.id;



