-- DATA VALIDATION: Count transactions occurring prior to user signup date
-- Implication: Data logging sync errors or backdated records. We flag or exclude them in strict lifecycle analyses.
SELECT COUNT(*) AS invalid_txns_before_signup
FROM transactions t
JOIN users u ON t.user_id = u.user_id
WHERE t.txn_date < u.signup_date;

-- (a) Total transaction value and count by product
SELECT 
    product,
    COUNT(txn_id) AS total_transactions,
    SUM(amount) AS total_value
FROM transactions
GROUP BY product
ORDER BY total_value DESC;

-- (b) Top five counties by transaction value
SELECT 
    u.county,
    SUM(t.amount) AS total_value
FROM transactions t
JOIN users u ON t.user_id = u.user_id
GROUP BY u.county
ORDER BY total_value DESC
LIMIT 5;

-- (c) Monthly transaction value and a running total using strftime and window function
SELECT 
    strftime('%Y-%m', txn_date) AS month,
    SUM(amount) AS monthly_value,
    SUM(SUM(amount)) OVER (ORDER BY strftime('%Y-%m', txn_date)) AS running_total_value
FROM transactions
GROUP BY month
ORDER BY month;

-- (d) Value by acquisition channel using a JOIN
SELECT 
    u.acquisition_channel,
    SUM(t.amount) AS total_value
FROM transactions t
JOIN users u ON t.user_id = u.user_id
GROUP BY u.acquisition_channel
ORDER BY total_value DESC;

-- (e) Top ten users by transaction value with RANK()
WITH UserTotals AS (
    SELECT 
        user_id,
        SUM(amount) AS total_value
    FROM transactions
    GROUP BY user_id
)
SELECT 
    user_id,
    total_value,
    RANK() OVER (ORDER BY total_value DESC) AS user_rank
FROM UserTotals
LIMIT 10;

-- (f) Products whose average transaction exceeds KES 1,300 using HAVING
SELECT 
    product,
    AVG(amount) AS avg_txn_amount
FROM transactions
GROUP BY product
HAVING AVG(amount) > 1300
ORDER BY avg_txn_amount DESC;

-- (g) Number of users in each value tier using a CTE and CASE WHEN
WITH UserValue AS (
    SELECT 
        user_id,
        SUM(amount) AS user_total
    FROM transactions
    GROUP BY user_id
)
SELECT 
    CASE 
        WHEN user_total >= 10000 THEN 'High'
        WHEN user_total >= 4000 THEN 'Medium'
        ELSE 'Low'
    END AS value_tier,
    COUNT(user_id) AS user_count
FROM UserValue
GROUP BY value_tier
ORDER BY user_count DESC;

-- (h) Month-over-month change in active users using LAG
WITH MonthlyActive AS (
    SELECT 
        strftime('%Y-%m', txn_date) AS month,
        COUNT(DISTINCT user_id) AS active_users
    FROM transactions
    GROUP BY month
)
SELECT 
    month,
    active_users,
    LAG(active_users, 1) OVER (ORDER BY month) AS prev_month_active,
    active_users - LAG(active_users, 1) OVER (ORDER BY month) AS mom_user_change,
    ROUND(((active_users - LAG(active_users, 1) OVER (ORDER BY month)) * 100.0) / LAG(active_users, 1) OVER (ORDER BY month), 2) AS mom_growth_pct
FROM MonthlyActive;
