-- Products that need replenishment
SELECT sku, name, stock_quantity, reorder_level
FROM inventory_summary
WHERE needs_reorder = 1
ORDER BY stock_quantity ASC;

-- Inventory value by category
SELECT category, ROUND(SUM(inventory_value), 2) AS category_value
FROM inventory_summary
GROUP BY category
ORDER BY category_value DESC;

-- Movement history with product context
SELECT p.sku, p.name, m.movement_type, m.quantity, m.reference, m.created_at
FROM stock_movements m
JOIN products p ON p.product_id = m.product_id
ORDER BY m.created_at DESC, m.movement_id DESC;

-- Total inventory value
SELECT ROUND(SUM(inventory_value), 2) AS total_inventory_value
FROM inventory_summary;
