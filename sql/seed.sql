INSERT INTO categories (category_id, name) VALUES
    (1, 'Grocery'),
    (2, 'Household'),
    (3, 'Stationery');

INSERT INTO suppliers (supplier_id, name, email) VALUES
    (1, 'Andes Supply', 'orders@andessupply.example'),
    (2, 'Central Wholesale', 'sales@centralwholesale.example');

INSERT INTO products (product_id, sku, name, category_id, supplier_id, unit_price, reorder_level) VALUES
    (1, 'CAF-001', 'Coffee beans 500g', 1, 1, 18.50, 8),
    (2, 'MUG-002', 'Ceramic mug', 2, 2, 9.90, 10),
    (3, 'NOT-003', 'Pocket notebook', 3, 1, 4.75, 12);

INSERT INTO stock_movements (product_id, movement_type, quantity, reference) VALUES
    (1, 'purchase', 24, 'PO-1001'),
    (2, 'purchase', 16, 'PO-1002'),
    (3, 'purchase', 40, 'PO-1003'),
    (2, 'sale', -10, 'SALE-2001');
