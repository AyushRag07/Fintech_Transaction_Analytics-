# 💳 FinTech Transaction Analytics

![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![Power BI](https://img.shields.io/badge/Power_BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)

An end-to-end banking analytics project that simulates a digital banking environment to analyze customer behavior, transaction patterns, spending habits, account growth, regional activity, and potential fraud indicators.

The project covers the complete analytics workflow: **data generation → database modeling → SQL analysis → Power BI dashboarding**.

---

## 📊 Dashboard Preview

![Dashboard Preview](PowerBI/FinTech%20Transaction%20Analytics%20Dashboard.png)

---

## 🚀 Project Workflow

### 🐍 Data Generation
Generated synthetic banking datasets using Python:
- Customers
- Accounts
- Transactions

### 🗄️ Database Design
- Created a relational database schema
- Established relationships using Primary & Foreign Keys

### 🧹 Data Cleaning & Validation
- Fixed transaction date inconsistencies
- Validated transaction categories
- Corrected merchant and transaction-type mismatches
- Ensured relationship integrity across tables

### 🔍 SQL Analysis
Applied:
- JOINs
- CTEs
- Aggregations
- Window Functions
- Ranking Functions
- Date Functions

### 📈 Dashboard Development
Built an interactive Power BI dashboard for business insights and performance monitoring.

---

## 🗃️ Database Schema

### Customers
`customer_id` • `customer_name` • `age` • `city` • `signup_date`

### Accounts
`account_id` • `customer_id` • `account_type`

### Transactions
`transaction_id` • `account_id` • `transaction_date` • `transaction_type` • `merchant` • `transaction_category` • `amount` • `transaction_status` • `fraud_flag` • `running_balance`

---

## 🔍 Business Questions Solved

- Which customers contribute the highest transaction volume?
- What are the monthly transaction trends?
- Which cities generate the highest banking activity?
- Which customers became dormant over time?
- Detect suspicious or fraud-like transactions.
- What is the running balance trend for each account?
- Which merchants/categories receive the highest spending?
- How does weekend spending compare to weekday spending?
- Which customers experienced the largest balance growth?
- Identify the top spending customer every month.

---

## 📈 Dashboard Features

✅ Customer KPIs

✅ Transaction Trend Analysis

✅ Spending Category Analysis

✅ Merchant Analysis

✅ Regional Activity Analysis

✅ Fraud Monitoring

✅ Top Customer Identification

---

## 🎯 Skills Demonstrated

**Python • Data Generation • Data Cleaning • Data Modeling • SQL Analytics • Window Functions • Business Intelligence • Power BI • Data Visualization**

---

## 👨‍💻 Author

**Ayush Rag**

⭐ If you found this project interesting, consider giving it a star.
