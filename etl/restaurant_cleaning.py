import pandas as pd
import numpy as np
import re

# -----------------------------
# LOAD RAW DATA
# -----------------------------
INPUT_PATH = "/Users/shalem/Desktop/Sql_Project/zomato.csv"
OUTPUT_PATH = "/Users/shalem/Desktop/Sql_Project/restaurants_clean.csv"

df = pd.read_csv(INPUT_PATH)

# SELECT REQUIRED COLUMNS
df = df[[
    "name",
    "address",
    "listed_in(city)",
    "cuisines",
    "rate",
    "approx_cost(for two people)",
    "online_order"
]].copy()

df.columns = [
    "restaurant_name",
    "address",
    "area",
    "cuisines",
    "raw_rating",
    "cost_for_two",
    "online_order"
]

# CLEAN RATINGS
def extract_rating(val):
    if pd.isna(val):
        return None
    val = str(val)
    if val in ["NEW", "-", "nan"]:
        return None
    match = re.search(r"(\d\.\d)", val)
    return float(match.group(1)) if match else None

df["rating"] = df["raw_rating"].apply(extract_rating)

# CLEAN COST
df["cost_for_two"] = (
    df["cost_for_two"]
    .astype(str)
    .str.replace(",", "", regex=False)
    .replace("nan", np.nan)
    .astype(float)
)

# CLEAN CUISINES
df["cuisines"] = df["cuisines"].str.lower().str.strip()

# ONLINE ORDER FLAG
df["online_order"] = df["online_order"].map({"Yes": 1, "No": 0})

# REMOVE DUPLICATES
df = df.drop_duplicates(subset=["restaurant_name", "address"])

# GENERATE PRIMARY KEY
df.insert(0, "restaurant_id", range(1, len(df) + 1))

# FINAL TABLE
final_df = df[[
    "restaurant_id",
    "restaurant_name",
    "area",
    "cuisines",
    "rating",
    "cost_for_two",
    "online_order"
]]

# SAVE CLEAN DATA
final_df.to_csv(OUTPUT_PATH, index=False)

print("Zomato restaurant data cleaned successfully.")
print(f"Rows: {len(final_df)}")
print(f"Saved to: {OUTPUT_PATH}")
