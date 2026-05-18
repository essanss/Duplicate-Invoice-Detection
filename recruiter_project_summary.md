# Recruiter Project Summary

## Project
AP Duplicate Invoice Detection Automation using SQL and n8n

## Business Problem
Accounts Payable teams may accidentally process the same vendor invoice more than once. Duplicate invoices create cash leakage, reconciliation issues, audit observations, and vendor disputes.

## Solution
Built an automated duplicate invoice detection workflow that checks AP invoice records using the business rule:

`vendor_name + invoice_number + invoice_amount + invoice_date`

The SQL query identifies duplicate groups, calculates potential duplicate exposure, classifies risk, and stores exceptions in an alert table. n8n runs the control daily and sends an email alert to the AP team before payment processing.

## Tools Used
- MySQL 8+
- n8n
- SQL CTEs
- Conditional logic
- Email automation
- AP controls and exception reporting

## Recruiter Keywords
Accounts Payable, AP Automation, Duplicate Invoice Detection, SQL, MySQL, n8n, Finance Automation, Invoice Processing, Payment Controls, Exception Reporting, Internal Controls, AP Audit Support, Vendor Payments.

## Resume Bullet Points
- Automated AP duplicate invoice detection using SQL and n8n to identify same vendor, invoice number, invoice amount, and invoice date before payment processing.
- Designed SQL exception logic with CTEs, duplicate grouping, risk categorization, and alert table creation to support AP controls.
- Built an n8n workflow to run daily duplicate checks and send email alerts to the AP team, improving payment accuracy and reducing duplicate payment risk.

## Project Metrics

| Metric | Value |
|--------|-------|
| Duplicate Invoices Detected | 4 duplicate groups |
| Total Duplicate Exposure | INR 264,000 |
| Highest Risk Item | CNI-90210 (INR 120,000) |
| Email Alerts | Daily at 9 AM |
| SQL Complexity | CTEs, GROUP_CONCAT, HAVING |
| n8n Nodes | 8 nodes with conditional logic |
