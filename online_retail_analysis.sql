/*
Project: Online Retail Business Analysis
Database: business_analysis
Main table: online_retail_clean

Purpose:
SQL business analysis for the Online Retail dataset.
The queries below use positive-quantity, positive-price, non-cancelled
transactions for sales analysis. Customer-level analysis also requires
a valid CustomerID.

Note:
These are organised portfolio queries reconstructed from the completed
analysis workflow. Review the filters and metric definitions before
comparing their results with Power BI measures.
*/

USE business_analysis;

-- ------------------------------------------------------------
-- Q1. Dataset overview
-- ------------------------------------------------------------
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT InvoiceNo) AS distinct_invoices,
    COUNT(DISTINCT StockCode) AS distinct_products,
    COUNT(DISTINCT CustomerID) AS distinct_customers,
    COUNT(DISTINCT Country) AS distinct_countries
FROM online_retail_clean;


-- ------------------------------------------------------------
-- Q2. Monthly revenue
-- ------------------------------------------------------------
SELECT
    DATE_FORMAT(InvoiceDate, '%Y-%m') AS sales_month,
    ROUND(SUM(Quantity * UnitPrice), 2) AS total_revenue
FROM online_retail_clean
WHERE Quantity > 0
  AND UnitPrice > 0
  AND InvoiceNo NOT LIKE 'C%'
GROUP BY DATE_FORMAT(InvoiceDate, '%Y-%m')
ORDER BY sales_month;


-- ------------------------------------------------------------
-- Q3. Monthly order trend
-- ------------------------------------------------------------
SELECT
    DATE_FORMAT(InvoiceDate, '%Y-%m') AS sales_month,
    COUNT(DISTINCT InvoiceNo) AS total_orders
FROM online_retail_clean
WHERE Quantity > 0
  AND UnitPrice > 0
  AND InvoiceNo NOT LIKE 'C%'
GROUP BY DATE_FORMAT(InvoiceDate, '%Y-%m')
ORDER BY sales_month;


-- ------------------------------------------------------------
-- Q4. Revenue by country
-- ------------------------------------------------------------
SELECT
    Country,
    ROUND(SUM(Quantity * UnitPrice), 2) AS total_revenue
FROM online_retail_clean
WHERE Quantity > 0
  AND UnitPrice > 0
  AND InvoiceNo NOT LIKE 'C%'
GROUP BY Country
ORDER BY total_revenue DESC;


-- ------------------------------------------------------------
-- Q5. Top 10 products by revenue
-- ------------------------------------------------------------
SELECT
    StockCode,
    Description,
    SUM(Quantity) AS total_quantity_sold,
    ROUND(SUM(Quantity * UnitPrice), 2) AS total_revenue,
    COUNT(DISTINCT InvoiceNo) AS total_orders
FROM online_retail_clean
WHERE CustomerID IS NOT NULL
  AND CustomerID > 0
  AND Quantity > 0
  AND UnitPrice > 0
  AND InvoiceNo NOT LIKE 'C%'
  AND StockCode NOT IN ('POST', 'M')
GROUP BY StockCode, Description
ORDER BY total_revenue DESC
LIMIT 10;


-- ------------------------------------------------------------
-- Q6. Average order value
-- Average of valid invoice totals, not average transaction line.
-- ------------------------------------------------------------
SELECT
    ROUND(AVG(order_total), 2) AS average_order_value
FROM (
    SELECT
        InvoiceNo,
        SUM(Quantity * UnitPrice) AS order_total
    FROM online_retail_clean
    WHERE Quantity > 0
      AND UnitPrice > 0
      AND InvoiceNo NOT LIKE 'C%'
    GROUP BY InvoiceNo
) AS invoice_totals;


-- ------------------------------------------------------------
-- Q7. Customer count by purchase frequency
-- ------------------------------------------------------------
WITH customer_orders AS (
    SELECT
        CustomerID,
        COUNT(DISTINCT InvoiceNo) AS order_count
    FROM online_retail_clean
    WHERE CustomerID IS NOT NULL
      AND CustomerID > 0
      AND Quantity > 0
      AND UnitPrice > 0
      AND InvoiceNo NOT LIKE 'C%'
    GROUP BY CustomerID
)
SELECT
    CASE
        WHEN order_count > 1 THEN 'Repeat Customer'
        ELSE 'One-Time Customer'
    END AS customer_type,
    COUNT(*) AS customer_count
FROM customer_orders
GROUP BY customer_type;


-- ------------------------------------------------------------
-- Q8. Repeat customer rate
-- ------------------------------------------------------------
WITH customer_orders AS (
    SELECT
        CustomerID,
        COUNT(DISTINCT InvoiceNo) AS order_count
    FROM online_retail_clean
    WHERE CustomerID IS NOT NULL
      AND CustomerID > 0
      AND Quantity > 0
      AND UnitPrice > 0
      AND InvoiceNo NOT LIKE 'C%'
    GROUP BY CustomerID
)
SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END) AS repeat_customers,
    SUM(CASE WHEN order_count = 1 THEN 1 ELSE 0 END) AS one_time_customers,
    ROUND(
        100.0 * SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0),
        2
    ) AS repeat_customer_rate_pct
FROM customer_orders;


-- ------------------------------------------------------------
-- Q9. Revenue by customer type
-- ------------------------------------------------------------
WITH customer_orders AS (
    SELECT
        CustomerID,
        COUNT(DISTINCT InvoiceNo) AS order_count
    FROM online_retail_clean
    WHERE CustomerID IS NOT NULL
      AND CustomerID > 0
      AND Quantity > 0
      AND UnitPrice > 0
      AND InvoiceNo NOT LIKE 'C%'
    GROUP BY CustomerID
),
customer_types AS (
    SELECT
        CustomerID,
        CASE
            WHEN order_count > 1 THEN 'Repeat Customer'
            ELSE 'One-Time Customer'
        END AS customer_type
    FROM customer_orders
)
SELECT
    ct.customer_type,
    ROUND(SUM(r.Quantity * r.UnitPrice), 2) AS total_revenue
