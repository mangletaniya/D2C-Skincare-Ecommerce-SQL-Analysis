create database final_project;
use final_project;
select * from products;
select * from orders ;
select * FROM order_items;
select * from customers;
select * from returns;
select * from reviews;

-- Revenue Analysis

-- 1. Total Revenue Generated
SELECT SUM(final_amount) AS total_revenue
FROM Orders;

-- 2. Monthly Revenue Trend
SELECT
MONTH(STR_TO_DATE(order_date,'%d-%m-%Y')) AS month,
SUM(final_amount) AS revenue
FROM Orders
GROUP BY month
ORDER BY month;

-- 3. Revenue by Sales Channel
SELECT
sales_channel,
SUM(final_amount) AS revenue
FROM Orders
GROUP BY sales_channel
ORDER BY revenue DESC;

-- 4. Revenue by Payment Method
SELECT
payment_method,
SUM(final_amount) revenue
FROM Orders
GROUP BY payment_method;

-- 5. Top Revenue Generating States
SELECT
c.state,
SUM(o.final_amount) revenue
FROM Customers c
JOIN Orders o
ON c.customer_id=o.customer_id
GROUP BY c.state
ORDER BY revenue DESC;


-- Customer Analytics

-- 6. Top Customers by Revenue
SELECT
c.customer_name,
SUM(o.final_amount) revenue
FROM Customers c
JOIN Orders o
ON c.customer_id=o.customer_id
GROUP BY c.customer_name
ORDER BY revenue DESC
LIMIT 10;

-- 7. Top Customers by Orders
SELECT
customer_id,
COUNT(order_id) total_orders
FROM Orders
GROUP BY customer_id
ORDER BY total_orders DESC;

-- 8. Revenue by Gender
SELECT
c.gender,
SUM(o.final_amount) revenue
FROM Customers c
JOIN Orders o
ON c.customer_id=o.customer_id
GROUP BY c.gender;

