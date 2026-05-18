-- Inserts duplicate results into an alert table.
-- n8n can run this query first, then read open alerts and email the AP team.

INSERT INTO duplicate_invoice_alerts (
    duplicate_key,
    vendor_name,
    invoice_number,
    invoice_date,
    invoice_amount,
    duplicate_count,
    invoice_ids,
    total_duplicate_exposure,
    alert_status
)
WITH normalized_invoices AS (
    SELECT
        invoice_id,
        UPPER(TRIM(vendor_name)) AS vendor_name_clean,
        UPPER(REPLACE(TRIM(invoice_number), ' ', '')) AS invoice_number_clean,
        invoice_date,
        ROUND(invoice_amount, 2) AS invoice_amount_clean,
        status,
        CONCAT(
            UPPER(TRIM(vendor_name)), '|',
            UPPER(REPLACE(TRIM(invoice_number), ' ', '')), '|',
            DATE_FORMAT(invoice_date, '%Y-%m-%d'), '|',
            ROUND(invoice_amount, 2)
        ) AS duplicate_key
    FROM ap_invoices
    WHERE status NOT IN ('Cancelled', 'Rejected')
), duplicate_groups AS (
    SELECT
        duplicate_key,
        vendor_name_clean,
        invoice_number_clean,
        invoice_date,
        invoice_amount_clean,
        COUNT(*) AS duplicate_count,
        GROUP_CONCAT(invoice_id ORDER BY invoice_id SEPARATOR ', ') AS invoice_ids,
        SUM(invoice_amount_clean) - MIN(invoice_amount_clean) AS potential_duplicate_exposure
    FROM normalized_invoices
    GROUP BY duplicate_key, vendor_name_clean, invoice_number_clean, invoice_date, invoice_amount_clean
    HAVING COUNT(*) > 1
)
SELECT
    duplicate_key,
    vendor_name_clean,
    invoice_number_clean,
    invoice_date,
    invoice_amount_clean,
    duplicate_count,
    invoice_ids,
    potential_duplicate_exposure,
    'Open'
FROM duplicate_groups dg
WHERE NOT EXISTS (
    SELECT 1
    FROM duplicate_invoice_alerts a
    WHERE a.duplicate_key = dg.duplicate_key
      AND a.alert_status IN ('Open', 'In Review')
);
