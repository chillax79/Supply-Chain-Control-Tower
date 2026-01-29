# 📦 Deep Dive #2: Heavy Cargo Bottleneck  
## When Low Volume Meets High Exception Severity  
*(Analysis Period: Oct 2023 – Oct 2025)*

---

## 1. Executive Question

Why does **Heavy Cargo (>5kg)** exhibit the **highest Late Rate** in the system,  
despite showing **no material difference in standard processing speed** compared to lighter shipments?

This deep dive investigates whether the bottleneck is driven by:
- Slower operational processes, or
- A structural risk embedded in the distribution of heavy cargo deliveries.

---

## 2. Quantitative Snapshot

### 2.1 Order Volume Contribution

| Weight Class | Order Share |
|-------------|-------------|
| **Heavy (>5kg)** | **12.52%** |
| Medium (1–5kg) | 28.6% |
| Light (<1kg) | 58.88% |

> Heavy cargo represents a **minority of total orders**, making its SLA metrics highly sensitive to exceptions.

> **Analytical Notes:**
>
> This analysis combines delivered order volume with late delivery risk 
to identify structural bottlenecks by weight class.
> Late Delivery Rate is calculated only on completed deliveries 
(On-Time + Late), excluding In-Transit orders, to reflect operational performance.
> As a result, percentage values in Tableau may not fully reconcile 
with global SQL aggregates that include all order statuses.
> This is an intentional design choice to prioritize decision-making insight 
over strict numerical reconciliation.

---

### 2.2 Late Rate by Weight Class

| Weight Class | Late Rate |
|-------------|-----------|
| **Heavy (>5kg)** | **9.07% (Highest)** |
| Medium (1–5kg) | 8.37% |
| Light (<1kg) | ~7.72% (Lowest) |

At face value, Heavy cargo appears to be the worst-performing segment.  
However, aggregate KPIs alone are insufficient to diagnose root causes.

---

## 3. Distribution Analysis: Process Speed vs. Risk Profile

### 3.1 Median Lead Time: No Evidence of Slower SOP

From the **Distribution of Delivery Days (Box Plot)**:

- Median lead time:
  - Heavy: 3.3 days  
  - Medium: 3 days  
  - Light: 2.7 days  

**Key implication:**  
> The standard operating process (SOP) for Heavy cargo is **not much slower** than for other weight classes.

This suggests that warehouse handling and standard dispatch are unlikely to be the dominant drivers of late performance.

---

### 3.2 Upper Distribution: Where the Risk Emerges

While Heavy cargo does **not** have the longest maximum lead time, it shows:

- A **slightly higher upper whisker** (~10 days) compared to Light (~7–8 days)
- A visible cluster of **extreme outliers** extending beyond 30 days

Importantly:
- Medium shipments reach even higher maximum values (~60+ days)
- Heavy shipments do **not** dominate in outlier count

This indicates the issue is **not frequency**, but **impact severity**.

---

## 4. Core Insight: A Statistical Risk Problem, Not a Process Problem

### 4.1 Low Volume × High Severity = Metric Distortion

Heavy cargo operates under a **structurally fragile SLA profile**:

- Low denominator (12.52% volume)
- A small number of extreme delays
- Each delayed case exerts **outsized influence** on the Late Rate

> A handful of severely delayed Heavy shipments can disproportionately inflate SLA metrics, even when median performance remains healthy.

This is a **sample size effect**, not evidence of systematic inefficiency.

---

### 4.2 Frequency vs. Severity (Critical Distinction)

| Dimension | Heavy Cargo |
|--------|-------------|
| Exception frequency | Not the highest |
| Exception severity | **High** |
| Impact on Late Rate | **Disproportionate** |

Medium cargo experiences more variability overall,  
but Heavy cargo exceptions are **harder to recover once they occur**.

---

## 5. Root Cause Hypothesis (Validated by Distribution Shape)

The bottleneck emerges **after standard processing**, driven by post-dispatch constraints:

- **Transportation constraints:**  
  Heavy shipments often require route consolidation or specialized vehicles, increasing wait time when capacity is constrained.

- **Last-mile recovery complexity:**  
  Failed delivery attempts for bulky items (customer rescheduling, access issues, vehicle limitations) tend to extend resolution time significantly longer than for light parcels.

These factors increase **exception severity**, not baseline lead time.

---

## 6. Strategic Implications

### 6.1 What *Not* to Do
- Do **not** redesign standard SOPs — median performance is already competitive.
- Do **not** apply blanket acceleration policies across all Heavy shipments.

### 6.2 What *Does* Move the Needle

- **Early Warning System:**  
  Flag Heavy orders exceeding **5 days in-transit** for proactive intervention.

- **Exception-focused SLA Management:**  
  Track and manage **tail risk**, not averages, for low-volume segments.

- **3PL Performance Segmentation:**  
  Prioritize partners with shorter recovery cycles for bulky shipments, not just lower average lead time.

> Because Heavy volume is small, resolving a limited number of extreme cases can materially improve overall SLA with minimal resource investment.

---

## 7. Final Takeaway

> **Heavy Cargo is not slow by default — it is fragile to exceptions.**

The Heavy Cargo bottleneck is best understood as a **risk distribution problem**, where low volume and high exception severity combine to distort SLA outcomes.

Correctly addressing this issue requires **targeted exception management**, not process acceleration.

---

*This insight complements Deep Dive #1 by demonstrating that while regional focus maximizes leverage, weight-class analysis reveals where SLA volatility truly originates.*