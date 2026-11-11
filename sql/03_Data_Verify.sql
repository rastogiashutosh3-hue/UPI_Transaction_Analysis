SELECT count(*)  AS total_records
FROM upi_staging;

SELECT * FROM upi_staging limit 10;

SELECT column_name
FROM information_schema.columns
WHERE table_name = 'upi_staging'
ORDER BY ordinal_position;

--checking transaction types
SELECT
    transaction_type,
    COUNT(*) AS total_transactions
FROM upi_staging
GROUP BY transaction_type
ORDER BY total_transactions DESC;

--checking duplicate transaction ids
SELECT
    transaction_id,
    COUNT(*) AS duplicate_count
FROM upi_staging
GROUP BY transaction_id
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

--checking missing values
SELECT
    COUNT(*) FILTER (
        WHERE transaction_id IS NULL OR TRIM(transaction_id) = ''
    ) AS missing_transaction_id,

    COUNT(*) FILTER (
        WHERE timestamp IS NULL OR TRIM(timestamp) = ''
    ) AS missing_timestamp,

    COUNT(*) FILTER (
        WHERE amount_inr IS NULL OR TRIM(amount_inr) = ''
    ) AS missing_amount,

    COUNT(*) FILTER (
        WHERE transaction_status IS NULL OR TRIM(transaction_status) = ''
    ) AS missing_status,

    COUNT(*) FILTER (
        WHERE sender_bank IS NULL OR TRIM(sender_bank) = ''
    ) AS missing_sender_bank,

    COUNT(*) FILTER (
        WHERE receiver_bank IS NULL OR TRIM(receiver_bank) = ''
    ) AS missing_receiver_bank

FROM upi_staging;

--checking invalid transaction amounts
SELECT *
FROM upi_staging
WHERE amount_inr IS NULL
   OR TRIM(amount_inr) !~ '^[0-9]+(\.[0-9]+)?$';

--checking transaction status distribution
SELECT
    UPPER(TRIM(transaction_status)) AS status,
    COUNT(*) AS total_transactions
FROM upi_staging
GROUP BY 1
ORDER BY 2 DESC;

--checking fraud flags
SELECT
    fraud_flag,
    COUNT(*) AS total_records
FROM upi_staging
GROUP BY fraud_flag
ORDER BY fraud_flag;

--checking weekend values
SELECT
    is_weekend,
    count(*) AS total_records
FROM upi_staging
GROUP BY is_weekend;

