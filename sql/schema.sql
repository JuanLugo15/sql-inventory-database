PRAGMA foreign_keys = ON;

DROP VIEW IF EXISTS inventory_summary;
DROP TRIGGER IF EXISTS stock_movement_after_insert;
DROP TABLE IF EXISTS stock_movements;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS suppliers;
DROP TABLE IF EXISTS categories;

CREATE TABLE categories (
    category_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE suppliers (
    supplier_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE
);

CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    sku TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    category_id INTEGER NOT NULL,
    supplier_id INTEGER,
    unit_price NUMERIC NOT NULL CHECK (unit_price >= 0),
    stock_quantity INTEGER NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),
    reorder_level INTEGER NOT NULL DEFAULT 0 CHECK (reorder_level >= 0),
    active INTEGER NOT NULL DEFAULT 1 CHECK (active IN (0, 1)),
    FOREIGN KEY (category_id) REFERENCES categories(category_id),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

CREATE TABLE stock_movements (
    movement_id INTEGER PRIMARY KEY,
    product_id INTEGER NOT NULL,
    movement_type TEXT NOT NULL CHECK (movement_type IN ('purchase', 'sale', 'return', 'adjustment')),
    quantity INTEGER NOT NULL CHECK (quantity <> 0),
    reference TEXT,
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_products_stock ON products(stock_quantity, reorder_level);
CREATE INDEX idx_movements_product_date ON stock_movements(product_id, created_at);

CREATE TRIGGER stock_movement_after_insert
AFTER INSERT ON stock_movements
BEGIN
    UPDATE products
       SET stock_quantity = stock_quantity + NEW.quantity
     WHERE product_id = NEW.product_id;
END;

CREATE VIEW inventory_summary AS
SELECT
    p.product_id,
    p.sku,
    p.name,
    c.name AS category,
    COALESCE(s.name, 'Unassigned') AS supplier,
    p.unit_price,
    p.stock_quantity,
    p.reorder_level,
    ROUND(p.unit_price * p.stock_quantity, 2) AS inventory_value,
    CASE WHEN p.stock_quantity <= p.reorder_level THEN 1 ELSE 0 END AS needs_reorder
FROM products p
JOIN categories c ON c.category_id = p.category_id
LEFT JOIN suppliers s ON s.supplier_id = p.supplier_id
WHERE p.active = 1;
