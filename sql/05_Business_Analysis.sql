--1. Overall business KPIs
SELECT
    COUNT(*) AS total_transactions,

    COUNT(DISTINCT transaction_id)
        AS unique_transactions,

    ROUND(SUM(amount_inr), 2)
        AS total_transaction_value,

    ROUND(AVG(amount_inr), 2)
        AS average_transaction_value,

    ROUND(MIN(amount_inr), 2)
        AS minimum_transaction,

    ROUND(MAX(amount_inr), 2)
        AS maximum_transaction

FROM upi_transactions_clean;

--2. Success vs Failure Rates
SELECT
    transaction_status,

    COUNT(*) AS total_transactions,

    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS percentage

FROM upi_transactions_clean

GROUP BY transaction_status

ORDER BY total_transactions DESC;

--3. Transaction Types Performance
SELECT
    transaction_type,

    COUNT(*) AS total_transactions,

    ROUND(SUM(amount_inr), 2)
        AS total_transaction_value,

    ROUND(AVG(amount_inr), 2)
        AS average_transaction_value

FROM upi_transactions_clean

GROUP BY transaction_type

ORDER BY total_transactions DESC;

--4. Top 10 merchant categories
SELECT
    merchant_category,

    COUNT(*) AS transaction_count,

    ROUND(SUM(amount_inr), 2)
        AS total_revenue,

    ROUND(AVG(amount_inr), 2)
        AS average_spending

FROM upi_transactions_clean

GROUP BY merchant_category

ORDER BY total_revenue DESC

LIMIT 10;

--5. State wise transaction analysis
SELECT
    sender_state,

    COUNT(*) AS total_transactions,

    ROUND(SUM(amount_inr), 2)
        AS total_transaction_value,

    ROUND(AVG(amount_inr), 2)
        AS average_transaction_value,
    round(
        count(*)*100.0/
        sum(count(*)) OVER(),
        2
    ) AS transaction_percentage

FROM upi_transactions_clean

GROUP BY sender_state

ORDER BY total_transaction_value DESC;

--6. Bank Performance
SELECT
    sender_bank,

    COUNT(*) AS total_transactions,

    ROUND(SUM(amount_inr), 2)
        AS total_transaction_value,

    ROUND(
        COUNT(*) FILTER (
            WHERE transaction_status = 'SUCCESS'
        ) * 100.0 / COUNT(*),
        2
    ) AS success_rate,

    ROUND(
        COUNT(*) FILTER (
            WHERE transaction_status = 'FAILED'
        ) * 100.0 / COUNT(*),
        2
    ) AS failure_rate

FROM upi_transactions_clean

GROUP BY sender_bank

ORDER BY total_transactions DESC;

--7. Peak Transcation hours
SELECT
    hour_of_day,

    COUNT(*) AS total_transactions,

    ROUND(SUM(amount_inr), 2)
        AS total_transaction_value

FROM upi_transactions_clean

GROUP BY hour_of_day

ORDER BY total_transactions DESC;

--8. Weekdays vs Weekends Analysis
SELECT
    CASE
        WHEN is_weekend = TRUE THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_category,

    COUNT(*) AS total_transactions,

    ROUND(SUM(amount_inr), 2)
        AS total_transaction_value,

    ROUND(AVG(amount_inr), 2)
        AS average_transaction_value

FROM upi_transactions_clean

GROUP BY is_weekend

ORDER BY total_transactions DESC;

--9. Fraud Analysis
SELECT
    fraud_flag,

    COUNT(*) AS total_transactions,

    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        3
    ) AS fraud_percentage,

    ROUND(SUM(amount_inr), 2)
        AS total_transaction_value

FROM upi_transactions_clean

GROUP BY fraud_flag
ORDER BY fraud_flag DESC;

--10. Device and network analysis
SELECT
    device_type,

    network_type,

    COUNT(*) AS total_transactions,

    ROUND(AVG(amount_inr), 2)
        AS average_transaction_value,

    COUNT(*) FILTER (
        WHERE transaction_status = 'FAILED'
    ) AS failed_transactions

FROM upi_transactions_clean

GROUP BY device_type, network_type

ORDER BY total_transactions DESC;

--P2p vs p2m
SELECT
    transaction_type,
    COUNT(*) AS total_transactions,
    ROUND(SUM(amount_inr), 2) AS total_value,
    ROUND(AVG(amount_inr), 2) AS average_value
FROM upi_transactions_clean
GROUP BY transaction_type
ORDER BY total_transactions DESC;

--merchant category analysis
SELECT
    merchant_category,
    COUNT(*) AS total_transactions,
    ROUND(SUM(amount_inr), 2) AS total_value,
    ROUND(AVG(amount_inr), 2) AS average_spending
FROM upi_transactions_clean
GROUP BY merchant_category
ORDER BY total_value DESC;