import mysql.connector
import csv

conn = mysql.connector.connect(
    host="localhost", user="root",
    password="root",
    database="order_punch"
)
cur = conn.cursor()

with open("distributors.csv", encoding="utf-8-sig") as f:
    reader = csv.DictReader(f)
    for row in reader:
        row = {k.strip(): v.strip() for k, v in row.items()}
        cur.execute(
            "INSERT IGNORE INTO distributors (code, name) VALUES (%s, %s)",
            (row["code"], row["name"])
        )
    conn.commit()
    print("Distributors loaded.")

with open("products.csv", encoding="utf-8-sig") as f:
    reader = csv.DictReader(f)
    for row in reader:
        row = {k.strip(): v.strip() for k, v in row.items()}
        cur.execute(
            "INSERT IGNORE INTO products (code, name) VALUES (%s, %s)",
            (row["code"], row["name"])
        )
    conn.commit()
    print("Products loaded.")

conn.close()
print("Done!")