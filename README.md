# Customer Segmentation with RFM Model

## Overview
This project analyzes customer behavior using the **RFM (Recency, Frequency, Monetary)** model.  
It segments customers into groups such as **VIP, Loyal, At Risk, Churned** to support targeted marketing and reduce churn risk.  

The analysis is based on transactional data of more than **113,800 customers**, with a total revenue of **2.39B USD** up to 01-09-2022.  

## Tools & Skills
- **SQL (MySQL)** → custom queries with IQR method for fair segmentation  
- **Power BI** → interactive dashboards & visualization   

## Project Structure

### Report
[Full RFM Analysis Report (PDF)](report/Bao-cao-phan-tich-khach-hang-RFM)

### Dashboard Preview
*(add screenshots of your Power BI dashboard here)*  
Example:  
![Dashboard](images/dashboard.png)

### Key Insights
- **At Risk Customers** (≈ 28% of customers, 714M USD) → biggest risk segment, requires urgent retention campaigns.  
- **VIP Customers** (≈ 25% of revenue with only 16% of customers) → highest ARPU, need personalized care.  
- **Occasional & Churned Customers** still contribute significant revenue (≈ 660M USD), potential for reactivation.  
- Groups like **RFM 344** and **RFM 444** stand out as high-value segments.  

### SQL Query Approach
Instead of using simple N-tiles, this project applied **IQR (Interquartile Range)** thresholds to define segment boundaries.  
This ensures customers with similar behaviors fall into the same group, avoiding unfair splits caused by equal-quantile methods.  

---

👤 Author: **Nguyễn Hoàng Phương Linh**

