
import pandas as pd
from sklearn.preprocessing import MinMaxScaler

df = pd.read_csv("shopping_trends.csv")

# Missing values
df["Review Rating"] = df["Review Rating"].fillna(df["Review Rating"].mean())

# Binary encoding
df["subscription_flag"] = df["Subscription Status"].map({"Yes":1,"No":0})
df["discount_flag"] = df["Discount Applied"].map({"Yes":1,"No":0})

# Frequency score
freq_map = {
    "Weekly":5,
    "Fortnightly":4,
    "Monthly":3,
    "Quarterly":2,
    "Annually":1
}
df["frequency_score"] = df["Frequency of Purchases"].map(freq_map)

# Normalization
scaler = MinMaxScaler()
df[["spend_norm","purchase_norm","rating_norm"]] = scaler.fit_transform(
    df[["Purchase Amount (USD)","Previous Purchases","Review Rating"]]
)

# Loyalty Definition A
df["loyalty_score_A"] = (
    0.35*df["purchase_norm"] +
    0.25*(df["frequency_score"]/5) +
    0.20*df["subscription_flag"] +
    0.20*df["rating_norm"]
)

# Loyalty Definition B
df["loyalty_score_B"] = (
    0.40*df["spend_norm"] +
    0.30*df["purchase_norm"] +
    0.20*(1-df["discount_flag"]) +
    0.10*df["subscription_flag"]
)

# Value tiers
df["value_tier"] = pd.qcut(
    df["loyalty_score_B"],
    q=4,
    labels=["At-Risk","Potential","Loyal","Champion"]
)

# Promo dependency score
df["promo_dep_score"] = df["discount_flag"] * (1-df["spend_norm"])

# Satisfaction flag
df["satisfaction_flag"] = (df["Review Rating"] >= 3.8).astype(int)

df.to_csv("customer_value_engineered.csv", index=False)
print("Feature engineering completed.")
