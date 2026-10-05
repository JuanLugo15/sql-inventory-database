from pathlib import Path
import sqlite3


ROOT = Path(__file__).parent


def build_database() -> sqlite3.Connection:
    connection = sqlite3.connect(":memory:")
    connection.execute("PRAGMA foreign_keys = ON")
    connection.executescript((ROOT / "sql" / "schema.sql").read_text(encoding="utf-8"))
    connection.executescript((ROOT / "sql" / "seed.sql").read_text(encoding="utf-8"))
    return connection


if __name__ == "__main__":
    db = build_database()
    print("Low stock products:")
    for row in db.execute("SELECT sku, name, stock_quantity FROM inventory_summary WHERE needs_reorder = 1"):
        print(f"- {row[0]} | {row[1]} | {row[2]} units")
    total = db.execute("SELECT total_inventory_value FROM (SELECT ROUND(SUM(inventory_value), 2) AS total_inventory_value FROM inventory_summary)").fetchone()[0]
    print(f"Total inventory value: ${total:.2f}")