-- 9. Revenue by Age Group`
SELECT
c.age_group,
SUM(o.final_amount) revenue
FROM Customers c
JOIN Orders o
ON c.customer_id=o.customer_id
GROUP BY c.age_group;

-- 10. Customer Acquisition Channel Performance
SELECT
c.acquisition_channel,
SUM(o.final_amount) revenue
FROM Customers c
JOIN Orders o
ON c.customer_id=o.customer_id
GROUP BY c.acquisition_channel
ORDER BY revenue DESC;


-- Product Analytics


-- 11. Best Selling Products
SELECT
p.product_name,
SUM(oi.quantity) units_sold
FROM Products p
JOIN Order_Items oi
ON p.product_id=oi.product_id
GROUP BY p.product_name
ORDER BY units_sold DESC;

-- 12. Top Revenue Products
SELECT
p.product_name,
SUM(oi.item_total) revenue
FROM Products p
JOIN Order_Items oi
ON p.product_id=oi.product_id
GROUP BY p.product_name
ORDER BY revenue DESC;

-- 13. Category Wise Revenue
SELECT
p.category,
SUM(oi.item_total) revenue
FROM Products p
JOIN Order_Items oi
ON p.product_id=oi.product_id
GROUP BY p.category;

-- 14. Category Wise Units Sold
SELECT
p.category,
SUM(oi.quantity) units_sold
FROM Products p
JOIN Order_Items oi
ON p.product_id=oi.product_id
GROUP BY p.category;

-- 15. Top 3 Products in Each Category
WITH cte AS
(
SELECT
p.category,
p.product_name,
SUM(oi.item_total) revenue,
ROW_NUMBER() OVER(
PARTITION BY p.category
ORDER BY SUM(oi.item_total) DESC
) rn
FROM Products p
JOIN Order_Items oi
ON p.product_id=oi.product_id
GROUP BY p.category,p.product_name
)

SELECT *
FROM cte
WHERE rn<=3;


-- Profitability Analysis


-- 16. Most Profitable Products
SELECT
p.product_name,
SUM((oi.unit_price-p.cost_price)*oi.quantity) profit
FROM Products p
JOIN Order_Items oi
ON p.product_id=oi.product_id
GROUP BY p.product_name
ORDER BY profit DESC;

-- 17. Category Wise Profit
SELECT
p.category,
SUM((oi.unit_price-p.cost_price)*oi.quantity) profit
FROM Products p
JOIN Order_Items oi
ON p.product_id=oi.product_id
GROUP BY p.category;

-- 18. Low Margin Products
SELECT
product_name,
(mrp-cost_price) margin
FROM Products
ORDER BY margin;


-- Inventory Analysis


-- 19. Low Stock Products
SELECT
product_name,
stock_qty
FROM Products
ORDER BY stock_qty ASC;

-- 20. High Demand + Low Stock Products
SELECT
p.product_name,
p.stock_qty,
SUM(oi.quantity) sold_qty
FROM Products p
JOIN Order_Items oi
ON p.product_id=oi.product_id
GROUP BY p.product_name,p.stock_qty
ORDER BY sold_qty DESC;


-- Returns Analysis


-- 21. Overall Return Count
SELECT COUNT(*) total_returns
FROM Returns;

-- 22. Most Returned Products
SELECT
p.product_name,
COUNT(*) returns_count
FROM Returns r
JOIN Products p
ON r.product_id=p.product_id
GROUP BY p.product_name
ORDER BY returns_count DESC;

-- 23. Return Reason Analysis
SELECT
return_reason,
COUNT(*) total
FROM Returns
GROUP BY return_reason
ORDER BY total DESC;

-- 24. Refund Status Analysis
SELECT
refund_status,
COUNT(*) total
FROM Returns
GROUP BY refund_status;


-- Review Analysis


-- 25. Average Product Rating
SELECT
p.product_name,
AVG(r.rating) avg_rating
FROM Products p
JOIN Reviews r
ON p.product_id=r.product_id
GROUP BY p.product_name;

-- 26. Highest Rated Products
SELECT
p.product_name,
AVG(r.rating) avg_rating
FROM Products p
JOIN Reviews r
ON p.product_id=r.product_id
GROUP BY p.product_name
ORDER BY avg_rating DESC;

-- 27. Lowest Rated Products
SELECT
p.product_name,
AVG(r.rating) avg_rating
FROM Products p
JOIN Reviews r
ON p.product_id=r.product_id
GROUP BY p.product_name
ORDER BY avg_rating ASC;

-- Advanced Senior-Level Tasks

-- 28. Products with High Sales & Low Ratings
SELECT
p.product_name,
SUM(oi.quantity) sales,
AVG(r.rating) rating
FROM Products p
JOIN Order_Items oi
ON p.product_id=oi.product_id
JOIN Reviews r
ON p.product_id=r.product_id
GROUP BY p.product_name;

-- 29. Products with High Sales & High Returns
SELECT
p.product_name,
SUM(oi.quantity) sales,
COUNT(rt.return_id) returns_count
FROM Products p
JOIN Order_Items oi
ON p.product_id=oi.product_id
LEFT JOIN Returns rt
ON p.product_id=rt.product_id
GROUP BY p.product_name;

-- 30. Business KPI Dashboard
SELECT
SUM(final_amount) Total_Revenue,
AVG(final_amount) Avg_Order_Value,
COUNT(DISTINCT customer_id) Total_Customers,
COUNT(DISTINCT order_id) Total_Orders
FROM Orders;

-- 31. Revenue by Concern
SELECT
p.concern,
SUM(oi.item_total) revenue
FROM Products p
JOIN Order_Items oi
ON p.product_id=oi.product_id
GROUP BY p.concern;

-- 32. Revenue by Skin Type
SELECT
p.skin_type,
SUM(oi.item_total) revenue
FROM Products p
JOIN Order_Items oi
ON p.product_id=oi.product_id
GROUP BY p.skin_type;

-- 33. Revenue by Key Ingredient
SELECT
key_ingredient,
SUM(oi.item_total) revenue
FROM Products p
JOIN Order_Items oi
ON p.product_id=oi.product_id
GROUP BY key_ingredient;

-- 34. Delivered vs Cancelled Orders
SELECT
order_status,
COUNT(*) total_orders
FROM Orders
GROUP BY order_status;

-- 35. Average Delivery Time
SELECT
AVG(
DATEDIFF(
STR_TO_DATE(delivered_date,'%d-%m-%Y'),
STR_TO_DATE(order_date,'%d-%m-%Y')
)
) avg_delivery_days
FROM Orders
WHERE delivered_date IS NOT NULL;