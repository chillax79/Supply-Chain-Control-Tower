# Data Dictionary: Supply Chain Control Tower 2025

This document defines the original Kaggle (Olist) data fields and the SQL-engineered KPIs.  
The dataset is localized for a **2025 Vietnam market simulation**, mapping international logistics to local provinces and regions.

---

## 1. Raw Data Tables (Kaggle Source)

### Table: `olist_orders`

| Field | Description |
|------|------------|
| order_id | Unique identifier for each order |
| order_status | Current status of the order (delivered, shipped, etc.) |
| order_purchase_timestamp | The exact time the customer placed the order |
| order_estimated_delivery_date | The promised delivery date (Used as the SLA benchmark) |
| order_delivered_customer_date | The actual date the customer received the order |

---

### Table: `olist_order_items`

| Field | Description |
|------|------------|
| order_id | Foreign key linking to the orders table |
| product_id | Foreign key linking to the products table |
| seller_id | Foreign key linking to the sellers table |
| price | Item price in original currency (Scaled by 25,000 for VND simulation) |

---

### Table: `olist_products`

| Field | Description |
|------|------------|
| product_id | Unique identifier for each product |
| product_category_name | The category name of the product |
| product_weight_g | Product weight in grams (Used for weight-class segmentation) |

---

### Table: `olist_sellers`

| Field | Description |
|------|------------|
| seller_id | Unique identifier for each seller / warehouse |
| seller_state | Original state code (Used for mapping to Vietnam regions) |

---

## 2. Engineered Fields (Derived via SQL)

These fields are generated in the `02_data_transformation.sql` file to localize the context to **Vietnam 2025**.

| Field | Logic / Formula | Description |
|------|---------------|------------|
| purchase_date | `order_purchase_timestamp + 2555 days` | Shifts historical data into a 2025 business context (preserved day-of-week) |
| region_vn | Mapping from `seller_state` | Categorizes locations into Vietnam regions (North, Central, South) |
| sla_status | `actual <= scheduled ? 'On-Time' : 'Late'` | Evaluates compliance with the delivery promise |
| lead_time_days | `actual_date - order_date` | Total duration from order to fulfillment (Lead Time) |
| weight_class | Based on `product_weight_g` | Groups: Light (<1kg), Medium (1–5kg), Heavy (>5kg) |
| shipping_fee_vnd | Based on `product_weight_g` | Simulated shipping costs reflecting the VN logistics market |
