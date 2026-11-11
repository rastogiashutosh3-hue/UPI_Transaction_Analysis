-- 02_staging_table.sql

DROP TABLE IF EXISTS upi_staging;

-- Create staging table matching the 17 CSV columns
CREATE TABLE upi_staging (

    transaction_id TEXT,
    timestamp TEXT,
    transaction_type TEXT,
    merchant_category TEXT,
    amount_inr TEXT,
    transaction_status TEXT,
    sender_age_group TEXT,
    receiver_age_group TEXT,
    sender_state TEXT,
    sender_bank TEXT,
    receiver_bank TEXT,
    device_type TEXT,
    network_type TEXT,
    fraud_flag TEXT,
    hour_of_day TEXT,
    day_of_week TEXT,
    is_weekend TEXT

);

copy upi_staging 
FROM 'D:\Data_Analyst\SQL\UPI_Transaction_Analysis\dataset\upi_transactions_2024.csv'
WITH (FORMAT CSV, HEADER TRUE, ENCODING 'UTF8');