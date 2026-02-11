SELECT * FROM INFORMATION_SCHEMA.TABLES

-- Explore all columns in DB 
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers'

--------------- Dimension Exploration ---------------

-- All countries our customers come from 
SELECT DISTINCT country FROM gold.dim_customers

-- Explore all categories "the major divisions" 
SELECT DISTINCT category,subcategory,product_name FROM gold.dim_products

-- First and last order 
-- How many years of sales data 
SELECT 
	MIN(order_date) oldest_order,
	MAX(order_date) latest_order,
	DATEDIFF(month, MIN(order_date),MAX(order_date)) AS sales_range_month
from gold.fact_sales

-- Youngest and oldest customer 
SELECT 
	DATEDIFF(year,MIN(birthdate),GETDATE()) oldest_customer_age,
	DATEDIFF(year,MAX(birthdate),GETDATE()) youngest_customer_age
FROM gold.dim_customers

--------------- Measure exploration ---------------
-- Find the Total Sales 
SELECT  SUM(sales_amount) AS total_sales FROM gold.fact_sales

-- Find how many items are sold 
SELECT  SUM(quantity) AS total_quantity FROM gold.fact_sales
-- Find the avg selling price 
SELECT AVG(price) avg_price FROM gold.fact_sales
-- Find the Total # of orders 
SELECT  COUNT(order_number) AS total_orders FROM gold.fact_sales
SELECT  COUNT(DISTINCT order_number) AS total_orders FROM gold.fact_sales --correct one 

-- Find the Total # of products 
SELECT COUNT(product_key) AS total_products FROM gold.dim_products

-- Find the Total # of customers 
SELECT COUNT(customer_key) FROM gold.dim_customers
-- Find the Total # of customers that have placed an order
SELECT  COUNT(DISTINCT customer_key) FROM gold.fact_sales

-- Generate a Report that shows all key metrics of the business 
SELECT  'Total Sales' AS measure_name, SUM(sales_amount) AS total_sales FROM gold.fact_sales
UNION ALL
SELECT  'Total Quantity' AS measure_name ,SUM(quantity) AS total_quantity FROM gold.fact_sales
UNION ALL
SELECT 'Average Price' AS measure_name ,AVG(price) avg_price FROM gold.fact_sales
UNION ALL
SELECT 'Total # of Orders' AS measure_name ,COUNT(DISTINCT order_number) AS total_orders FROM gold.fact_sales
UNION ALL
SELECT 'Total # of Products' AS measure_name ,COUNT(product_key) AS total_products FROM gold.dim_products
UNION ALL
SELECT 'Total # of Customers' AS measure_name ,COUNT(customer_key) FROM gold.dim_customers

--------------- Magnitude Analysis --------------- 
-- Find total customers by countries 
SELECT 
	country,
	COUNT(customer_key) AS number_of_customer
FROM gold.dim_customers
GROUP BY country
ORDER BY number_of_customer DESC

-- Find total customers by gender
SELECT 
	gender,
	COUNT(customer_key) AS number_of_customer
FROM gold.dim_customers
GROUP BY gender
ORDER BY number_of_customer DESC

-- Find total products by category
SELECT
	category,
	COUNT(product_key) as total_products
FROM gold.dim_products
GROUP BY category
ORDER BY total_products DESC
-- Average costs in each category 
SELECT 
	AVG(cost) as average_cost,
	category
FROM gold.dim_products
GROUP BY category 
-- Total revenue generated for each category 
SELECT 
	p.category,
	SUM(sales_amount) AS total_sales
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p 
ON s.product_key = p.product_key
GROUP BY p.category
ORDER BY total_sales DESC

-- Top 10 customers with highest revenue generated
SELECT TOP 10
	s.customer_key, 
	c.firstname,
	c.lastname,
	SUM(sales_amount) AS total_sales
FROM gold.fact_sales as s
LEFT JOIN gold.dim_customers AS c
ON s.customer_key = c.customer_key
GROUP BY s.customer_key,c.firstname, c.lastname
ORDER BY total_sales DESC

-- Quantity sold by countries
SELECT
	c.country,
	SUM(s.quantity) AS total_sold_items
FROM gold.fact_sales as s
LEFT JOIN gold.dim_customers AS c
ON s.customer_key = c.customer_key
GROUP BY c.country
ORDER BY total_sold_items DESC

-- Which 5 products generate the highest revenue? 
SELECT TOP 5
	p.category,
	p.product_name,
	SUM(sales_amount) AS total_sales
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p 
ON s.product_key = p.product_key
GROUP BY p.category, p.product_name
ORDER BY total_sales DESC

-- Window function way 
SELECT * 
FROM (
	SELECT 
		p.category,
		p.product_name,
		SUM(sales_amount) AS total_sales,
		ROW_NUMBER() OVER (ORDER BY SUM(s.sales_amount) DESC) as product_rank
	FROM gold.fact_sales AS s
	LEFT JOIN gold.dim_products AS p 
	ON s.product_key = p.product_key
	GROUP BY p.category, p.product_name) as t 
WHERE product_rank <=5

-- What are the 5 worst-performing products in terms of sales? 
SELECT TOP 5
	p.category,
	p.product_name,
	SUM(sales_amount) AS total_sales
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p 
ON s.product_key = p.product_key
GROUP BY p.category, p.product_name
ORDER BY total_sales 