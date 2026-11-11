-- UPI TRANSACTION ANALYSIS

DROP TABLE IF EXISTS upi_transactions_clean;

CREATE TABLE upi_transactions_clean AS

SELECT
    TRIM(transaction_id)::VARCHAR(30) AS transaction_id,

    TRIM(timestamp)::TIMESTAMP AS transaction_timestamp,

    UPPER(TRIM(transaction_type)) AS transaction_type,

    INITCAP(TRIM(merchant_category)) AS merchant_category,

    TRIM(amount_inr)::NUMERIC(12,2) AS amount_inr,

    UPPER(TRIM(transaction_status)) AS transaction_status,

    TRIM(sender_age_group) AS sender_age_group,

    TRIM(receiver_age_group) AS receiver_age_group,

    INITCAP(TRIM(sender_state)) AS sender_state,

    UPPER(TRIM(sender_bank)) AS sender_bank,

    UPPER(TRIM(receiver_bank)) AS receiver_bank,

    UPPER(TRIM(device_type)) AS device_type,

    UPPER(TRIM(network_type)) AS network_type,

    CASE
        WHEN TRIM(fraud_flag) = '1' THEN TRUE
        ELSE FALSE
    END AS fraud_flag,

    TRIM(hour_of_day)::SMALLINT AS hour_of_day,

    INITCAP(TRIM(day_of_week)) AS day_of_week,

    CASE
        WHEN TRIM(is_weekend) = '1' THEN TRUE
        ELSE FALSE
    END AS is_weekend

FROM upi_staging

WHERE transaction_id IS NOT NULL
  AND timestamp IS NOT NULL
  AND amount_inr IS NOT NULL
  AND TRIM(amount_inr) ~ '^[0-9]+(\.[0-9]+)?$'
  AND TRIM(timestamp) ~
      '^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}$';

--checking data types
SELECT
    column_name,
    data_type
FROM information_schema.columns
WHERE table_name = 'upi_transactions_clean'
ORDER BY ordinal_position;

--checking clean records
SELECT * FROM upi_transactions_clean
LIMIT 20;

--adding primary key
ALTER TABLE upi_transactions_clean
ADD PRIMARY KEY (transaction_id);

CREATE INDEX idx_upi_timestamp
ON upi_transactions_clean(transaction_timestamp);

CREATE INDEX idx_upi_status
ON upi_transactions_clean(transaction_status);

CREATE INDEX idx_upi_sender_bank
ON upi_transactions_clean(sender_bank);

CREATE INDEX idx_upi_fraud
ON upi_transactions_clean(fraud_flag);

--final
SELECT
    COUNT(*) AS cleaned_records,
    COUNT(DISTINCT transaction_id) AS unique_transactions,
    ROUND(SUM(amount_inr), 2) AS total_transaction_value,
    ROUND(AVG(amount_inr), 2) AS average_transaction_value
FROM upi_transactions_clean;