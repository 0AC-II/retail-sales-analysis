# ANALYSIS QUERIES

# 1. This query answers which categories drive the majority of revenue
SELECT
    product_category,
    SUM(total_amount) AS total_revenue
FROM retail_sales
GROUP BY product_category
ORDER BY total_revenue DESC;

# 2. How does revenue change over time at a monthly level?
SELECT
    DATE_FORMAT(date, '%Y-%m') AS month,
    SUM(total_amount) AS monthly_sales
FROM retail_sales
GROUP BY month
ORDER BY month;

# 3. Find out if many units are sold without making much money
SELECT
    transaction_id,
    product_category,
    quantity,
    total_amount
FROM retail_sales
WHERE quantity >= 3
ORDER BY total_amount ASC
LIMIT 10;

# 4. Do customer segments differ in how much they spend per transaction?
SELECT
    gender,
    ROUND(AVG(total_amount), 2) AS avg_order_value
FROM retail_sales
GROUP BY gender;

# 5. Finding out if revenue is concentrated in a small number of categories
SELECT
    product_category,
    COUNT(*) AS transactions,
    SUM(total_amount) AS total_revenue,
    ROUND(SUM(total_amount) / 
          (SELECT SUM(total_amount) FROM retail_sales) * 100, 2) 
          AS revenue_percentage
FROM retail_sales
GROUP BY product_category
ORDER BY total_revenue DESC;

# 6. Customer age vs spending
SELECT
    CASE
        WHEN age < 30 THEN 'Under 30'
        WHEN age BETWEEN 30 AND 45 THEN '30–45'
        ELSE '46+'
    END AS age_group,
    ROUND(AVG(total_amount), 2) AS avg_spend
FROM retail_sales
GROUP BY age_group
ORDER BY avg_spend DESC;