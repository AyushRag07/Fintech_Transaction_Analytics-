Select* 
from accounts;

Select* 
from customers;

Select* 
from transactions;

-- Q1. Which customers contribute the highest transaction volume?


with customer_volume as 
(Select cc.customer_id, sum(tc.amount) as total_vol
from accounts as ac
join customers as cc
	on ac.customer_id = cc.customer_id 
join transactions as tc
	on ac.account_id = tc.account_id
Group by cc.customer_id
),
ranked_customers as
(
select customer_id, total_vol,
RANK() OVER (ORDER BY total_vol DESC) as customer_rank,
PERCENT_RANK() OVER(ORDER BY total_vol DESC) as pct_rank
from customer_volume )

SELECT 
    customer_id,
    total_vol,
    customer_rank,
    ROUND(pct_rank, 2) AS pct_rank
FROM ranked_customers
WHERE pct_rank <= 0.10
ORDER BY total_vol DESC;

-- Q2. What are the monthly transaction trends across 2023–2024?

with total_monthly_volume as (
SELECT
YEAR (transaction_date) as year_,
MONTH (transaction_date) as month_,
sum(amount) as total_amount
from transactions
where transaction_status = 'Success'
group by year_, month_
),

monthly_trends as (
select 
	year_,
    month_,
    total_amount,
    lag(total_amount) over( order by year_,month_)
    as previous_month_amount
from total_monthly_volume
)

select 
	year_,
    month_,
    total_amount,
    previous_month_amount,
    ROUND(
        ((total_amount - previous_month_amount)
        / previous_month_amount) * 100,
        2
    ) AS growth_percentage
from monthly_trends
order by year_,month_;
    
-- Q3. Which cities generate the highest banking activity?

WITH city_activity AS (
    SELECT
        c.city,
        COUNT(*) AS total_transactions
    FROM customers c
    JOIN accounts a
        ON c.customer_id = a.customer_id
    JOIN transactions t
        ON a.account_id = t.account_id
    GROUP BY c.city
)

SELECT
    city,
    total_transactions,
    RANK() OVER(ORDER BY total_transactions DESC) AS city_rank
FROM city_activity;

-- 4. Which customers became dormant over time?

with last_transaction as
(
Select a.customer_id, max(t.transaction_date) as last_t
from accounts as a
join transactions as t
		on a.account_id = t.account_id
group by a.customer_id
)

Select 
	customer_id,
    last_t,
    datediff(CURDATE(), last_t) as days_inactive,
    case 
		when datediff(CURDATE(), last_t) <=30 then 'Active'
        when datediff(CURDATE(), last_t) <=60 then 'At Risk'
        else 'Dormant'
    end as customer_status
from last_transaction;

-- 5. Detect suspicious or fraud-like transactions.

WITH suspicious_tran as (
select account_id, transaction_id, transaction_date, amount,
case 
	when amount > 50000 then 'High Value'
    when hour(transaction_date) between 0 and 4 then 'midnight tranaction'
    else 'Normal'
END as risk_flag
from transactions
)

select * 
from suspicious_tran
where risk_flag <> 'Normal';
    

-- Q6. What is the running balance trend for each account?

WITH balance_trend AS (
    SELECT
        account_id,
        transaction_date,
        running_balance,
        LAG(running_balance) OVER(
            PARTITION BY account_id
            ORDER BY transaction_date
        ) AS previous_balance
    FROM transactions
)

SELECT *,
       CASE
           WHEN running_balance > previous_balance
               THEN 'Increasing'
           WHEN running_balance < previous_balance
               THEN 'Decreasing'
           ELSE 'No Change'
       END AS trend
FROM balance_trend;

-- Q7. Which merchants/categories receive the highest spending?
    
with shopping_ as
(
Select transaction_category, merchant, sum(amount) as total_,
case 
	when merchant = 'Salary Deposit' then 'Remove'
    when merchant = 'Suspicious Transfer' then 'Remove'
    else 'Keep'
    end as filtering_
from transactions
where transaction_type = 'Debit'
group by transaction_category, merchant
)

Select *
from shopping_
where filtering_ <> 'Remove'
order by total_ DESC;

WITH merchant_spending AS (
    SELECT
        merchant,
        transaction_category,
        SUM(amount) AS total_spent
    FROM transactions
    WHERE transaction_type = 'Debit'
    GROUP BY merchant, transaction_category
)

SELECT *,
       RANK() OVER(ORDER BY total_spent DESC) AS merchant_rank
FROM merchant_spending;

-- 8. How does weekend spending compare to weekday spending?

select dayname(transaction_date) as Weekday, sum(amount) as total_
from transactions
WHERE transaction_type = 'Debit'
group by Weekday;


-- Q9.What percentage of customers are repeat vs one-time users?

WITH table_join AS (
    SELECT 
		a.customer_id,
        a.account_id,
        t.running_balance,
        t.transaction_date
    FROM accounts a
    JOIN transactions t
        ON a.account_id = t.account_id
)

SELECT
    customer_id,
    account_id,
    MIN(running_balance) AS minimum_balance,
    MAX(running_balance) AS maximum_balance,
    MAX(running_balance) - MIN(running_balance) AS balance_growth
FROM table_join
GROUP BY customer_id, account_id
ORDER BY balance_growth DESC;

-- Q10. Identify the top spending customer every month.

WITH monthly_spend AS (
    SELECT
        a.customer_id,
        YEAR(t.transaction_date) AS yr,
        MONTH(t.transaction_date) AS mn,
        SUM(t.amount) AS total_spend
    FROM accounts a
    JOIN transactions t
        ON a.account_id = t.account_id
    WHERE t.transaction_type = 'Debit'
    GROUP BY
        a.customer_id,
        YEAR(t.transaction_date),
        MONTH(t.transaction_date)
),
ranked_customers AS (
    SELECT *,
           RANK() OVER(
               PARTITION BY yr, mn
               ORDER BY total_spend DESC
           ) AS rnk
    FROM monthly_spend
)
SELECT
    yr,
    mn,
    customer_id,
    total_spend
FROM ranked_customers
WHERE rnk <= 3
ORDER BY yr, mn;







    


