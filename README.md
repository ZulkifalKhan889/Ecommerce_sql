# Ecommerce SQL Analysis Project

## Project Overview
This project demonstrates advanced SQL skills by analyzing a real-world ecommerce dataset. The goal is to extract actionable business insights using MySQL queries. The repository includes the dataset, structured SQL queries, and insights derived from the analysis. It highlights practical SQL techniques such as aggregation, filtering, joins, subqueries, and case statements.

The project focuses purely on SQL, showcasing how data can be processed and interpreted to inform business decisions without relying on Python or visualization tools.

---

## Dataset
The dataset contains transactional ecommerce data including:

- **Orders**: Order IDs, order dates  
- **Products**: Product IDs, names, categories, prices, discounts, tax rates  
- **Customers**: Age group, gender, city, country  
- **Shipping**: Method and cost  
- **Product metrics**: Stock levels, popularity index, return rates, seasonality  


---

## SQL Skills Demonstrated
The project showcases SQL proficiency in areas such as:

- SELECT queries for data retrieval  
- GROUP BY with aggregation (SUM, COUNT, AVG, MAX)  
- Filtering with WHERE and HAVING clauses  
- JOIN operations for combining tables  
- Subqueries and nested queries  
- Conditional logic using CASE statements  
- Data cleaning and transformation (splitting Customer_location into city and country)  
- Revenue, discount, and return rate calculations  
- Identifying trends, high-demand products, and customer behavior  

---

## Key Business Insights Extracted
The queries in this project answer important business questions, including:

1. **Revenue by Product & Discounted Price**: Calculated total revenue and revenue per product after applying discounts.  
2. **Top Selling Products & Categories**: Identified the most sold products and highest-grossing categories.  
3. **Customer Segmentation**: Determined which age groups and genders contribute most to revenue, enabling targeted marketing.  
4. **Product Demand Status**: Classified products as understocked, overstocked, or balanced based on popularity and stock level.  
5. **Impact of Discounts on Popularity**: Determined which products are strong or discount-driven based on average popularity and discount.  
6. **Country-Level Analysis**: Revenue contribution and return rates by country.  
7. **Top Products by Popularity Index**: Ranked the most popular products.  
8. **Return Rate Analysis**: Identified products with the highest return rates to detect potential issues.  
9. **Average Order Value (AOV) by Country**: Though limited by dataset, the analysis concept is demonstrated.  
10. **City-wise Product Popularity**: Evaluated product performance across different cities.  
11. **High-Spending Customers with High Returns**: Identified customer segments that may impact profitability.  


---

