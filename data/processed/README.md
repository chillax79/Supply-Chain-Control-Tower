# Processed Dataset Schema
## vw_localized_supply_chain

This dataset represents the **final analytical layer** used for
Tableau visualization in the *Supply Chain Control Tower 2025* project.

It is created from raw Olist e-commerce data and enriched with:
- Vietnam regional localization
- SLA performance classification
- Lead time and logistics cost simulation

---

## Dataset Grain
**1 row = 1 order item**

---

## Column Definitions

| Column Name | Type | Description |
|------------|------|------------|
| order_id | string | Unique order identifier |
| order_status | string | Current order status |
| order_date | date | Purchase date (shifted to 2025 simulation) |
| actual_delivery_date | date | Actual delivery date |
| scheduled_delivery_date | date | Estimated delivery date |
| price_vnd | numeric | Item price converted to VND |
| product_weight_g | numeric | Product weight in grams |
| product_category_name | string | Product category |
| seller_state | string | Original seller state (Brazil) |
| city_vn | string | Localized Vietnam city |
| region_vn | string | Localized Vietnam region |
| sla_status | string | SLA classification: On-Time / Late / In-Transit |
| lead_time_days | numeric | Delivery lead time in days |
| shipping_fee_vnd | numeric | Simulated shipping fee |

---

## Business Rules Summary

- SLA Status:
  - `On-Time`: actual_delivery_date ≤ scheduled_delivery_date
  - `Late`: actual_delivery_date > scheduled_delivery_date
  - `In-Transit`: actual_delivery_date IS NULL

- Lead Time:
  - Calculated only for completed deliveries

- Shipping Fee:
  - Based on product weight buckets (<1kg / 1–3kg / >3kg)

---

## Data Usage
This dataset is consumed directly by:
- Tableau Story dashboards
- SLA performance analysis
- What-if logistics simulations