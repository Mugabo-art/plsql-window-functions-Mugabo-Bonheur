-- ==============================
-- 1. Ranking Functions
-- ==============================

-- 1. ROW_NUMBER() Top customers
SELECT c.customer_id, c.name, SUM(t.amount) AS total_revenue,
       ROW_NUMBER() OVER (ORDER BY SUM(t.amount) DESC) AS row_num
FROM transactions t
JOIN customers c ON t.customer_id = c.customer_id
GROUP BY c.customer_id, c.name;

-- 2. RANK() Top customers
SELECT c.customer_id, c.name, SUM(t.amount) AS total_revenue,
       RANK() OVER (ORDER BY SUM(t.amount) DESC) AS rank_val
FROM transactions t
JOIN customers c ON t.customer_id = c.customer_id
GROUP BY c.customer_id, c.name;

-- 3. DENSE_RANK() Top customers
SELECT c.customer_id, c.name, SUM(t.amount) AS total_revenue,
       DENSE_RANK() OVER (ORDER BY SUM(t.amount) DESC) AS dense_rank_val
FROM transactions t
JOIN customers c ON t.customer_id = c.customer_id
GROUP BY c.customer_id, c.name;

-- 4. PERCENT_RANK() Top customers
SELECT c.customer_id, c.name, SUM(t.amount) AS total_revenue,
       PERCENT_RANK() OVER (ORDER BY SUM(t.amount) DESC) AS percent_rank_val
FROM transactions t
JOIN customers c ON t.customer_id = c.customer_id
GROUP BY c.customer_id, c.name;

-- 5. ROW_NUMBER() partitioned by region
SELECT c.customer_id, c.name, c.region, SUM(t.amount) AS total_revenue,
       ROW_NUMBER() OVER (PARTITION BY c.region ORDER BY SUM(t.amount) DESC) AS row_num_region
FROM transactions t
JOIN customers c ON t.customer_id = c.customer_id
GROUP BY c.customer_id, c.name, c.region;

-- ==============================
-- 2. Aggregate Functions
-- ==============================

-- 6. Monthly total sales
SELECT TO_CHAR(t.sale_date,'YYYY-MM') AS month, SUM(t.amount) AS monthly_sales
FROM transactions t
GROUP BY TO_CHAR(t.sale_date,'YYYY-MM');

-- 7. Running total sales
SELECT TO_CHAR(t.sale_date,'YYYY-MM') AS month, SUM(t.amount) AS monthly_sales,
       SUM(SUM(t.amount)) OVER (ORDER BY TO_CHAR(t.sale_date,'YYYY-MM')) AS running_total
FROM transactions t
GROUP BY TO_CHAR(t.sale_date,'YYYY-MM');

