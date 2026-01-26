/* STEP 1: ENVIRONMENT SETUP & MAPPING
   Purpose: Create supporting structures and reference tables.
*/

-- Create a temporary mapping table to localize Brazilian states to Vietnam regions
-- This demonstrates the ability to enrich raw data with local context.
CREATE TEMP TABLE vn_region_mapping (
    original_state CHAR(2),
    vn_city VARCHAR(50),
    vn_region VARCHAR(20)
);

INSERT INTO vn_region_mapping VALUES 
('SP', 'Ho Chi Minh City', 'South'),
('PR', 'Hai Phong', 'North'),
('MG', 'Da Nang', 'Central'),
('SC', 'Binh Duong', 'South'),
('RJ', 'Ha Noi', 'North'),
('RS', 'Can Tho', 'South'),
('GO', 'Bac Ninh', 'North');

-- Verify mapping
SELECT * FROM vn_region_mapping LIMIT 100;

/* STEP 2: DATA TRANSFORMATION & KPI LOGIC
   Purpose: Centralize business logic and prepare a Master View for visualization.
*/

CREATE OR REPLACE VIEW vw_localized_supply_chain AS
WITH raw_delivery_data AS (
    SELECT 
        o.order_id,
        o.order_status,
        -- Time shifting logic for 2025 simulation
        o.order_purchase_timestamp + INTERVAL '2555 days' AS order_date,
        o.order_delivered_customer_date + INTERVAL '2555 days' AS actual_delivery_date,
        o.order_estimated_delivery_date + INTERVAL '2555 days' AS scheduled_delivery_date,
        -- Scaled to VND range for easier interpretation in local context
        oi.price * 25000 AS price_vnd,
        p.product_weight_g,
        p.product_category_name,
        s.seller_state
    FROM olist_orders o
    JOIN olist_order_items oi ON o.order_id = oi.order_id
    JOIN olist_products p ON oi.product_id = p.product_id
    JOIN olist_sellers s ON oi.seller_id = s.seller_id
)
SELECT 
    d.*,
    COALESCE(m.vn_city, 'Other Provinces') AS city_vn,
    COALESCE(m.vn_region, 'Rest of VN') AS region_vn,
    -- KPI: Delivery Performance Classification
    CASE 
        WHEN actual_delivery_date IS NULL THEN 'In-Transit'
        WHEN actual_delivery_date <= scheduled_delivery_date THEN 'On-Time'
        ELSE 'Late'
    END AS sla_status,
    -- KPI: Lead Time Calculation (Handling NULLs to avoid invalid values)
    CASE 
        WHEN actual_delivery_date IS NOT NULL 
        THEN EXTRACT(DAY FROM (actual_delivery_date - order_date))
        ELSE NULL 
    END AS lead_time_days,
    -- Simulated shipping fee based on product weight (for analysis purpose)
    CASE 
        WHEN product_weight_g < 1000 THEN 22000
        WHEN product_weight_g BETWEEN 1000 AND 3000 THEN 35000
        ELSE 55000
    END AS shipping_fee_vnd
FROM raw_delivery_data d
LEFT JOIN vn_region_mapping m ON d.seller_state = m.original_state;

SELECT * FROM vw_localized_supply_chain LIMIT 5;

/* STEP 3: KPI QUERIES & BUSINESS INSIGHTS
   Purpose: Answer specific business questions using the transformed Master View.
   Status: Final Review Completed with English Comments.
*/

-- Q1: What is the overall On-time Delivery Rate (SLA Compliance)?
-- Logic: Calculates the percentage for each delivery status to evaluate overall operational performance.
SELECT 
    sla_status,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(100.0 * COUNT(DISTINCT order_id) / SUM(COUNT(DISTINCT order_id)) OVER(), 2) AS percentage
FROM vw_localized_supply_chain
GROUP BY sla_status;

-- Q2 Benchmarking Lead Time & Costs
-- Note: Raw lead times (11-13 days) reflect the original Brazil dataset scale. 
-- We use a 0.3 scaling factor for VN context and a Lead Time Index for relative benchmarking.

