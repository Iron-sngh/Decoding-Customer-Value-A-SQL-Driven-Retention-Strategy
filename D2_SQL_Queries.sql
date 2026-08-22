
-- D2 SQL Queries
-- Assumed table: customer_shopping_data

/* Q1: Loyalty Segmentation */
WITH customer_base AS (
    SELECT *,
           NTILE(4) OVER (ORDER BY purchase_amount_usd DESC) AS spend_quartile
    FROM customer_shopping_data
),
loyalty_segmentation AS (
    SELECT *,
           CASE
               WHEN spend_quartile = 4 THEN 'Champion'
               WHEN spend_quartile = 3 THEN 'Loyal'
               WHEN spend_quartile = 2 THEN 'Potential'
               ELSE 'At-Risk'
           END AS loyalty_tier
    FROM customer_base
)
SELECT loyalty_tier,
       COUNT(*) AS customers,
       ROUND(AVG(purchase_amount_usd),2) AS avg_spend,
       ROUND(AVG(previous_purchases),2) AS avg_prev_purchases,
       ROUND(100.0 * AVG(CASE WHEN subscription_status='Yes' THEN 1 ELSE 0 END),2) AS subscription_rate_pct,
       ROUND(AVG(review_rating),2) AS avg_rating
FROM loyalty_segmentation
GROUP BY loyalty_tier
ORDER BY avg_spend DESC;


/* Q1b: True Loyalists */
WITH loyalty_segmentation AS (
    SELECT *,
           CASE
               WHEN NTILE(4) OVER (ORDER BY purchase_amount_usd DESC)=4
               THEN 'Champion'
           END AS loyalty_tier
    FROM customer_shopping_data
)
SELECT COUNT(*) AS true_loyalists,
       ROUND(100.0*COUNT(*)/
             NULLIF((SELECT COUNT(*) FROM loyalty_segmentation WHERE loyalty_tier='Champion'),0),2)
             AS pct_of_champions,
       ROUND(AVG(purchase_amount_usd),2) AS avg_spend
FROM loyalty_segmentation
WHERE loyalty_tier='Champion'
  AND discount_applied='No';


/* Q2: Value Predictors */
SELECT
    CORR(loyalty_score_b, purchase_amount_usd) AS corr_loyalty_score_b,
    CORR(previous_purchases, purchase_amount_usd) AS corr_previous_purchases,
    CORR(purchase_frequency, purchase_amount_usd) AS corr_purchase_frequency,
    CORR(review_rating, purchase_amount_usd) AS corr_review_rating,
    CORR(age, purchase_amount_usd) AS corr_age
FROM customer_shopping_data;


/* Q3: Geographic Opportunity */
WITH state_metrics AS (
    SELECT location AS state,
           COUNT(*) AS customers,
           AVG(purchase_amount_usd) AS avg_spend,
           AVG(CASE WHEN discount_applied='Yes' THEN 1.0 ELSE 0.0 END) AS promo_rate
    FROM customer_shopping_data
    GROUP BY location
)
SELECT state,
       customers,
       ROUND(avg_spend,2) AS avg_spend,
       ROUND(100*promo_rate,2) AS promo_rate_pct
FROM state_metrics
ORDER BY avg_spend DESC, promo_rate ASC;


/* Q4: Promo Strategy Inputs */
WITH loyalty_segmentation AS (
    SELECT *,
           CASE
               WHEN NTILE(4) OVER (ORDER BY purchase_amount_usd DESC)=4 THEN 'Champion'
               WHEN NTILE(4) OVER (ORDER BY purchase_amount_usd DESC)=3 THEN 'Loyal'
               WHEN NTILE(4) OVER (ORDER BY purchase_amount_usd DESC)=2 THEN 'Potential'
               ELSE 'At-Risk'
           END AS loyalty_tier
    FROM customer_shopping_data
)
SELECT loyalty_tier,
       discount_applied,
       COUNT(*) AS customers,
       ROUND(AVG(purchase_amount_usd),2) AS avg_spend
FROM loyalty_segmentation
GROUP BY loyalty_tier, discount_applied
ORDER BY loyalty_tier, discount_applied;


/* Q5: Ideal Customer Profile (Champion Segment) */
WITH loyalty_segmentation AS (
    SELECT *,
           CASE
               WHEN NTILE(4) OVER (ORDER BY purchase_amount_usd DESC)=4 THEN 'Champion'
               WHEN NTILE(4) OVER (ORDER BY purchase_amount_usd DESC)=3 THEN 'Loyal'
               WHEN NTILE(4) OVER (ORDER BY purchase_amount_usd DESC)=2 THEN 'Potential'
               ELSE 'At-Risk'
           END AS loyalty_tier
    FROM customer_shopping_data
)
SELECT
    COUNT(*) AS total_champions,
    ROUND(AVG(age),2) AS avg_age,
    ROUND(AVG(purchase_amount_usd),2) AS avg_order_value,
    ROUND(AVG(previous_purchases),2) AS avg_prev_purchases,
    ROUND(AVG(review_rating),2) AS avg_review_rating,
    ROUND(100.0*AVG(CASE WHEN subscription_status='Yes' THEN 1 ELSE 0 END),2) AS subscription_rate_pct
FROM loyalty_segmentation
WHERE loyalty_tier='Champion';
