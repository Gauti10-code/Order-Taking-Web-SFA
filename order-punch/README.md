# Order Punching System — Setup Guide

## Project Structure
```
order-punch/
├── backend/
│   ├── main.py          ← FastAPI app
│   ├── schema.sql        ← MySQL setup
│   └── requirements.txt
└── frontend/
    ├── index.html        ← Main app (order grid + admin)
    ├── pages/login.html  ← Login page
    ├── css/style.css
    └── js/utils.js
```

---

## Step 1 — MySQL Setup

```bash
mysql -u root -p < backend/schema.sql
```

This creates the `order_punch` database and all tables.
Default users created:
- Admin → admin@company.com / admin123
- Sales → sales1@company.com / sales123

---

## Step 2 — Backend Setup

```bash
cd backend
pip install -r requirements.txt
```

Edit `main.py` and update:
```python
DB_CONFIG = {
    "host": "localhost",
    "user": "root",
    "password": "YOUR_MYSQL_PASSWORD",   # ← change this
    "database": "order_punch"
}
SECRET_KEY = "your-secret-key"           # ← change this to a long random string
```

Run the server:
```bash
uvicorn main:app --reload --port 8000
```

API docs available at: http://localhost:8000/docs

---

## Step 3 — Frontend

No build step needed. Open `frontend/index.html` in a browser.

For best results, serve it via a simple HTTP server:
```bash
cd frontend
python -m http.server 3000
```
Then open http://localhost:3000

---

## Adding Users

Currently users are managed directly in MySQL.
To add a new user, generate a bcrypt hash in Python:

```python
import bcrypt
pw = bcrypt.hashpw(b"yourpassword", bcrypt.gensalt()).decode()
print(pw)
```

Then INSERT into the `users` table with the hash.

---

## Features

| Feature              | Sales Role | Admin Role |
|----------------------|------------|------------|
| View order grid      | ✅         | ✅         |
| Enter quantities     | ✅         | ✅         |
| Save orders          | ✅         | ✅         |
| Add distributors     | ❌         | ✅         |
| Add products/SKUs    | ❌         | ✅         |
| Export to Excel      | ❌         | ✅         |

---

## Grid UX

- **Enter** key moves to the same distributor column, next SKU row
- **Tab** moves left to right across distributors
- Cells with quantities are highlighted in light green
- Row totals auto-update as you type
- Date picker lets you enter / view orders for any date
