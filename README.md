# UPI Transaction Analysis Using PostgreSQL

## Overview

This project analyzes 250,000 UPI transaction records using PostgreSQL to uncover transaction patterns, banking performance, fraud indicators, and customer payment behavior.

The analysis covers the complete analytics workflow including data import, data cleaning, validation, exploratory data analysis (EDA), business reporting, and advanced SQL analytics using CTEs and Window Functions.

---

## Project Objectives

- Import and clean raw UPI transaction data
- Perform data quality validation checks
- Analyze transaction volume and value
- Evaluate transaction success and failure rates
- Identify top-performing merchant categories
- Analyze state-wise transaction activity
- Measure bank performance
- Monitor fraud-flagged transactions
- Apply advanced SQL analytical techniques

---

## Tools & Technologies

- PostgreSQL
- SQL
- pgAdmin 4
- VS Code SQLTools
- Git
- GitHub

---

## Dataset

**Dataset Name:** UPI Transactions 2024

**Source:**
https://www.kaggle.com/datasets/skullagos5246/upi-transactions-2024-dataset

**Dataset Size:** 250,000 Records

### Dataset Features

- Transaction ID
- Transaction Timestamp
- Transaction Type
- Merchant Category
- Transaction Amount
- Transaction Status
- Sender State
- Sender Bank
- Receiver Bank
- Age Group
- Device Type
- Network Type
- Fraud Flag
- Hour of Day
- Weekend Indicator

---

## Project Structure

```text
UPI-Transaction-Analysis/
│
├── dataset/
│   └── upi_transactions_2024.csv
│
├── sql/
│   ├── 01_database_setup.sql
│   ├── 02_staging_table.sql
│   ├── 03_data_verify.sql
│   ├── 04_data_cleaning.sql
│   ├── 05_business_analysis.sql
│   └── 06_advanced_analysis.sql
│
├── reports/
│   └── business_insights.md
│
├── screenshots/
│
└── README.md
```

---

## Data Cleaning & Validation

The following checks were performed:

- Data type conversion
- Missing value validation
- Duplicate transaction detection
- Timestamp standardization
- Fraud flag validation
- Weekend indicator conversion
- Transaction amount validation

### Validation Results

| Validation Check | Result |
|------------|------------|
| Imported Records | 250,000 |
| Cleaned Records | 250,000 |
| Duplicate IDs | 0 |
| Invalid Amounts | 0 |

---

## Business KPIs

| Metric | Result |
|----------|----------|
| Total Transactions | 250,000 |
| Total Transaction Value | ₹32,79,39,009 |
| Average Transaction Value | ₹1,311.76 |
| Successful Transactions | 237,624 |
| Failed Transactions | 12,376 |
| Success Rate | 95.05% |
| Failure Rate | 4.95% |
| Fraud Flagged Transactions | 480 |

---

## Analysis Performed

### Business Analysis

- Overall Business KPIs
- Success vs Failure Rate Analysis
- Transaction Type Performance
- Merchant Category Analysis
- State-wise Transaction Analysis
- Bank Performance Evaluation
- Peak Transaction Hour Analysis
- Weekday vs Weekend Analysis
- Fraud Monitoring Analysis
- Device & Network Performance Analysis

### Advanced SQL Analysis

- Monthly Transaction Trends
- Month-over-Month Growth Analysis
- Merchant Category Ranking
- Transaction Value Segmentation
- Running Transaction Totals
- 7-Day Rolling Average
- Fraud Rate by Merchant Category
- High Failure Rate Banks
- State Ranking by Transaction Value
- Hourly Success-Failure Analysis

---

## SQL Concepts Demonstrated

- Aggregate Functions
- GROUP BY
- ORDER BY
- CASE Statements
- Common Table Expressions (CTEs)
- Window Functions
- RANK()
- DENSE_RANK()
- LAG()
- FILTER()
- HAVING
- NULLIF()
- Running Totals
- Rolling Averages
- Conditional Aggregation
- Date & Time Functions

---

## Key Business Insights

- More than 95% of transactions were completed successfully.
- Fraud-flagged transactions accounted for less than 0.2% of total transactions.
- Merchant categories showed significant differences in transaction volumes and values.
- Transaction activity varied considerably across states.
- Certain banks consistently processed higher transaction volumes.
- Peak transaction activity was concentrated during specific hours of the day.
- Customer spending patterns differed between weekdays and weekends.

---

## Screenshots

### Overall KPI Query Output
![KPI Analysis](screenshots/kpi_analysis.png)

### Transaction Success vs Failure
![Success Rate](screenshots/success_failure_analysis.png)

### State-wise Transaction Analysis
![State Analysis](screenshots/state_analysis.png)

### Bank Performance Analysis
![Bank Analysis](screenshots/bank_performance.png)

### Merchant Category Ranking
![Merchant Analysis](screenshots/merchant_category_analysis.png)

### Fraud Analysis
![Fraud Analysis](screenshots/fraud_analysis.png)

### Advanced SQL - Month-over-Month Growth
![MoM Growth](screenshots/monthly_growth_analysis.png)

---

## How to Run

1. Install PostgreSQL.
2. Create the database.

```sql
CREATE DATABASE upi_analysis;
```

3. Run scripts in sequence:

```text
01_database_setup.sql
02_staging_table.sql
03_data_verify.sql
04_data_cleaning.sql
05_business_analysis.sql
06_advanced_analysis.sql
```

4. Import the CSV dataset.
5. Execute all analysis queries.

---

## Skills Demonstrated

- PostgreSQL
- SQL
- Data Cleaning
- Data Validation
- Exploratory Data Analysis (EDA)
- Business Analysis
- Data Quality Checks
- CTEs
- Window Functions
- Ranking Functions
- Analytical Reporting
- Business Intelligence

---

## Author

**Ashutosh Rastogi**

Aspiring Data Analyst | SQL | PostgreSQL | Data Analytics

LinkedIn: [Ashutosh Rastogi](https://www.linkedin.com/in/ashutosh-rastogi-199b15227)

