AP Duplicate Invoice Detection Automation using SQL and n8n
Project Overview
This project automates duplicate invoice detection in Accounts Payable before payment processing. It uses SQL to check duplicate invoices and n8n to send alert emails to the AP team.
Duplicate invoice rule used in this project:
```text
vendor\_name + invoice\_number + invoice\_amount + invoice\_date
```
If two or more invoices have the same vendor, invoice number, amount, and invoice date, the system flags them as possible duplicates.
---
Business Problem
Accounts Payable teams process high invoice volumes daily. Manual checking can miss duplicate invoices, which may lead to:
Duplicate payments
Vendor reconciliation issues
Month-end close errors
Audit findings
Cash leakage
This automation helps AP teams detect duplicate invoices before payment runs.
---
Tools Used
MySQL 8+ for invoice data storage and duplicate detection queries
n8n for workflow automation and email alerts
SQL CTEs for clean duplicate detection logic
Email alerts for AP team action
---
Project Architecture
```text
AP Invoice Data
      ↓
MySQL Invoice Table
      ↓
SQL Duplicate Detection Query
      ↓
Duplicate Alert Table
      ↓
n8n Daily Workflow
      ↓
Email Alert to AP Team
      ↓
AP Review Before Payment
```
---
Folder Structure
```text
duplicate-invoice-detection-github-project/
│
├── README.md
├── data/
│   ├── ap\_invoices\_sample.csv
│   └── vendors\_sample.csv
│
├── sql/
│   ├── 01\_create\_tables.sql
│   ├── 02\_load\_sample\_data.sql
│   ├── 03\_duplicate\_invoice\_detection.sql
│   ├── 04\_insert\_alerts\_for\_n8n.sql
│   └── 05\_n8n\_email\_alert\_query.sql
│
├── n8n/
│   └── duplicate\_invoice\_alert\_workflow.json
│
├── screenshots/
│   ├── 01\_project\_architecture.png
│   ├── 02\_sql\_duplicate\_output.png
│   ├── 03\_n8n\_workflow.png
│   └── 04\_email\_alert\_preview.png
│
└── docs/
    └── recruiter\_project\_summary.md
```
---
Sample Duplicate Output
Vendor	Invoice No	Invoice Date	Amount	Duplicate Count	Invoice IDs	Risk
CloudNet India	CN-90210	2026-04-10	120000.00	2	1012, 1013	High Risk
Global Tech Services	GT-4587	2026-04-03	87500.00	2	1002, 1007	Medium Risk
Prime Packaging	PP-5520	2026-04-08	31500.00	2	1009, 1010	Medium Risk
ABC Supplies	INV-1001	2026-04-01	25000.00	2	1001, 1003	Medium Risk
---
SQL Logic
The main SQL query:
Normalizes vendor name and invoice number
Creates a duplicate key
Groups invoices by duplicate key
Filters records with count greater than 1
Calculates potential duplicate exposure
Classifies the risk level
Main file:
```text
sql/03\_duplicate\_invoice\_detection.sql
```
---
n8n Workflow Logic
The n8n workflow performs these steps:
Runs every weekday at 9 AM
Executes SQL duplicate detection query
Inserts new duplicate exceptions into alert table
Fetches open duplicate alerts
Checks if duplicates exist
Builds an HTML email summary
Sends alert to AP team
Marks alerts as `In Review`
Workflow file:
```text
n8n/duplicate\_invoice\_alert\_workflow.json
```
---
How to Run This Project
Step 1: Create MySQL Database
```sql
CREATE DATABASE ap\_automation;
USE ap\_automation;
```
Step 2: Run Table Creation Script
```text
sql/01\_create\_tables.sql
```
Step 3: Load Sample Data
Use MySQL Workbench CSV import or run:
```text
sql/02\_load\_sample\_data.sql
```
Step 4: Run Duplicate Detection Query
```text
sql/03\_duplicate\_invoice\_detection.sql
```
Step 5: Import n8n Workflow
In n8n:
Go to Workflows
Click Import from File
Select `n8n/duplicate\_invoice\_alert\_workflow.json`
Update MySQL credentials
Update SMTP/email credentials
Activate the workflow
---
Screenshots
Project Architecture
![Project Architecture](screenshots/01_project_architecture.png)
SQL Duplicate Output
![SQL Duplicate Output](screenshots/02_sql_duplicate_output.png)
n8n Workflow
![n8n Workflow](screenshots/03_n8n_workflow.png)
Email Alert Preview
![Email Alert Preview](screenshots/04_email_alert_preview.png)
---
Controls Covered
Duplicate invoice prevention
AP payment control
Exception reporting
Audit support
Pre-payment validation
Vendor invoice monitoring
---
---
