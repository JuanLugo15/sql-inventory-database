import unittest

from demo import build_database


class InventorySqlTests(unittest.TestCase):
    def test_seed_data_and_trigger_update_stock(self):
        db = build_database()
        stock = db.execute("SELECT stock_quantity FROM products WHERE sku = 'MUG-002'").fetchone()[0]
        self.assertEqual(stock, 6)
        db.execute("INSERT INTO stock_movements (product_id, movement_type, quantity) VALUES (2, 'return', 2)")
        updated = db.execute("SELECT stock_quantity FROM products WHERE sku = 'MUG-002'").fetchone()[0]
        self.assertEqual(updated, 8)

    def test_low_stock_view_and_foreign_keys(self):
        db = build_database()
        low_stock = db.execute("SELECT sku FROM inventory_summary WHERE needs_reorder = 1").fetchall()
        self.assertEqual(low_stock, [('MUG-002',)])
        with self.assertRaises(Exception):
            db.execute("INSERT INTO products (sku, name, category_id, unit_price) VALUES ('BAD', 'Broken', 99, 1)")


if __name__ == "__main__":
    unittest.main()
