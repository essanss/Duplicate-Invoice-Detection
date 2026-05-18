-- Option 1: Import CSV files using MySQL Workbench Table Data Import Wizard.
-- Option 2: Use LOAD DATA LOCAL INFILE after enabling local infile.

LOAD DATA LOCAL INFILE 'data/vendors_sample.csv'
INTO TABLE vendors
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(vendor_id, vendor_name, gst_number, payment_terms_days, is_active);

LOAD DATA LOCAL INFILE 'data/ap_invoices_sample.csv'
INTO TABLE ap_invoices
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(invoice_id, vendor_id, vendor_name, invoice_number, invoice_date, due_date, invoice_amount, currency, status, created_at, payment_batch_id);