-- Q2.1: Lead Time Benchmarking by Region
-- Purpose: Identify regional bottlenecks.
SELECT 
    region_vn,
    ROUND(AVG(lead_time_days), 2) AS avg_lead_time_raw,
    ROUND(AVG(lead_time_days) * 0.3, 1) AS simulated_vn_lead_time,
    ROUND(
        AVG(lead_time_days) / NULLIF(AVG(AVG(lead_time_days)) OVER(), 0), 
        2
    ) AS lead_time_index,
    ROUND(AVG(shipping_fee_vnd), 0) AS avg_shipping_cost
FROM vw_localized_supply_chain
WHERE sla_status != 'In-Transit'
GROUP BY region_vn
ORDER BY lead_time_index DESC;

-- Q2.2: Lead Time Benchmarking by Weight Class
-- Business Insight: High index (>1.0) for Heavy items indicates logistics bottlenecks for bulky goods.
SELECT 
    CASE 
        WHEN product_weight_g < 1000 THEN 'Light (<1kg)'
        WHEN product_weight_g BETWEEN 1000 AND 5000 THEN 'Medium (1-5kg)'
        ELSE 'Heavy (>5kg)'
    END AS weight_class,
    ROUND(AVG(lead_time_days), 2) AS avg_lead_time_raw,
    ROUND(
        AVG(lead_time_days) / NULLIF(AVG(AVG(lead_time_days)) OVER(), 0), 
        2
    ) AS lead_time_index,
    ROUND(AVG(shipping_fee_vnd), 0) AS avg_shipping_cost,
    COUNT(order_id) AS sample_size
FROM vw_localized_supply_chain
GROUP BY 1
ORDER BY lead_time_index DESC;

-- Q2.3: Lead Time Benchmarking by Product Category (Top 10 categories)
-- Note: Categories with high index might require different 3PL partners or handling processes.
SELECT 
    product_category_name,
    ROUND(AVG(lead_time_days), 2) AS avg_lead_time_raw,
    ROUND(
        AVG(lead_time_days) / NULLIF(AVG(AVG(lead_time_days)) OVER(), 0), 
        2
    ) AS lead_time_index,
    ROUND(AVG(shipping_fee_vnd), 0) AS avg_shipping_cost
FROM vw_localized_supply_chain
WHERE sla_status != 'In-Transit' 
  AND product_category_name IS NOT NULL
GROUP BY 1
HAVING COUNT(order_id) > 10
ORDER BY lead_time_index DESC
LIMIT 10;

-- Q3: Identifying "Late Delivery" Hotspots (Cities with most delays)
-- Logic: Identifying top 5 cities that need Last-mile process optimization.
SELECT 
    city_vn,
    COUNT(order_id) AS late_orders
FROM vw_localized_supply_chain
WHERE sla_status = 'Late'
GROUP BY city_vn
ORDER BY late_orders DESC
LIMIT 5;

-- Q4: Correlation between Product Weight and Delivery Delay
-- Business logic: Calculates the Late Rate (%) by weight class to see if heavier items are more prone to delays.
SELECT 
    CASE 
        WHEN product_weight_g < 1000 THEN 'Light (<1kg)'
        WHEN product_weight_g BETWEEN 1000 AND 5000 THEN 'Medium (1-5kg)'
        ELSE 'Heavy (>5kg)'
    END AS weight_class,
    COUNT(order_id) AS total_orders,
    ROUND(100.0 * SUM(CASE WHEN sla_status = 'Late' THEN 1 ELSE 0 END) / COUNT(order_id), 2) AS late_rate_percentage
FROM vw_localized_supply_chain
GROUP BY 1
ORDER BY late_rate_percentage DESC;

-- Q5: Estimated Financial Impact of Late Deliveries
-- Note: Assuming a 10% refund on shipping fee for late orders as compensation based on industry standard SLAs (e.g., FedEx/UPS).
SELECT 
    region_vn,
    SUM(shipping_fee_vnd) AS total_shipping_revenue_vnd,
    SUM(CASE WHEN sla_status = 'Late' THEN shipping_fee_vnd * 0.1 ELSE 0 END) AS estimated_compensation_cost_vnd,
    ROUND(
        SUM(CASE WHEN sla_status = 'Late' THEN shipping_fee_vnd * 0.1 ELSE 0 END) / 
        NULLIF(SUM(shipping_fee_vnd), 0), 
        3
    ) AS compensation_ratio
FROM vw_localized_supply_chain
GROUP BY region_vn
ORDER BY estimated_compensation_cost_vnd DESC;