FROM online_retail_clean AS r
JOIN customer_types AS ct
  ON r.CustomerID = ct.CustomerID
WHERE r.Quantity > 0
  AND r.UnitPrice > 0
  AND r.InvoiceNo NOT LIKE 'C%'
GROUP BY ct.customer_type
ORDER BY total_revenue DESC;


-- ------------------------------------------------------------
-- Q10. Revenue contribution from repeat customers
-- ------------------------------------------------------------
WITH customer_orders AS (
    SELECT
        CustomerID,
        COUNT(DISTINCT InvoiceNo) AS order_count
    FROM online_retail_clean
    WHERE CustomerID IS NOT NULL
      AND CustomerID > 0
      AND Quantity > 0
      AND UnitPrice > 0
      AND InvoiceNo NOT LIKE 'C%'
    GROUP BY CustomerID
),
customer_types AS (
    SELECT
        CustomerID,
        CASE
            WHEN order_count > 1 THEN 'Repeat Customer'
            ELSE 'One-Time Customer'
        END AS customer_type
    FROM customer_orders
),
revenue_by_type AS (
    SELECT
        ct.customer_type,
        SUM(r.Quantity * r.UnitPrice) AS revenue
    FROM online_retail_clean AS r
    JOIN customer_types AS ct
      ON r.CustomerID = ct.CustomerID
    WHERE r.Quantity > 0
      AND r.UnitPrice > 0
      AND r.InvoiceNo NOT LIKE 'C%'
    GROUP BY ct.customer_type
)
SELECT
    customer_type,
    ROUND(revenue, 2) AS revenue,
    ROUND(100.0 * revenue / NULLIF(SUM(revenue) OVER (), 0), 2)
        AS revenue_contribution_pct
FROM revenue_by_type
ORDER BY revenue DESC;


-- ------------------------------------------------------------
-- Q11. Top 10 customers by revenue
-- ------------------------------------------------------------
SELECT
    CustomerID,
    ROUND(SUM(Quantity * UnitPrice), 2) AS total_revenue,
    COUNT(DISTINCT InvoiceNo) AS total_orders
FROM online_retail_clean
WHERE CustomerID IS NOT NULL
  AND CustomerID > 0
  AND Quantity > 0
  AND UnitPrice > 0
  AND InvoiceNo NOT LIKE 'C%'
GROUP BY CustomerID
ORDER BY total_revenue DESC
LIMIT 10;


-- ------------------------------------------------------------
-- Q12. Cancellation analysis
-- ------------------------------------------------------------
SELECT
    COUNT(*) AS cancelled_records,
    COUNT(DISTINCT InvoiceNo) AS cancelled_invoices,
    SUM(ABS(Quantity)) AS cancelled_quantity
FROM online_retail_clean
WHERE InvoiceNo LIKE 'C%';


-- ------------------------------------------------------------
-- Q13. Cancellation invoice rate
-- Rate = cancelled invoice numbers / all distinct invoice numbers.
-- ------------------------------------------------------------
SELECT
    COUNT(DISTINCT CASE
        WHEN InvoiceNo LIKE 'C%' THEN InvoiceNo
    END) AS cancelled_invoices,
    COUNT(DISTINCT InvoiceNo) AS all_invoice_numbers,
    ROUND(
        100.0 * COUNT(DISTINCT CASE
            WHEN InvoiceNo LIKE 'C%' THEN InvoiceNo
        END) / NULLIF(COUNT(DISTINCT InvoiceNo), 0),
        2
    ) AS cancellation_invoice_rate_pct
FROM online_retail_clean;


-- ------------------------------------------------------------
-- Q14. Revenue by weekday
-- ------------------------------------------------------------
SELECT
    DAYNAME(InvoiceDate) AS weekday_name,
    DAYOFWEEK(InvoiceDate) AS weekday_number,
    ROUND(SUM(Quantity * UnitPrice), 2) AS total_revenue
FROM online_retail_clean
WHERE Quantity > 0
  AND UnitPrice > 0
  AND InvoiceNo NOT LIKE 'C%'
GROUP BY DAYNAME(InvoiceDate), DAYOFWEEK(InvoiceDate)
ORDER BY weekday_number;


-- ------------------------------------------------------------
-- Q15. Monthly active customers
-- ------------------------------------------------------------
SELECT
    DATE_FORMAT(InvoiceDate, '%Y-%m') AS sales_month,
    COUNT(DISTINCT CustomerID) AS total_customers
FROM online_retail_clean
WHERE CustomerID IS NOT NULL
  AND CustomerID > 0
  AND Quantity > 0
  AND UnitPrice > 0
  AND InvoiceNo NOT LIKE 'C%'
GROUP BY DATE_FORMAT(InvoiceDate, '%Y-%m')
ORDER BY sales_month;


-- ------------------------------------------------------------
-- Additional analysis: missing product descriptions
-- ------------------------------------------------------------
SELECT
    CASE
        WHEN Quantity > 0 THEN 'Positive Quantity'
        WHEN Quantity < 0 THEN 'Negative Quantity'
        WHEN Quantity = 0 THEN 'Zero Quantity'
    END AS transaction_type,
    COUNT(*) AS total_records,
    SUM(UnitPrice) AS total_unit_price
FROM online_retail_clean
WHERE Description IS NULL
   OR TRIM(Description) = ''
GROUP BY transaction_type;
