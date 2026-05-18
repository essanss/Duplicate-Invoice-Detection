-- Duplicate Invoice Detection Automation
-- Database: MySQL 8+
-- Purpose: Detect duplicate AP invoices before payment processing

DROP TABLE IF EXISTS duplicate_invoice_alerts;
DROP TABLE IF EXISTS ap_invoices;
DROP TABLE IF EXISTS vendors;

CREATE TABLE vendors (
    vendor_id VARCHAR(20) PRIMARY KEY,
    vendor_name VARCHAR(150) NOT NULL,
    gst_number VARCHAR(30),
    payment_terms_days INT,
    is_active ENUM('Yes','No') DEFAULT 'Yes'
);

CREATE TABLE ap_invoices (
    invoice_id INT PRIMARY KEY,
    vendor_id VARCHAR(20),
    vendor_name VARCHAR(150) NOT NULL,
    invoice_number VARCHAR(80) NOT NULL,
    invoice_date DATE NOT NULL,
    due_date DATE NOT NULL,
    invoice_amount DECIMAL(15,2) NOT NULL,
    currency VARCHAR(10) DEFAULT 'INR',
    status VARCHAR(50) DEFAULT 'Pending Approval',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    payment_batch_id VARCHAR(50),
    CONSTRAINT fk_ap_vendor FOREIGN KEY (vendor_id) REFERENCES vendors(vendor_id)
);

CREATE TABLE duplicate_invoice_alerts (
    alert_id INT AUTO_INCREMENT PRIMARY KEY,
    duplicate_key VARCHAR(255) NOT NULL,
    vendor_name VARCHAR(150) NOT NULL,
    invoice_number VARCHAR(80) NOT NULL,
    invoice_date DATE NOT NULL,
    invoice_amount DECIMAL(15,2) NOT NULL,
    duplicate_count INT NOT NULL,
    invoice_ids VARCHAR(255) NOT NULL,
    total_duplicate_exposure DECIMAL(15,2) NOT NULL,
    alert_status VARCHAR(50) DEFAULT 'Open',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
