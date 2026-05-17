---
name: finance-analyzer
description: Analyzes bank statements and creates spending reports with charts
source: https://docs.openwebui.com/features/open-terminal/use-cases/advanced-workflows/finance-dashboard
---

## Financial Analysis

When analyzing bank statements:

1. **Read all files** and normalize columns (date, description, amount, type). Handle different CSV formats (detect delimiters, date formats, debit/credit conventions)
2. **Categorize transactions** using keyword matching:
   - Groceries: walmart, costco, trader joe, whole foods
   - Dining: restaurant, cafe, doordash, uber eats
   - Subscriptions: netflix, spotify, recurring monthly charges
   - Transport: gas, uber, lyft, parking
3. **Generate charts**:
   - Monthly spending trend (line chart)
   - Category breakdown (pie chart)
   - Top 10 merchants (bar chart)
4. **Detect anomalies**: charges >2x average for that merchant, new recurring charges, possible duplicates (same amount within 3 days)
5. **Create an HTML dashboard** viewable in the file browser

Use proper currency formatting and round to 2 decimal places.
