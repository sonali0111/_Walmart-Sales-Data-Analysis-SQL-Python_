CREATE DATABASE walmart_db;
DROP TABLE walmart;
SELECT COUNT(*) FROM walmart;
SELECT * FROM walmart 
LIMIT 10
-- It is used to tell the data that how many types of methods is used in payment_method, Distinct- how many types of 
SELECT payment_method
FROM walmart
GROUP BY payment_method

-- how many tractions is done in this payment_method, then we have to use group by
-- Count(*) - total quantitieds o count of the product
SELECT payment_method,
COUNT(*)
FROM walmart
GROUP BY payment_method

 Count total records
SELECT COUNT(*) FROM walmart;

-- Count payment methods and number of transactions by payment method
SELECT 
    payment_method,
    COUNT(*) AS no_payments
FROM walmart
GROUP BY payment_method;

-- Count distinct branches
SELECT COUNT(DISTINCT branch) FROM walmart;

-- Find the minimum quantity sold
SELECT MIN(quantity) FROM walmart;

-- Business Problem Q1: Find different payment methods, number of transactions, and quantity sold by payment method
SELECT payment_method,
COUNT(*) as no_payments,
SUM(quantity) as no_qty_sold
FROM walmart
GROUP BY payment_method

-- Project Question #2: Identify the highest-rated category in each branch
-- Display the branch, category, and avg rating
SELECT branch, category, avg_rating, rnk
FROM (
    SELECT
        branch,
        category,
        AVG(rating) AS avg_rating,
        RANK() OVER(PARTITION BY branch ORDER BY AVG(rating) DESC) AS rnk -- Changed to rnk
    FROM walmart
    GROUP BY branch, category
) AS subquery
WHERE rnk = 1; -- Changed to rnk

-- Q3: Identify the busiest day for each branch based on the number of transactions
SELECT branch, day_name, no_transactions
FROM (
    SELECT 
        branch,
        DAYNAME(STR_TO_DATE(date, '%d/%m/%Y')) AS day_name,
        COUNT(*) AS no_transactions,
        RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS rnk
    FROM walmart
    GROUP BY branch, day_name
) AS ranked
WHERE rnk = 1;

-- - Q4: Calculate the total quantity of items sold per payment method
SELECT payment_method,
SUM(quantity) as total_sold
FROM walmart
group by payment_method

-- Q5: Determine the average, minimum, and maximum rating of categories for each city
SELECT 
    city,
    category,
    MIN(rating) AS min_rating,
    MAX(rating) AS max_rating,
    AVG(rating) AS avg_rating
FROM walmart
GROUP BY city, category;


-- Q6: Calculate the total profit for each category
select category,
SUM(unit_price * quantity * profit_margin) AS total_profit
from walmart
group by category
order by total_profit desc

-- Q7: Determine the most common payment method for each branch
WITH cte AS (
    SELECT 
        branch,
        payment_method,
        COUNT(*) AS total_trans,
        RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS rnk
    FROM walmart
    GROUP BY branch, payment_method
)
SELECT branch, payment_method AS preferred_payment_method
FROM cte
WHERE rnk = 1;

-- Q8: Categorize sales into Morning, Afternoon, and Evening shifts
SELECT
    branch,
    CASE 
        WHEN HOUR(TIME(time)) < 12 THEN 'Morning'
        WHEN HOUR(TIME(time)) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(*) AS num_invoices
FROM walmart
GROUP BY branch, shift
ORDER BY branch, num_invoices DESC;

