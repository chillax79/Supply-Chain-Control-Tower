# Technical Documentation & Business Logic

This document outlines the **technical methodology** and **business logic** applied throughout the  
**Supply Chain Control Tower 2025** project.

---

## 1. Data Pipeline Architecture

The project follows an **ELT (Extract, Load, Transform)** approach, implemented directly within a  
**cloud-based database environment**.

### Extract & Load
- Raw Kaggle (Olist) datasets are imported into **PostgreSQL (Supabase)**.
- Data is stored in its original schema to preserve data integrity.

### Transformation (SQL-based)
Transformations are handled entirely in SQL to ensure transparency and reproducibility.

Key techniques include:
- **CTEs (Common Table Expressions):**  
  Used to modularize data cleaning and feature engineering steps.
- **Interval Arithmetic:**  
  Applied to shift historical timestamps into the year **2025** while preserving seasonality and day-of-week patterns.
- **Master View Construction:**  
  A unified analytical view is created to:
  - Optimize Tableau query performance  
  - Eliminate the need for complex joins at the BI layer

---

## 2. KPI Calculation Logic

### SLA Compliance Rate
- **Definition:**  
  Percentage of orders where  
  `actual_delivery_date <= estimated_delivery_date`
- **Business Role:**  
  Serves as the **north-star metric** for operational performance and customer satisfaction.

---

### Lead Time Index (LTI)
- **Formula:**  
LTI = Avg Lead Time (Region) / Avg Lead Time (National)
- **Interpretation:**  
- `LTI > 1.0` → Region is slower than the national average  
- `LTI < 1.0` → Region is outperforming the national benchmark
- **Purpose:**  
Highlights **localized logistics bottlenecks** and infrastructure inefficiencies.

---

### Financial Impact (Simulated)
- **Assumption:**  
A **10% shipping fee refund** is applied to every `"Late"` order.
- **Objective:**  
Estimate the **financial cost of SLA violations** to simulate service-level penalty exposure.
- **Note:**  
This metric is illustrative and used for analytical storytelling rather than accounting accuracy.

---

## 3. Root Cause Analysis (RCA) Framework

Root cause analysis focuses on identifying **systemic friction points** impacting delivery performance.

### 1. Geography
- Evaluates the **concentration of orders in the South Region**
- Assesses the impact of volume density on:
    - Delivery delays  
    - Infrastructure strain

### 2. Product Characteristics
- **Geography:** Evaluating the concentration of orders in the South Region and its impact on infrastructure strain.

- **Product Characteristics:** Utilizing Box Plots to prove that Heavy goods (>5kg) exhibit the highest variance in delivery times, leading to system instability.

---

## Summary

This technical framework enables:
- Scalable KPI computation
- Clear separation between data engineering and BI layers
- Business-driven insights grounded in reproducible SQL logic