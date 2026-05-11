import bcrypt
import mysql.connector

conn = mysql.connector.connect(
    host="localhost", user="root", password="root", database="order_punch"
)
cur = conn.cursor()

users = [
    ("sharadchandra.bhosale@parag.com", "sales123"),
    ("vilas.mandhare@parag.com",        "sales123"),
    ("tribhuvan.giri@parag.com",        "sales123"),
]

for email, password in users:
    pw_hash = bcrypt.hashpw(password.encode(), bcrypt.gensalt()).decode()
    cur.execute("UPDATE users SET password_hash=%s WHERE email=%s", (pw_hash, email))
    print(f"Reset: {email}")

conn.commit()
conn.close()
print("Done.")
