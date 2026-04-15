# 📚 Online Book Store Data Analysis (PostgreSQL Project)

## 📌 Project Overview

This project analyzes an **Online Book Store dataset** using PostgreSQL to uncover key business insights related to sales, customers, and inventory.

The goal is to simulate real-world data analyst responsibilities:

* Data cleaning & validation
* Exploratory data analysis (EDA)
* Business-driven insights
* KPI tracking

---

## 🗂️ Database Schema

The project consists of three main tables:

### 📖 Books

* `book_id` (Primary Key)
* `title`
* `author`
* `genre`
* `published_year`
* `price`
* `stock`

### 👤 Customers

* `customer_id` (Primary Key)
* `customer_name`
* `email`
* `phone`
* `city`
* `country`

### 🛒 Orders

* `order_id` (Primary Key)
* `customer_id` (Foreign Key)
* `book_id` (Foreign Key)
* `order_date`
* `quantity`
* `total_amount`

---

## 🧹 Data Cleaning & Validation

Performed multiple checks to ensure data quality:

### ✔ Null Value Check

* Verified no missing values in critical columns across all tables

### ✔ Invalid Data Detection

* Checked for negative or zero values:

  * Book price
  * Stock quantity
  * Order quantity
  * Total amount

### ✔ Stock Analysis

* Identified books with:

  * Zero stock (out-of-stock)
  * Potential stock issues

---

## 📊 Key Performance Indicators (KPIs)

* **Total Orders**
* **Total Revenue**
* **Average Order Value (AOV)**

---

## 🔍 Exploratory Data Analysis

### 📚 Books Analysis

* Total books: 500
* Genres identified: 7
* Price range: 5.07 – 49.98
* Stock range: 0 – 100

### 👥 Customer Analysis

* Total customers: 500
* Unique cities: 489
* Countries covered: 215

### 🛒 Orders Analysis

* Orders: 500
* Active customers: 307
* Order date range: Dec 2022 – Dec 2024

---

## 📈 Business Insights

### 📅 Sales Trend Analysis

* Monthly revenue trends identified using time-based aggregation

### 👑 Top Customers

* Top 10 customers contributing highest revenue

### 📦 Inventory Risk Analysis

* Identified:

  * Low stock items (risk of stockout)
  * Over-promised items (orders exceed stock)

### 📊 Best Selling Genre

* Ranked genres based on revenue contribution

### 📘 Most Ordered Books

* Identified frequently ordered books

### 👥 Customer Behavior

* Customers with multiple orders (repeat customers)
* High quantity buyers

### 🧠 Customer Segmentation

Customers categorized into:
  High Value Customers
  Mid Value Customers
  Low Value Customers

Based on total spending

---

## 🧠 Key Business Questions Answered

* Which genres generate the highest revenue?
* Who are the top customers?
* What are the monthly sales trends?
* Which books are at risk of stockout?
* Are there inventory mismatches (over-selling)?
* Which books are most frequently ordered?

---

## 🛠️ SQL Techniques Used

* Joins (INNER, LEFT, RIGHT)
* Aggregations (`SUM`, `AVG`, `COUNT`)
* Filtering (`WHERE`, `HAVING`)
* Subqueries
* Common Table Expressions (CTEs)
* Window Functions (`RANK`, `DENSE_RANK`)
* Date functions (`DATE_TRUNC`, `TO_CHAR`)
* Data validation techniques

---

## 🚀 Key Learnings

* Importance of **data validation before analysis**
* Difference between **data anomalies vs business scenarios**
* Writing **clean, structured, and scalable SQL queries**
* Translating raw data into **actionable business insights**

---

## 📌 Future Improvements

* Build a **Power BI dashboard** for visualization
* Optimize queries using indexing

---

## 🧑‍💻 Tools Used

* PostgreSQL
* SQL

---

## 📎 Conclusion

This project demonstrates end-to-end data analysis using SQL — from raw data validation to generating meaningful business insights.

It reflects real-world analyst tasks and showcases strong SQL fundamentals along with analytical thinking.

---

## 👤 Author

**Harshitha Salian**  
Analytics Professional | SQL | Power BI | Excel | Python

🔗 [LinkedIn](https://www.linkedin.com/in/salianharshitha/) | 📧: salian.harshitha.r@gmail.com

---
