-- Run this once to set up the database
CREATE DATABASE IF NOT EXISTS order_punch CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE order_punch;

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('sales', 'admin') NOT NULL DEFAULT 'sales',
    is_active TINYINT(1) DEFAULT 1,
    created_at DATETIME DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS distributors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(150) NOT NULL,
    is_active TINYINT(1) DEFAULT 1,
    created_at DATETIME DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(150) NOT NULL,
    is_active TINYINT(1) DEFAULT 1,
    created_at DATETIME DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    dist_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 0,
    entered_by INT NOT NULL,
    order_date DATE NOT NULL DEFAULT (CURDATE()),
    updated_at DATETIME DEFAULT NOW() ON UPDATE NOW(),
    UNIQUE KEY uq_order (dist_id, product_id, order_date),
    FOREIGN KEY (dist_id) REFERENCES distributors(id),
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (entered_by) REFERENCES users(id)
);

-- Default admin user (password: admin123 — change after first login)
INSERT IGNORE INTO users (name, email, password_hash, role) VALUES (
    'Admin',
    'admin@company.com',
    '$2b$12$LQv3c1yqBWVHxkd0LQ1Cr.IiHDXBZsRouVGN1SVyDGr4TQHX5BxSu',
    'admin'
);

-- Sample sales user (password: sales123)
INSERT IGNORE INTO users (name, email, password_hash, role) VALUES (
    'Sales User 1',
    'sales1@company.com',
    '$2b$12$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC__cALpNI3E5nQTJZi.',
    'sales'
);

-- Sales team (default password: sales123 — change after first login)
INSERT IGNORE INTO users (name, email, password_hash, role) VALUES
('Sharad',     'sharadchandra.bhosale@parag.com', '$2b$12$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC__cALpNI3E5nQTJZi.', 'sales'),
('Vilas',      'vilas.mandhare@parag.com',        '$2b$12$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC__cALpNI3E5nQTJZi.', 'sales'),
('Tribhuvan',  'tribhuvan.giri@parag.com',         '$2b$12$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC__cALpNI3E5nQTJZi.', 'sales');

-- Maps which distributors each sales user can see / enter orders for
CREATE TABLE IF NOT EXISTS user_distributor_map (
    id       INT AUTO_INCREMENT PRIMARY KEY,
    user_id  INT NOT NULL,
    dist_id  INT NOT NULL,
    UNIQUE KEY uq_user_dist (user_id, dist_id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (dist_id) REFERENCES distributors(id)
);

-- Full audit trail: every save that changes a value is recorded here
CREATE TABLE IF NOT EXISTS order_history (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    dist_id      INT NOT NULL,
    product_id   INT NOT NULL,
    order_date   DATE NOT NULL,
    old_quantity INT DEFAULT NULL,
    new_quantity INT NOT NULL,
    changed_by   INT NOT NULL,
    action       ENUM('created', 'updated') NOT NULL,
    changed_at   DATETIME DEFAULT NOW(),
    FOREIGN KEY (dist_id)    REFERENCES distributors(id),
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (changed_by) REFERENCES users(id)
);
