import pandas as pd

df = pd.read_csv("C:\\Users\\skill\\Play-code\\saudi-retail-mis-system\\Raw_Data\\Saudi_retail.csv")
# print(df.head())
# Basic cleaning
df.columns = df.columns.str.strip().str.lower()
df.drop_duplicates(inplace=True)
df.dropna(inplace=True)

df["date"] = pd.to_datetime(df["date"], errors="coerce")
df = df.dropna(subset=["date"])

df["quantity"] = pd.to_numeric(df["quantity"], errors="coerce")
df["unit_price_sar"] = pd.to_numeric(df["unit_price_sar"], errors="coerce")
df = df.dropna(subset=["quantity", "unit_price_sar"])

df = df[(df["quantity"] > 0) & (df["unit_price_sar"] > 0)]

df["city"] = df["city"].astype(str).str.strip().str.title()
df["product"] = df["product"].astype(str).str.strip()

df["revenue_sar"] = df["quantity"] * df["unit_price_sar"]

df.to_csv("sales_clean.csv", index=False)

print("Rows after cleaning:", len(df))
print("Cities:", df["city"].nunique())
print("Products:", df["product"].nunique())
print("Invoices:", df["invoice_id"].nunique())