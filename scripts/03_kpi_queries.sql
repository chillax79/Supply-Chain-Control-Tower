/* 
    STEP 3: KPI QUERIES & BUSINESS INSIGHTS
    Purpose: Answer specific business questions using the transformed Master View.
 */

-- ====================================================================================
-- QUERY 1: Delivery Performance Overview
-- ====================================================================================

-- Q1.1 Delivery Status Visibility
-- Purpose: Provide an end-to-end view of the delivery pipeline.
-- Scope: All orders, including In-Transit.
-- Note: This metric is for operational visibility only, not SLA evaluation.

SELECT 
    sla_status,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(
        100.0 * COUNT(DISTINCT order_id)
        / SUM(COUNT(DISTINCT order_id)) OVER(),
        2
    ) AS percentage_of_orders
FROM vw_localized_supply_chain
GROUP BY sla_status
ORDER BY percentage_of_orders DESC;

-- Q1.2 On-Time Delivery Performance
-- Purpose: Measure SLA compliance based on completed deliveries.
-- Scope: Delivered orders only (In-Transit excluded to avoid bias).
-- Definition:
-- On-Time Rate = On-Time Delivered Orders / Total Delivered Orders

SELECT 
    sla_status,
    COUNT(DISTINCT order_id) AS delivered_orders,
    ROUND(
        100.0 * COUNT(DISTINCT order_id)
        / SUM(COUNT(DISTINCT order_id)) OVER(),
        2
    ) AS percentage_of_delivered_orders
FROM vw_localized_supply_chain
WHERE sla_status IN ('On-Time', 'Late')
GROUP BY sla_status
ORDER BY percentage_of_delivered_orders DESC;

-- ====================================================================================
-- QUERY 2: Regional Impact Analysis
-- ====================================================================================
-- Q2.1 Regional Delivery Status Distribution
-- Purpose: Analyze delivery status breakdown by region.
-- Scope: All orders, including In-Transit.
-- Note: Used for regional operational visibility, not SLA evaluation.

SELECT 
    region_vn,
    sla_status,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(
        100.0 * COUNT(DISTINCT order_id)
        / SUM(COUNT(DISTINCT order_id)) OVER (PARTITION BY region_vn),
        2
    ) AS status_percentage_within_region
FROM vw_localized_supply_chain
GROUP BY region_vn, sla_status
ORDER BY region_vn, status_percentage_within_region DESC;

-- Q2.2 Regional Order Share
-- Purpose: Measure each region's contribution to total order volume.
-- Scope: Distinct orders across the entire system.
-- Definition:
-- Regional Order Share = Orders in Region / Total Orders

SELECT 
    region_vn,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(
        100.0 * COUNT(DISTINCT order_id)
        / SUM(COUNT(DISTINCT order_id)) OVER (),
        2
    ) AS regional_order_share_percentage
FROM vw_localized_supply_chain
GROUP BY region_vn
ORDER BY regional_order_share_percentage DESC;

-- ====================================================================================
-- QUERY 3: Regional Lead Time Analysis
-- ====================================================================================
-- Purpose:
-- Analyze average delivery lead time by region and benchmark against the system-wide 
-- average using a Lead Time Index.
-- Note:
-- Raw lead times (≈11–13 days) reflect the original Brazil dataset scale.
-- We apply a 0.3 scaling factor to simulate Vietnam delivery conditions.
-- Lead Time Index is used for relative performance comparison.

WITH lead_time_metric AS (
    SELECT 
        AVG(lead_time_days * 0.3) AS global_avg_lead_time
    FROM vw_localized_supply_chain
    WHERE sla_status IN ('On-Time', 'Late')
)
SELECT
    region_vn,

    -- Average lead time per region (VN-scaled)
    ROUND(AVG(lead_time_days * 0.3), 2) AS avg_lead_time_days_vn,
    -- Lead Time Index: regional performance vs global average
    ROUND(
        AVG(lead_time_days * 0.3)
        / (SELECT global_avg_lead_time FROM lead_time_metric),
        2
    ) AS lead_time_index,
    -- Sample size for statistical reliability
    COUNT(DISTINCT order_id) AS sample_size
FROM vw_localized_supply_chain
WHERE sla_status IN ('On-Time', 'Late')
GROUP BY region_vn
ORDER BY lead_time_index DESC;

/* ====================================================================================
QUERY 4: Weight Class Overview
====================================================================================
*/
-- Q4.1 Weight Class Distribution
-- Purpose: Show order mix by shipment weight class.

SELECT 
    CASE 
        WHEN product_weight_g < 1000 THEN 'Light (<1kg)'
        WHEN product_weight_g BETWEEN 1000 AND 5000 THEN 'Medium (1–5kg)'
        ELSE 'Heavy (>5kg)'
    END AS weight_class,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(
        100.0 * COUNT(DISTINCT order_id)
        / SUM(COUNT(DISTINCT order_id)) OVER (),
        2
    ) AS order_percentage
FROM vw_localized_supply_chain
GROUP BY 1
ORDER BY order_percentage DESC;

-- Q4.2 SLA Performance by Weight Class
-- Purpose: Compare On-Time vs Late performance across weight classes.

SELECT 
    CASE 
        WHEN product_weight_g < 1000 THEN 'Light (<1kg)'
        WHEN product_weight_g BETWEEN 1000 AND 5000 THEN 'Medium (1–5kg)'
        ELSE 'Heavy (>5kg)'
    END AS weight_class,
    COUNT(DISTINCT order_id) AS delivered_orders,
    ROUND(
        100.0 * COUNT(DISTINCT CASE WHEN sla_status = 'Late' THEN order_id END)
        / COUNT(DISTINCT order_id),
        2
    ) AS late_rate_percentage
FROM vw_localized_supply_chain
WHERE sla_status IN ('On-Time', 'Late')
GROUP BY 1
ORDER BY late_rate_percentage DESC;

/* =========================================================
   Q5. Estimated Financial Impact of Late Deliveries
   =========================================================
 */
-- Purpose: Estimate regional financial exposure from late deliveries
-- based on shipping fee compensation.
-- Note:
-- Late orders are assumed to incur a 10% refund of shipping fee.
-- Calculations are based only on completed deliveries(On-Time + Late), excluding In-Transit orders.

SELECT 
    region_vn,
    SUM(shipping_fee_vnd) AS revenue_from_delivered_vnd,
    SUM(CASE 
        WHEN sla_status = 'Late' THEN shipping_fee_vnd * 0.1 
        ELSE 0 
    END) AS actual_compensation_cost_vnd,
    ROUND(
        SUM(CASE WHEN sla_status = 'Late' THEN shipping_fee_vnd * 0.1 ELSE 0 END) / 
        NULLIF(SUM(shipping_fee_vnd), 0), 
        4
    ) AS compensation_ratio
FROM vw_localized_supply_chain
WHERE sla_status IN ('On-Time', 'Late')
GROUP BY region_vn
ORDER BY actual_compensation_cost_vnd DESC;