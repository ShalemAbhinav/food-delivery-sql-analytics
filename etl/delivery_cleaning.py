import pandas as pd
import numpy as np

# -----------------------------
# PATHS
# -----------------------------
INPUT_PATH = "/Users/shalem/Desktop/Sql_Project/deliverytime.csv"
OUTPUT_PARTNERS = "/Users/shalem/Desktop/Sql_Project/delivery_partners_clean.csv"
OUTPUT_ORDERS = "/Users/shalem/Desktop/Sql_Project/orders_clean.csv"
OUTPUT_DETAILS = "/Users/shalem/Desktop/Sql_Project/delivery_details_clean.csv"

# -----------------------------
# LOAD DATA
# -----------------------------
df = pd.read_csv(INPUT_PATH)

# -----------------------------
# BASIC CLEANING
# -----------------------------
df.columns = df.columns.str.strip().str.lower().str.replace(" ", "_")

# Rename important columns
df = df.rename(columns={
    "delivery_person_id": "delivery_partner_id",
    "delivery_person_age": "age",
    "delivery_person_ratings": "partner_rating",
    "type_of_vehicle": "vehicle_type",
    "type_of_order": "order_type",
    "time_taken(min)": "time_taken_min"
})

# Convert numeric columns
df["age"] = pd.to_numeric(df["age"], errors="coerce")
df["partner_rating"] = pd.to_numeric(df["partner_rating"], errors="coerce")
df["time_taken_min"] = (
    df["time_taken_min"]
    .astype(str)
    .str.extract(r"(\d+)")
    .astype(float)
)

# Remove invalid rows
df = df[
    (df["age"].between(18, 60)) &
    (df["partner_rating"].between(1, 5)) &
    (df["time_taken_min"] > 0)
]

# -----------------------------
# DELIVERY PARTNERS TABLE
# -----------------------------
delivery_partners = (
    df[["delivery_partner_id", "age", "partner_rating", "vehicle_type"]]
    .drop_duplicates()
    .reset_index(drop=True)
)

delivery_partners.insert(0, "partner_pk", range(1, len(delivery_partners) + 1))

# -----------------------------
# ORDERS TABLE
# -----------------------------
orders = df[[
    "id",
    "order_type",
    "restaurant_latitude",
    "restaurant_longitude"
]].copy()

orders = orders.rename(columns={"id": "order_id"})
orders["order_id"] = orders["order_id"].astype(str)

orders = orders.drop_duplicates().reset_index(drop=True)

# -----------------------------
# DELIVERY DETAILS TABLE
# -----------------------------
delivery_details = df[[
    "id",
    "delivery_partner_id",
    "delivery_location_latitude",
    "delivery_location_longitude",
    "time_taken_min"
]].copy()

delivery_details = delivery_details.rename(columns={"id": "order_id"})
delivery_details["order_id"] = delivery_details["order_id"].astype(str)

# -----------------------------
# SAVE FILES
# -----------------------------
delivery_partners.to_csv(OUTPUT_PARTNERS, index=False)
orders.to_csv(OUTPUT_ORDERS, index=False)
delivery_details.to_csv(OUTPUT_DETAILS, index=False)

print("Delivery data cleaned successfully.")
print(f"Partners: {len(delivery_partners)}")
print(f"Orders: {len(orders)}")
print(f"Delivery details: {len(delivery_details)}")
