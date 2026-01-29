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

--Verify view
SELECT * FROM vw_localized_supply_chain LIMIT 5;