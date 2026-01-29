# 📦 Supply Chain Control Tower 2025  

**Vietnam Market Simulation**

---

## 📌 Project Overview

This project builds a **centralized supply chain control tower**, simulating **2025 logistics operations in Vietnam** using the Olist e-commerce dataset (Kaggle).

The analytical focus is to close the **“3% SLA gap”**—from the current **91.89%** on-time delivery rate to the **95% business target**—by identifying **high-leverage operational nodes** rather than optimizing the entire system uniformly.

---
## 📖 How to Read This Project
Review the Tableau Story for business insights, then validate assumptions and logic via the SQL KPI queries and deep-dive analyses

---
## 🎯 Problem Statement

The current SLA compliance rate of **91.89%** falls short of the **95% target**, resulting in:

- **Financial Leakage**: Increased compensation costs for late deliveries  
- **Customer Impact**: Reduced trust and satisfaction in high-growth regions  
- **Operational Drag**: Inefficiencies driven by regional imbalance and heavy-cargo handling  

**Project Objective:**  
Identify where targeted operational interventions generate the **highest marginal impact on national SLA performance**.

---

## 🧠 Project Context & Methodology

### Analytical Focus
This project emphasizes **strategic prioritization over global optimization**, applying:

- **Volume-Weighted Leverage Analysis**  
  Measuring how improvements in high-volume regions disproportionately affect national SLA.
- **Lead Time Index (LTI)**  
  Normalizing delivery performance across product categories to surface true bottlenecks.
- **Risk Segmentation**  
  Distinguishing systemic process delays from structural geographic constraints.

### AI-Assisted Development
To reflect modern analytics workflows, Large Language Models (LLMs) were used to:

- Accelerate SQL prototyping  
- Support documentation drafting  
- Explore alternative analytical framings  

All assumptions, metrics, thresholds, and business recommendations were **validated, refined, and finalized by the author**, ensuring full analytical ownership.

---

## 📊 Key Business Insights

### 1. Southern Leverage Effect (Primary SLA Driver)
- The **South Region** accounts for **76.78% of total order volume**.
- A **1% improvement** in Southern on-time performance delivers **~26× greater national SLA impact** than the same improvement in low-volume regions.

**Insight:**  
National SLA performance is structurally sensitive to Southern region execution.

---

### 2. Heavy Cargo Bottleneck (Risk Concentration)
- Shipments **>5kg** exhibit:
  - **9.07% delay rate**
  - **LTI = 1.15**, indicating deliveries are **15% slower than the national average**
- Although heavy cargo represents only **12.52% of volume**, extreme delays materially degrade SLA.

**Insight:**  
SLA losses are driven by **delay outliers**, not average speed.

---

### 3. Regional Structural Hygiene
- Northern and Central regions show stable performance but act as **system stabilizers**.
- The Central region (Da Nang) plays a critical role in mitigating cross-region spillover delays.

**Insight:**  
These regions are not primary SLA levers, but poor design can amplify downstream congestion.

---

## 🚀 Strategic Action Plan (Prioritized)

### 🔴 Priority 1 — System Stabilization (Primary Lever)
**Southern Fulfillment Expansion**

Concentrate capital and senior operational resources in **HCMC and Binh Duong**, where ~77% of national volume flows.

A **1% SLA improvement in the South** yields up to **26× national impact** compared to equivalent efforts in low-volume regions.

---

### 🟠 Priority 2 — Risk Reduction (High ROI, Low Cost)
**Specialized Heavy-Cargo Flow**

Separate logistics paths for shipments **>5kg**, emphasizing:
- Early exception detection  
- Faster recovery cycles rather than baseline speed  

Reducing a small number of extreme delays materially improves SLA despite limited volume share.

---

### 🟡 Priority 3 — Structural Hygiene (Selective)
**Central Region Micro-Hub (Da Nang)**

Pilot a micro-fulfillment hub to:
- Reduce inter-regional latency spikes  
- Prevent cross-country congestion spillover  

This acts as a **stabilizer**, not a primary SLA lever.

---

## 🛠 Tech Stack

- **Data Source**: Kaggle Olist Dataset  
- **Data Processing**: SQL (PostgreSQL / Supabase)  
- **Visualization**: Tableau Public  
- **Analytical Frameworks**:
  - Pareto Principle (80/20)
  - Trend Analysis
  - What-if Simulation

---

## 📂 Repository Structure

```

├── scripts/        # SQL setup, transformation, and KPI logic
├── docs/           # Deep-dive analyses, data dictionary, and technical notes
├── dashboard/      # Tableau links & visual previews
└── data/           # Raw, processed data and samples

```

---

## 🤝 Contributing & Feedback

Feedback and discussion are welcome.  
If you have suggestions regarding methodology or business recommendations, feel free to open an Issue or connect via LinkedIn.

---

## 👤 Contact

- **Name:**  Phan Thi Thuy Anh
- **LinkedIn:**  https://www.linkedin.com/in/blessed-thuy-anh/
- **Email:**  thuyanhptta@gmail.com

This project is part of an independent **2025 Supply Chain & Logistics Research Series**.