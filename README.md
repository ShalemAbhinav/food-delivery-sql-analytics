# Food Delivery SQL Analytics

## Project Overview
This project analyzes food delivery operations and restaurant data to uncover insights related to delivery efficiency, rider performance, and restaurant quality versus pricing.  
The goal is to demonstrate end-to-end data analytics skills using **Python for ETL** and **advanced SQL for analysis**, with a focus on business-relevant insights rather than purely technical metrics.

---

## Data Sources
- **Zomato Bangalore Restaurants Dataset** (Kaggle)
- **Food Delivery Operations Dataset** containing orders, delivery partners, and delivery times

The datasets originate from different sources and do **not share a reliable common key**.  
To maintain data integrity, restaurant and delivery datasets were analyzed as **separate analytical domains** rather than forcing artificial joins.

---

## Data Cleaning & ETL
Python was used to clean and preprocess the raw datasets before loading them into MySQL.

Key cleaning steps included:
- Handling missing and invalid ratings
- Converting text-based numeric fields to proper numeric formats
- Normalizing categorical columns (vehicle type, order type)
- Removing inconsistent and duplicate records
- Splitting delivery data into logical tables (orders, delivery partners, delivery details)

Cleaned datasets are stored in `data/cleaned/` and used for all SQL analysis.

---

## Database Schema
The database schema was designed explicitly for analytical queries and consists of:
- `restaurants`
- `orders`
- `delivery_partners`
- `delivery_details`

The schema definition is available in `sql/01_schema.sql`.

---

## SQL Techniques Used
This project intentionally demonstrates **intermediate to advanced SQL**, including:
- Common Table Expressions (CTEs)
- Window functions (`RANK`, `NTILE`, rolling averages)
- Percentile and distribution analysis
- Outlier detection using statistical thresholds
- Variance analysis for consistency measurement
- Conditional aggregation and case-based bucketing

Basic and advanced queries are separated for clarity.

---

## Key Insights
Some of the business insights derived from the analysis include:

- Higher-rated delivery partners tend to complete deliveries faster on average.
- Delivery time varies significantly by vehicle type, indicating operational trade-offs.
- A small subset of delivery partners contributes disproportionately to delayed deliveries.
- Some restaurants are priced significantly higher than area averages without corresponding rating advantages.
- Restaurant ratings and costs show strong geographic variation across areas.

These insights can help guide operational optimization and pricing strategy decisions.

---

## Project Structure

```text
food-delivery-sql-analytics/
├── data/
│   ├── raw/                  # Raw datasets (excluded from version control due to size)
│   └── cleaned/              # Cleaned datasets used for analysis
│
├── etl/
│   ├── restaurant_cleaning.py
│   └── delivery_cleaning.py
│
├── sql/
│   ├── 01_schema.sql
│   ├── 02_basic_restaurant_analysis.sql
│   ├── 03_basic_delivery_analysis.sql
│   ├── 04_advanced_delivery_analysis.sql
│   └── 05_advanced_restaurant_analysis.sql
│
├── dashboards/
│   └── powerbi_dashboard.pbix   # Optional
│
├── README.md
└── .gitignore
```

---

## Tools & Technologies
- Python (Pandas) for data cleaning
- MySQL for data storage and analysis
- Advanced SQL (CTEs, window functions)
- Git & GitHub for version control

---

## Notes
Raw datasets were excluded from version control due to GitHub file size limits.  
Data sources are documented for reproducibility.
