# SQL Inventory Database

Relational inventory database project built with SQLite. It demonstrates schema design, foreign keys, constraints, indexes, triggers, views, stock movements, and reporting queries.

## What it demonstrates

- Normalized product, category, supplier, and movement tables.
- Foreign keys and CHECK constraints for data integrity.
- A trigger that updates stock from every movement.
- An inventory summary view for operational dashboards.
- Queries for low stock, inventory valuation, and movement history.
- Repeatable seed data and a Python standard-library demo.

## Run the demo

Run python demo.py and python -m unittest discover -s tests -v.

The demo uses an in-memory SQLite database, so it never changes a local database file. The SQL scripts can be adapted to PostgreSQL with small syntax changes.

## Files

- sql/schema.sql: tables, indexes, trigger, and view.
- sql/seed.sql: sample categories, suppliers, products, and movements.
- sql/queries.sql: operational and management reports.
- demo.py: executes the complete flow with sqlite3.
- tests/: automated integrity checks.
