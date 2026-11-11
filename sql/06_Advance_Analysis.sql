--1. Monthly Transaction Analysis using CTEs
WITH monthly_summary AS (
    SELECT
        DATE_TRUNC(
            'month',
            transaction_timestamp
        )::DATE AS transaction_month,

        COUNT(*) AS total_transactions,

        ROUND(SUM(amount_inr), 2) AS total_value,

        ROUND(AVG(amount_inr), 2) AS average_amount,

        COUNT(*) FILTER (
            WHERE transaction_status = 'SUCCESS'
        ) AS successful_transactions

    FROM upi_transactions_clean

    GROUP BY DATE_TRUNC(
        'month',
        transaction_timestamp
    )
)

SELECT
    transaction_month,
    total_transactions,
    total_value,
    average_amount,

    ROUND(
        successful_transactions * 100.0 /
        NULLIF(total_transactions, 0),
        2
    ) AS success_rate

FROM monthly_summary
ORDER BY transaction_month;

--2. Month over month growth using lag()
WITH monthly_summary AS (
    SELECT
        DATE_TRUNC(
            'month',
            transaction_timestamp
        )::DATE AS transaction_month,

        SUM(amount_inr) AS monthly_value

    FROM upi_transactions_clean

    GROUP BY DATE_TRUNC(
        'month',
        transaction_timestamp
    )
),

monthly_comparison AS (
    SELECT
        transaction_month,
        monthly_value,

        LAG(monthly_value) OVER (
            ORDER BY transaction_month
        ) AS previous_month_value

    FROM monthly_summary
)

SELECT
    transaction_month,

    ROUND(monthly_value, 2) AS current_month_value,

    ROUND(previous_month_value, 2) AS previous_month_value,

    ROUND(
        monthly_value - previous_month_value,
        2
    ) AS value_difference,

    ROUND(
        (
            monthly_value - previous_month_value
        ) * 100.0 /
        NULLIF(previous_month_value, 0),
        2
    ) AS growth_percentage

FROM monthly_comparison
ORDER BY transaction_month;

--3. Rank Merchant Categories
SELECT
    merchant_category,

    COUNT(*) AS total_transactions,

    ROUND(SUM(amount_inr), 2) AS total_value,

    ROUND(AVG(amount_inr), 2) AS average_value,

    RANK() OVER (
        ORDER BY SUM(amount_inr) DESC
    ) AS value_rank,

    DENSE_RANK() OVER (
        ORDER BY COUNT(*) DESC
    ) AS volume_rank

FROM upi_transactions_clean

GROUP BY merchant_category
ORDER BY value_rank;

--4. Transaction amount segmentation using case
WITH transaction_segments AS (
    SELECT
        transaction_id,
        amount_inr,

        CASE
            WHEN amount_inr < 500
                THEN 'Low Value'

            WHEN amount_inr < 2000
                THEN 'Medium Value'

            WHEN amount_inr < 5000
                THEN 'High Value'

            ELSE 'Very High Value'
        END AS amount_segment

    FROM upi_transactions_clean
)

SELECT
    amount_segment,

    COUNT(*) AS total_transactions,

    ROUND(SUM(amount_inr), 2) AS total_value,

    ROUND(AVG(amount_inr), 2) AS average_amount,

    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER(),
        2
    ) AS transaction_percentage

FROM transaction_segments

GROUP BY amount_segment

ORDER BY
    CASE amount_segment
        WHEN 'Low Value' THEN 1
        WHEN 'Medium Value' THEN 2
        WHEN 'High Value' THEN 3
        WHEN 'Very High Value' THEN 4
    END;

--5. Running Transcation value by day
WITH daily_summary AS (
    SELECT
        transaction_timestamp::DATE AS transaction_date,
        COUNT(*) AS daily_transactions,
        SUM(amount_inr) AS daily_value

    FROM upi_transactions_clean

    GROUP BY transaction_timestamp::DATE
)

SELECT
    transaction_date,
    daily_transactions,

    ROUND(daily_value, 2) AS daily_value,

    ROUND(
        SUM(daily_value) OVER (
            ORDER BY transaction_date
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
        ),
        2
    ) AS cumulative_value

FROM daily_summary
ORDER BY transaction_date;

--6. Seven day rolling average
WITH daily_summary AS (
    SELECT
        transaction_timestamp::DATE AS transaction_date,
        COUNT(*) AS daily_transactions

    FROM upi_transactions_clean

    GROUP BY transaction_timestamp::DATE
)

SELECT
    transaction_date,
    daily_transactions,

    ROUND(
        AVG(daily_transactions) OVER (
            ORDER BY transaction_date
            ROWS BETWEEN 6 PRECEDING
            AND CURRENT ROW
        ),
        2
    ) AS rolling_7_day_average

FROM daily_summary
ORDER BY transaction_date;

--7.  Fraud Flag rate by merchant category
SELECT
    merchant_category,

    COUNT(*) AS total_transactions,

    COUNT(*) FILTER (
        WHERE fraud_flag = TRUE
    ) AS flagged_transactions,

    ROUND(
        COUNT(*) FILTER (
            WHERE fraud_flag = TRUE
        ) * 100.0 / NULLIF(COUNT(*), 0),
        3
    ) AS flagged_percentage,

    ROUND(
        SUM(amount_inr) FILTER (
            WHERE fraud_flag = TRUE
        ),
        2
    ) AS flagged_transaction_value

FROM upi_transactions_clean

GROUP BY merchant_category

ORDER BY flagged_percentage DESC;

--8. Banks with high failure rates
SELECT
    sender_bank,

    COUNT(*) AS total_transactions,

    COUNT(*) FILTER (
        WHERE transaction_status = 'FAILED'
    ) AS failed_transactions,

    ROUND(
        COUNT(*) FILTER (
            WHERE transaction_status = 'FAILED'
        ) * 100.0 / COUNT(*),
        2
    ) AS failure_rate

FROM upi_transactions_clean

GROUP BY sender_bank

HAVING COUNT(*) >= 100

ORDER BY failure_rate DESC;

--9. Ranking states by average transaction value
WITH state_summary AS (
    SELECT
        sender_state,
        COUNT(*) AS total_transactions,
        AVG(amount_inr) AS average_amount

    FROM upi_transactions_clean

    GROUP BY sender_state
)

SELECT
    sender_state,
    total_transactions,

    ROUND(average_amount, 2) AS average_amount,

    DENSE_RANK() OVER (
        ORDER BY average_amount DESC
    ) AS average_value_rank

FROM state_summary

ORDER BY average_value_rank;

--10. Success and Failure rate by hour
SELECT
    hour_of_day,

    COUNT(*) AS total_transactions,

    COUNT(*) FILTER (
        WHERE transaction_status = 'SUCCESS'
    ) AS successful_transactions,

    COUNT(*) FILTER (
        WHERE transaction_status = 'FAILED'
    ) AS failed_transactions,

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

GROUP BY hour_of_day

ORDER BY hour_of_day;