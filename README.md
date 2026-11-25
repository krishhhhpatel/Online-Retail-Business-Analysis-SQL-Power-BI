# Online Retail Business Analysis | SQL & Power BI

An end-to-end data analytics project using a real-world online retail dataset containing approximately 541,909 transaction records. This project uses SQL and Microsoft Power BI to analyse sales performance, customer behaviour, product performance, and business trends.

## Project Overview

The objective of this project was to transform raw retail transaction data into meaningful business insights using SQL and interactive Power BI dashboards.

## Tools & Technologies

- MySQL
- SQL
- Microsoft Power BI
- DAX
- phpMyAdmin
- XAMPP
- ODBC Connector

## What I Built

### 1. Database Setup and Data Preparation

- Imported approximately 541,909 retail transaction records into MySQL.
- Created and managed database tables using phpMyAdmin.
- Organised the data for SQL-based business analysis.
- Connected the MySQL database to Power BI using an ODBC connection.

### 2. SQL Business Analysis

- Wrote SQL queries to answer 15 business-related questions.
- Analysed monthly revenue and order trends.
- Identified top-performing products and countries.
- Calculated average order value.
- Analysed repeat and one-time customers.
- Evaluated customer revenue contribution.
- Analysed cancelled invoices and weekday sales performance.

### 3. Sales Performance Dashboard

Created an interactive Power BI dashboard containing:

- Total Revenue KPI
- Total Orders KPI
- Total Customers KPI
- Average Order Value KPI
- Repeat Customer Rate KPI
- Monthly Revenue Trend
- Monthly Orders Trend
- Top 10 Products by Revenue
- Revenue by Country

**Interactive slicers:** Country, Sales Date, and Product.

### 4. Customer Analysis Dashboard

Created a second Power BI dashboard to understand customer purchasing behaviour.

- Customer Segmentation using a doughnut chart.
- Revenue by Customer Type.
- Top 10 Customers by Revenue.
- Customer segmentation into Repeat Customers and One-Time Customers.
- Created DAX calculations and a relationship between the customer segmentation table and the main retail dataset.

## Key Business Insights

- The United Kingdom generated approximately £7.30 million in revenue.
- November 2011 recorded the highest monthly revenue of approximately £1.16 million.
- February 2011 recorded the lowest monthly revenue of approximately £447,137.
- Average Order Value was approximately £480.87.
- SQL analysis identified 4,338 customers with Customer IDs.
- 2,845 customers were classified as repeat customers, while 1,493 were one-time customers.
- Repeat customers contributed approximately 93.08% of the analysed revenue.

*Note: These figures are from the SQL analysis. Power BI measures may differ due to differences in filtering and calculation logic.*

## Dashboard Preview

### Sales Performance Dashboard

![Sales Performance Dashboard](Screenshots/sales_performance_dashboard.png)

### Customer Analysis Dashboard

![Customer Analysis Dashboard](Screenshots/customer_analysis_dashboard.png)

## Project Structure

```text
Online-Retail-Business-Analysis/
│
├── README.md
│
├── SQL/
│   └── online_retail_analysis.sql
│
├── PowerBI/
│   └── Online_Retail_Business_Analysis.pbix
│
├── Screenshots/
│   ├── sales_performance_dashboard.png
│   └── customer_analysis_dashboard.png
│
└── Dataset/
    └── README.md
```

## Skills Demonstrated

- SQL Query Writing
- MySQL Database Management
- Data Analysis
- Data Preparation
- DAX Measures
- Data Modelling
- Customer Segmentation
- KPI Development
- Power BI Dashboard Development
- Business Insight Generation

## Dataset Source

Online Retail Dataset – UCI Machine Learning Repository:

https://archive.ics.uci.edu/dataset/352/online+retail

The dataset is not included in this repository. Please download it from the original source.

## Project Goal

To demonstrate practical data analytics skills by using SQL for business analysis and Power BI for interactive data visualisation and reporting.

**Author:** Krishna Patel

**GitHub:** github.com/krishhhhpatel

**LinkedIn:** https://www.linkedin.com/in/krishna-patel-93a5ba3ab/