-- 8. 3-month moving average
SELECT TO_CHAR(t.sale_date,'YYYY-MM') AS month, SUM(t.amount) AS monthly_sales,
       AVG(SUM(t.amount)) OVER (ORDER BY TO_CHAR(t.sale_date,'YYYY-MM') ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg
FROM transactions t
GROUP BY TO_CHAR(t.sale_date,'YYYY-MM');

-- 9. MIN monthly sales
SELECT TO_CHAR(t.sale_date,'YYYY-MM') AS month, MIN(SUM(t.amount)) OVER () AS min_sales
FROM transactions t
GROUP BY TO_CHAR(t.sale_date,'YYYY-MM');

-- 10. MAX monthly sales
SELECT TO_CHAR(t.sale_date,'YYYY-MM') AS month, MAX(SUM(t.amount)) OVER () AS max_sales
FROM transactions t
GROUP BY TO_CHAR(t.sale_date,'YYYY-MM');

-- ==============================
-- 3. Navigation Functions
-- ==============================

-- 11. Previous month sales (LAG)
SELECT TO_CHAR(t.sale_date,'YYYY-MM') AS month, SUM(t.amount) AS monthly_sales,
       LAG(SUM(t.amount)) OVER (ORDER BY TO_CHAR(t.sale_date,'YYYY-MM')) AS prev_month_sales
FROM transactions t
GROUP BY TO_CHAR(t.sale_date,'YYYY-MM');

-- 12. Next month sales (LEAD)
SELECT TO_CHAR(t.sale_date,'YYYY-MM') AS month, SUM(t.amount) AS monthly_sales,
       LEAD(SUM(t.amount)) OVER (ORDER BY TO_CHAR(t.sale_date,'YYYY-MM')) AS next_month_sales
FROM transactions t
GROUP BY TO_CHAR(t.sale_date,'YYYY-MM');

-- 13. Month-over-month growth %
SELECT TO_CHAR(t.sale_date,'YYYY-MM') AS month, SUM(t.amount) AS monthly_sales,
       ROUND((SUM(t.amount) - LAG(SUM(t.amount)) OVER (ORDER BY TO_CHAR(t.sale_date,'YYYY-MM')))*100.0/
             NULLIF(LAG(SUM(t.amount)) OVER (ORDER BY TO_CHAR(t.sale_date,'YYYY-MM')),0),2) AS growth_percent
FROM transactions t
GROUP BY TO_CHAR(t.sale_date,'YYYY-MM');

-- 14. Customer order growth
SELECT 
    t.customer_id, 
    t.transaction_id, 
    t.amount,
    LAG(t.amount) OVER (PARTITION BY t.customer_id ORDER BY t.sale_date) AS prev_order,
    LEAD(t.amount) OVER (PARTITION BY t.customer_id ORDER BY t.sale_date) AS next_order
FROM transactions t;

-- 15. Cumulative sales per customer
SELECT 
    t.customer_id,
    DATE_TRUNC('month', t.sale_date) AS month,
    SUM(t.amount) AS monthly_sales,
    SUM(SUM(t.amount)) OVER (
        PARTITION BY t.customer_id 
        ORDER BY DATE_TRUNC('month', t.sale_date)
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_sales
FROM transactions t
GROUP BY t.customer_id, DATE_TRUNC('month', t.sale_date)
ORDER BY t.customer_id, month;


-- ==============================
-- 4. Distribution Functions
-- ==============================

-- 16. NTILE(4) – customer quartiles
SELECT t.customer_id, SUM(t.amount) AS total_revenue,
       NTILE(4) OVER (ORDER BY SUM(t.amount) DESC) AS revenue_quartile
FROM transactions t
GROUP BY t.customer_id;

-- 17. CUME_DIST() – customer percentile
SELECT t.customer_id, SUM(t.amount) AS total_revenue,
       CUME_DIST() OVER (ORDER BY SUM(t.amount) DESC) AS percentile
FROM transactions t
GROUP BY t.customer_id;

-- 18. NTILE per region
SELECT c.customer_id, c.region, SUM(t.amount) AS total_revenue,
       NTILE(4) OVER (PARTITION BY c.region ORDER BY SUM(t.amount) DESC) AS quartile_region
FROM transactions t
JOIN customers c ON t.customer_id = c.customer_id
GROUP BY c.customer_id, c.region;

-- 19. CUME_DIST per product category
SELECT p.category, SUM(t.amount) AS category_sales,
       CUME_DIST() OVER (PARTITION BY p.category ORDER BY SUM(t.amount) DESC) AS percentile_category
FROM transactions t
JOIN products p ON t.product_id = p.product_id
GROUP BY p.category;

-- 20. Combined NTILE + CUME_DIST
SELECT t.customer_id, SUM(t.amount) AS total_revenue,
       NTILE(4) OVER (ORDER BY SUM(t.amount) DESC) AS quartile,
       CUME_DIST() OVER (ORDER BY SUM(t.amount) DESC) AS percentile
FROM transactions t
GROUP BY t.customer_id;
