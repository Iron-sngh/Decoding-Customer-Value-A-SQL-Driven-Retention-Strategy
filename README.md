# Decoding Customer Value: A SQL-Driven Retention Strategy

## Project Overview

This repository contains the deliverables for the Consulting & Analytics Club IIT Guwahati Summer Projects '26. The project tackles a critical challenge for a direct-to-consumer fashion brand: transitioning from reactive, discount-driven sales to deliberate, loyalty-driven growth.

By analyzing behavioral data from 3,900 customers, this analysis establishes a structured retention strategy, identifies high-value customer segments, and defines the brand's ideal target audience.

---

## Tech Stack & Methodology

The end-to-end analysis leverages a robust data stack to transform raw data into actionable business intelligence:

- **Python (Data Preparation):** Handled missing review ratings and engineered critical features like `loyalty_score_B`, `frequency_score`, and `promo_dep_score` to quantify customer value.
- **SQL (Segmentation):** Structured queries categorized the customer base into four value tiers (Champion, Loyal, Potential, and At-Risk) to answer core business questions.
- **Power BI (Dashboarding):** Designed a four-panel interactive Founder Dashboard featuring a Customer Value Pyramid, Promo Matrix, Geographic Opportunity Map, and Category Funnel.

---

## Key Insights

The analysis yielded several critical discoveries regarding customer behavior and margin risks:

- **Discount Disconnect:** True loyalty is inversely related to promo-dependence; the "Champion" tier contributes 34.7% of total revenue but utilizes promotions only 19% of the time.
- **Geographic Pull:** Arizona and Alaska exhibit the highest organic demand and lowest discount reliance, signaling prime markets for customer acquisition.
- **Retention Anchors:** Accessories possess the highest repeat purchase rate, whereas outerwear acts primarily as an entry or seasonal category.
- **Value Predictors:** Previous purchase history and total purchase amount are the strongest predictors of future customer value, outperforming demographic variables.

---

## Strategy & Retention Playbook

To act on these insights, a three-phase promotional sunset plan was developed to protect margins:

- **Phase 1 (Champions):** Reduce discount depth by 10% and introduce loyalty points or exclusive early access.
- **Phase 2 (Loyals):** Replace cash discounts with value-adds like free priority shipping and member exclusives.
- **Phase 3 (Potential & At-Risk):** Transition strictly to behavior-triggered offers, such as 90-day inactivity or cart abandonment coupons.
- **Targeting Focus:** The Ideal Customer Profile (ICP) centers on multi-category buyers aged 35-55 in high-opportunity states who are subscription-eligible.

---

## Execution Instructions

Follow these steps to replicate the data engineering and segmentation analysis locally.

### 1. Data Pipeline (Python)

The Python script cleans the raw data and engineers the loyalty scores and flags required for segmentation.

1. Install the required dependencies:

   ```bash
   pip install pandas scikit-learn
   ```

2. Place the raw `shopping_trends.csv` file in the root directory.

3. Run the feature engineering script:

   ```bash
   python Python_D1_Feature_Engineering.py
   ```

4. This will output the cleaned dataset as `customer_value_engineered.csv`.

### 2. Analytical Queries (SQL)

The SQL queries answer the core business questions and generate the summary metrics.

1. Import the newly created `customer_value_engineered.csv` into your preferred SQL database (e.g., PostgreSQL, MySQL, SQLite) as a table named `customer_shopping_data`.

2. Execute the query blocks in `D2_SQL_Queries.sql` to generate the loyalty segmentation, value predictors, and geographic opportunity metrics.
