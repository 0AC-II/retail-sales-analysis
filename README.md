# Retail Sales Performance Analysis Using Python, SQL, and Power BI

## Objective

To analyze retail sales data in order to identify revenue drivers, profitability patterns, and underperforming areas across products, regions, and customer segments.

This project demonstrates an end-to-end analytics workflow from data cleaning to business-ready dashboarding.

---

## Project Overview

This analysis follows a structured pipeline:

1. Data Cleaning (Python)
2. Database Ingestion (MySQL)
3. SQL-Based Business Analysis
4. Interactive Dashboard (Power BI)
5. Business Insights & Impact

The focus is decision support, not just visualization.

---

## Dataset

Retail transaction dataset containing:

* Transaction ID
* Date
* Customer ID
* Gender
* Age
* Product Category
* Quantity
* Price per Unit
* Total Amount

Records: **1,000 transactions**
Time Period: **January 2023 – January 2024**

---

## 1. Data Cleaning (Python)

Performed using pandas.

### Key Steps

* Converted date column to datetime format

* Standardized column names to snake_case

* Checked and confirmed no duplicate records

* Verified revenue integrity:

  `Total Amount = Quantity × Price per Unit`

* Confirmed no missing values in critical fields

Example cleaning snippet:

```python
import pandas as pd

df = pd.read_csv("retail_sales_dataset.csv")

df.columns = [
    "transaction_id",
    "date",
    "customer_id",
    "gender",
    "age",
    "product_category",
    "quantity",
    "price_per_unit",
    "total_amount"
]

df["date"] = pd.to_datetime(df["date"])

df.to_csv("retail_sales_clean.csv", index=False)
```

---

## 2. Loading Data into MySQL

### Database Setup

```sql
CREATE DATABASE retail_analytics;
USE retail_analytics;

CREATE TABLE retail_sales (
    transaction_id INT PRIMARY KEY,
    date DATE,
    customer_id VARCHAR(50),
    gender VARCHAR(10),
    age INT,
    product_category VARCHAR(50),
    quantity INT,
    price_per_unit INT,
    total_amount INT
);
```

### Data Ingestion

```sql
LOAD DATA INFILE 'path/to/retail_sales_clean.csv'
INTO TABLE retail_sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
```

This enables SQL-based analysis and Power BI integration.

---

## 3. SQL Analysis

### Top Revenue-Generating Product Categories

```sql
SELECT
    product_category,
    SUM(total_amount) AS total_revenue
FROM retail_sales
GROUP BY product_category
ORDER BY total_revenue DESC;
```

Result:

| Category    | Revenue   |
| ----------- | --------- |
| Electronics | $ 156,905 |
| Clothing    | $ 155,580 |
| Beauty      | $ 143,515 |

---

### Monthly Sales Trend

```sql
SELECT
    DATE_FORMAT(date, '%Y-%m') AS month,
    SUM(total_amount) AS monthly_sales
FROM retail_sales
GROUP BY month
ORDER BY month;
```

Peak months observed: **May and October**
Weak months: **March and September**

---

### High-Volume, Low-Revenue Transactions

```sql
SELECT
    transaction_id,
    product_category,
    quantity,
    total_amount
FROM retail_sales
WHERE quantity >= 3
ORDER BY total_amount ASC
LIMIT 10;
```

Repeated transactions with 3 units generating only 75 total revenue indicate potential pricing inefficiencies.

---

### Average Order Value (AOV) by Gender

```sql
SELECT
    gender,
    ROUND(AVG(total_amount), 2) AS avg_order_value
FROM retail_sales
GROUP BY gender;
```

| Gender | AOV      |
| ------ | -------- |
| Male   | $ 455.43 |
| Female | $ 456.55 |

No significant segmentation difference.

---

### Revenue Distribution (Concentration Check)

```sql
SELECT
    product_category,
    COUNT(*) AS transactions,
    SUM(total_amount) AS total_revenue,
    ROUND(SUM(total_amount) /
          (SELECT SUM(total_amount) FROM retail_sales) * 100, 2)
          AS revenue_percentage
FROM retail_sales
GROUP BY product_category
ORDER BY total_revenue DESC;
```

Revenue is evenly distributed across categories (~34% each), indicating diversification.

---

### Age-Based Spending Behavior

```sql
SELECT
    CASE
        WHEN age < 30 THEN 'Under 30'
        WHEN age BETWEEN 30 AND 45 THEN '30–45'
        ELSE '46+'
    END AS age_group,
    ROUND(AVG(total_amount), 2) AS avg_spend
FROM retail_sales
GROUP BY age_group
ORDER BY avg_spend DESC;
```

Younger customers show higher average spend per transaction.

---

## 4. Power BI Dashboard

Connected directly to MySQL database.

### Core DAX Measures

```DAX
Total Sales =
SUM(retail_sales[total_amount])

Total Orders =
COUNT(retail_sales[transaction_id])

Average Order Value =
DIVIDE([Total Sales], [Total Orders])

Total Quantity =
SUM(retail_sales[quantity])
```

### Age Group (Calculated Column)

```DAX
Age Group =
SWITCH(
    TRUE(),
    retail_sales[age] < 30, "Under 30",
    retail_sales[age] <= 45, "30–45",
    "46+"
)
```

### Dashboard Components

* KPI Cards:

  * Total Sales
  * Total Orders
  * Average Order Value
  * Total Quantity Sold

* Line Chart:

  * Monthly Sales Trend

* Bar Charts:

  * Sales by Product Category
  * AOV by Gender
  * AOV by Age Group

* Interactive Filters:

  * Date
  * Product Category
  * Gender

---

## Key Insights

* Revenue is evenly distributed across product categories, indicating a diversified sales base.
* Sales exhibit seasonality, with peaks in May and October.
* Several high-volume transactions generate disproportionately low revenue, suggesting pricing inefficiencies.
* Gender has minimal impact on spending behavior.
* Younger customers demonstrate higher average order value.

---

## Business Impact

This analysis supports data-driven decisions around product prioritization, pricing optimization, regional strategy, and customer targeting.

---

## Tools Used

* Python (pandas, matplotlib)
* MySQL
* SQL
* Power BI (DAX)

---

## Project Structure

```
retail-sales-analysis/
│
├── data/
│   ├── retail_sales_dataset.csv
│   └── cleaned_retail_dataset.csv
│
├── notebooks/
│   └── data_cleaning_and_eda.ipynb
│
├── sql/
│   └── analysis_queries.sql
│
├── dashboard/
│   └── retail_analysis_dashboard.pbix
│
└── README.md
```

---
