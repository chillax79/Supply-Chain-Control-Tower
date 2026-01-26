# 📦 Supply Chain Control Tower 2025  
### Vietnam Market Simulation

---

## 📌 Project Overview

This project builds a **centralized supply chain control tower**, simulating **2025 logistics operations in Vietnam** using an e-commerce dataset from Kaggle (Olist).

**Problem Statement:**  
The current **SLA compliance rate is 89.85%**, falling short of the **95% business target**, resulting in:
- Increased compensation costs  
- Reduced customer satisfaction  
- Operational inefficiencies across regions

The objective of this project is to **identify where operational interventions create the highest impact**.

---

## 🧠 Project Context

### Self-Study & Research
This project was developed as an independent research initiative to deepen understanding of:
- Supply chain performance metrics  
- Regional logistics bottlenecks  
- Data-driven operational decision-making in a high-growth market

### AI-Assisted Development
The project adopts an **AI-assisted workflow**, where Large Language Models (LLMs) were used to:
- Accelerate SQL prototyping
- Draft technical documentation
- Explore alternative modeling approaches

All logic, assumptions, and outputs were **validated and finalized by the author**, ensuring full analytical ownership.

---

## 🛠 Tech Stack

- **Data Source:** Kaggle Olist Dataset  
- **Data Processing:** SQL (PostgreSQL / Supabase)  
- **Visualization:** Tableau Desktop / Tableau Public  
- **Analytical Frameworks:**  
  - Pareto Principle (80/20)  
  - Trend Analysis  
  - What-if Simulation  

---

## 📊 Key Business Insights

- **The Southern Leverage Effect:**  
  The South Region accounts for **76.7% of total order volume**.  
  A **1% performance improvement** in the South has **38× the impact** of the same improvement in the Central region.

- **Heavy Cargo Bottleneck:**  
  Products weighing **>5kg** show:
  - The highest delay rate (~9%)  
  - A **Lead Time Index (LTI) of 1.15**, indicating delivery is **15% slower than the national average**

- **Financial Leakage:**  
  Significant monthly revenue is lost due to compensation penalties associated with `"Late"` deliveries.

---

## 🚀 Strategic Action Plan

1. **South Region Infrastructure Prioritization**  
   Reallocate resources and premium 3PL partners to logistics hubs in **Ho Chi Minh City** and **Binh Duong**.

2. **Specialized Heavy-Flow Logistics**  
   Separate sorting and dispatch flows for bulky goods to prevent congestion in standard fast-delivery lanes.

3. **Dynamic SLA Commitments**  
   Adjust promised delivery dates for remote areas to better reflect actual carrier capacity and reduce penalty exposure.

---

## 📂 Repository Structure

- `/scripts/sql` – Core SQL processing scripts (Setup, Transformation, KPI Queries)  
- `/docs` – Technical documentation and data dictionary  
- `/dashboard` – Tableau dashboard links and visual previews  

---

## 🤝 Contributing & Feedback

Feedback and discussion are welcome.  
If you have suggestions regarding methodology or business recommendations, feel free to open an Issue or connect via LinkedIn.

---

## 👤 Contact

- **Name:**  Phan Thi Thuy Anh
- **LinkedIn:**  https://www.linkedin.com/in/blessed-thuy-anh/
- **Email:**  thuyanhptta@gmail.com