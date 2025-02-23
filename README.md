# Olist E-commerce Data Analysis Project

## Project Overview
In this project, I used the **Olist database**, which belongs to a Brazilian e-commerce store. My main focus was to work with multiple tools, so I used:
- **Excel** for data cleaning and some light exploration
- **PostgreSQL** for analysis
- **Power BI** for the dashboard

## Key Findings

### Order Analysis
- **Canceled Orders:** Account for less than 1% of successfully delivered orders—a good indicator.
- **Customer Reviews:**  
  The number of 1-star ratings is alarmingly high at approximately **10,700**. Although around **19,000** customers gave a rating of 4, the substantial volume of 1-star reviews highlights a significant issue of customer dissatisfaction.

### Delivery Performance
- Overall, **89%** of orders were delivered on time.
- For customers who rated **1**, on-time delivery dropped to **62%**.

### Major Issue Identified
- Products are frequently delivered incorrectly (wrong item, missing parts, or different from the images). This issue needs urgent attention to improve customer satisfaction.

## Payment & Inventory Insights

- **Payment Methods:**
  - **Credit Cards:** The most commonly used payment method, so ensuring smooth and fast transactions is essential.
  - **Installment Payments:** Used by **51%** of customers. This suggests the need to increase promotional campaigns for installment payments and offer more flexible payment plans.
- **Sales Trends:**
  - Sales peak in **September and October**, which means the inventory must be sufficient to handle the high order volume during these months.

## Dashboard KPIs

- Average revenue per order
- Delayed order percentage
- Average delivery date
- Canceled order percentage
- Installment payment rate
- Online delivery time for rating 1
- Deal wristband compilation rate (successful deal percentage)

## Dashboard Insights

- Average sales over the years and months
- Top-selling and least-selling products
- Top-performing sellers and their locations (states)
- Customer segmentation for successful marketing campaigns, including:
  - How customers reached our website
  - The industry they belong to
  - Whether they are a small or large business

dataset link: https://www.kaggle.com/datasets/terencicp/e-commerce-dataset-by-olist-as-an-sqlite-database
